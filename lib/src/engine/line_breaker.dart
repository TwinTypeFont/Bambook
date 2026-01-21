import 'package:characters/characters.dart';
import 'orientation_resolver.dart';
import '../base/types.dart';

class RawTextRun {
  final String text;
  final BambookOrientation orientation;
  final bool isPunctuation;
  final bool isTateChuYoko;

  RawTextRun(
    this.text,
    this.orientation, {
    this.isPunctuation = false,
    this.isTateChuYoko = false,
  });
}

class BambookLineBreaker {
  /// separates a string into TextRun list(array)
  static List<RawTextRun> split(
    String text, {
    BambookTextOrientation orientation = BambookTextOrientation.mixed,
    (bool, int)? tateChuYoko,
  }) {
    if (text.isEmpty) return [];

    final List<RawTextRun> runs = [];
    final chars = text.characters;

    // upright mode: per-character layout, but still apply TCY for latin & digits
    if (orientation == BambookTextOrientation.upright) {
      final bool enableTCY =
          tateChuYoko != null && tateChuYoko.$1 == true && tateChuYoko.$2 > 0;
      final int tcyMaxLen = enableTCY ? tateChuYoko.$2 : 0;

      String tcyBuffer = ""; // collect consecutive latin & digits for TCY

      void flushTcyBuffer() {
        if (!enableTCY || tcyBuffer.isEmpty) return;
        if (tcyBuffer.length <= tcyMaxLen &&
            tcyBuffer.runes
                .every((code) => OrientationResolver.isLatinOrDigit(code))) {
          // treat whole buffer as a single TCY chunk
          runs.add(RawTextRun(
            tcyBuffer,
            BambookOrientation.R,
            isPunctuation: false,
            isTateChuYoko: true,
          ));
        } else {
          // fallback: emit as individual upright latin/digits
          for (var c in tcyBuffer.characters) {
            final cp = c.runes.first;
            final baseOrientation = OrientationResolver.resolve(cp);
            final bool isPunc = OrientationResolver.isCjkPunctuation(cp);
            final BambookOrientation ori =
                OrientationResolver.isVerticalTransformNeeded(cp)
                    ? BambookOrientation.Tu
                    : baseOrientation;
            runs.add(RawTextRun(c, ori, isPunctuation: isPunc));
          }
        }
        tcyBuffer = "";
      }

      for (var char in chars) {
        final cp = char.runes.first;
        final bool isLatinOrDigit = OrientationResolver.isLatinOrDigit(cp);

        if (enableTCY && isLatinOrDigit) {
          // accumulate for TCY grouping
          tcyBuffer += char;
          continue;
        }

        // non latin/digit: flush TCY buffer first, then emit this char
        flushTcyBuffer();

        final baseOrientation = OrientationResolver.resolve(cp);
        final bool isPunc = OrientationResolver.isCjkPunctuation(cp);
        final BambookOrientation ori =
            OrientationResolver.isVerticalTransformNeeded(cp)
                ? BambookOrientation.Tu
                : baseOrientation;
        runs.add(RawTextRun(char, ori, isPunctuation: isPunc));
      }

      // flush remaining TCY buffer
      flushTcyBuffer();
      return runs;
    }

    // tateChuYoko/orientation ≠ tateChuYoko 
    final bool enableTCY = tateChuYoko != null && tateChuYoko.$1 == true && tateChuYoko.$2 > 0 && orientation != BambookTextOrientation.tateChuYoko;
    final int tcyMaxLen = enableTCY ? tateChuYoko.$2 : 0;

    if (!enableTCY) {
      String currentChunk = "";
      BambookOrientation? lastOrientation;
      final List<RawTextRun> runs = [];
      for (var char in chars) {
        final cp = char.runes.first;
        final baseOrientation = OrientationResolver.resolve(cp);
        final bool isPunc = OrientationResolver.isCjkPunctuation(cp);
        final BambookOrientation ori = OrientationResolver.isVerticalTransformNeeded(cp)
            ? BambookOrientation.Tu
            : baseOrientation;
        bool forceSplit =
            (ori == BambookOrientation.U ||
            ori == BambookOrientation.Tu ||
            isPunc);
        if (lastOrientation != null &&
            (lastOrientation != ori || forceSplit)) {
          if (currentChunk.isNotEmpty) {
            runs.add(RawTextRun(
              currentChunk,
              lastOrientation,
              isPunctuation: OrientationResolver.isCjkPunctuation(currentChunk.runes.first),
            ));
          }
          currentChunk = char;
          lastOrientation = ori;
        } else {
          currentChunk += char;
          lastOrientation ??= ori;
        }
      }
      if (currentChunk.isNotEmpty) {
        runs.add(RawTextRun(
          currentChunk,
          lastOrientation!,
          isPunctuation: OrientationResolver.isCjkPunctuation(currentChunk.runes.first),
        ));
      }
      return runs;
    }

    String currentChunk = "";
    BambookOrientation? lastOrientation;
    String tcyBuffer = ""; // collects only latin & numbers for TCY function

    void flushCurrentChunk() {
      if (currentChunk.isNotEmpty && lastOrientation != null) {
        runs.add(RawTextRun(
          currentChunk,
          lastOrientation,
          isPunctuation: OrientationResolver.isCjkPunctuation(currentChunk.runes.first),
        ));
        currentChunk = "";
      }
    }

    void flushTcyBuffer() {
      if (!enableTCY || tcyBuffer.isEmpty) return;
      if (tcyBuffer.length <= tcyMaxLen && tcyBuffer.runes.every((code) =>
        OrientationResolver.isLatinOrDigit(code))) {
        // 一整段視為單一TCY chunk
        runs.add(RawTextRun(
          tcyBuffer,
          BambookOrientation.R,
          isPunctuation: false,
          isTateChuYoko: true,
        ));
      } else {
        for (var c in tcyBuffer.characters) {
          runs.add(RawTextRun(
            c,
            BambookOrientation.R,
            isPunctuation: false,
          ));
        }
      }
      tcyBuffer = "";
    }

    for (var char in chars) {
      final cp = char.runes.first;
      final baseOrientation = OrientationResolver.resolve(cp);
      final bool isPunc = OrientationResolver.isCjkPunctuation(cp);
      final BambookOrientation ori = OrientationResolver.isVerticalTransformNeeded(cp)
          ? BambookOrientation.Tu
          : baseOrientation;
      bool forceSplit =
          (ori == BambookOrientation.U ||
          ori == BambookOrientation.Tu ||
          isPunc);

      if (enableTCY && OrientationResolver.isLatinOrDigit(cp)) {
        flushCurrentChunk();
        lastOrientation = null;
        tcyBuffer += char;
        continue;
      }

      flushTcyBuffer();

      if (lastOrientation != null &&
          (lastOrientation != ori || forceSplit)) {
        flushCurrentChunk();
        currentChunk = char;
        lastOrientation = ori;
      } else {
        currentChunk += char;
        lastOrientation ??= ori;
      }
    }

    // flush
    flushTcyBuffer();
    flushCurrentChunk();
    return runs;
  }
}
