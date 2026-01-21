import 'dart:ui' as ui;
import 'dart:math' as math;
import '../base/types.dart';
import 'text_run.dart';
import 'data/character_data.dart';
import 'orientation_resolver.dart';

class BambookParagraph {
  final List<BambookTextRun> allRuns;
  final BambookTextDirection direction;
  final BambookTextOrientation textOrientation;
  final BambookTextAlign textAlign;

  /// tateChuYoko config
  final (bool, int)? tateChuYoko;

  /// apply kinsoku mode
  final bool applyKinsoku;

  /// line spacing
  final double lineSpacing;

  /// letter spacing
  final double letterSpacing;

  /// Punctuation fix mode
  final PunctuationFixMode punctuationFixMode;

  /// language for kinsoku 必頭尾語言
  final BambookLanguage language;

  List<_BambookLineInfo> _lines = [];
  double _totalWidth = 0;
  double _totalHeight = 0;

  /// applied max height for layout
  double _appliedMaxHeight = 0;
  bool _disposed = false;

  BambookParagraph(
    this.allRuns, {
    this.direction = BambookTextDirection.rtl,
    this.textOrientation = BambookTextOrientation.mixed,
    this.textAlign = BambookTextAlign.top,
    this.applyKinsoku = true,
    this.language = BambookLanguage.tc,
    this.tateChuYoko,
    this.lineSpacing = 10.0,
    this.letterSpacing = 0.0,
    this.punctuationFixMode = PunctuationFixMode.auto,
  });

  void dispose() {
    if (_disposed) return;
    for (final run in allRuns) {
      run.dispose();
    }
    allRuns.clear();
    _lines.clear();
    _disposed = true;
  }

  void layout(double maxHeight) {
    assert(!_disposed);
    _lines.clear();
    _totalWidth = 0;
    _totalHeight = 0;
    _appliedMaxHeight = maxHeight;

    List<BambookTextRun> currentLineRuns = [];
    double currentLineHeight = 0;
    double maxLineWidthInLine = 0;

    for (int i = 0; i < allRuns.length; i++) {
      final run = allRuns[i];
      run.layout();
      final double fontSize = run.style.fontSize ?? 14.0;
      double runColumnWidth = fontSize * (run.style.height ?? 1.0);
      final bool isHorizontalInVertical =
          (textOrientation == BambookTextOrientation.tateChuYoko &&
                  run.orientation == BambookOrientation.R) ||
              run.isTateChuYoko;
      if (isHorizontalInVertical) {
        runColumnWidth = math.max(runColumnWidth, run.width);
      }

      // line break detection.
      double spacingBeforeRun = 0;
      if (currentLineRuns.isNotEmpty) {
        spacingBeforeRun = letterSpacing;
      }

      if (currentLineRuns.isNotEmpty &&
          currentLineHeight + spacingBeforeRun + run.height > maxHeight) {
        bool movedLastRunToNextLine = false;

        if (applyKinsoku && BambookCharacterData.kinsokuHeadProhibited.contains(run.text)) {
          final lastRunFromPrevLine = currentLineRuns.removeLast();
          double tempH = 0;
          double tempW = 0;
          for (var r in currentLineRuns) {
            tempH += r.height;
            final double rFontSize = r.style.fontSize ?? 14.0;
            double rW = rFontSize * (r.style.height ?? 1.0);
            if ((textOrientation == BambookTextOrientation.tateChuYoko &&
                    r.orientation == BambookOrientation.R) ||
                r.isTateChuYoko) {
              rW = math.max(rW, r.width);
            }
            tempW = math.max(tempW, rW);
          }

          if (_lines.isNotEmpty) _totalWidth += lineSpacing;
          _lines.add(_BambookLineInfo(currentLineRuns, tempH, tempW));
          _totalWidth += tempW;
          _totalHeight = math.max(_totalHeight, tempH);

          currentLineRuns = [lastRunFromPrevLine, run];
          currentLineHeight = lastRunFromPrevLine.height + run.height;

          double initialW =
              (lastRunFromPrevLine.style.fontSize ?? 14.0) * (lastRunFromPrevLine.style.height ?? 1.0);
          if ((textOrientation == BambookTextOrientation.tateChuYoko &&
                  lastRunFromPrevLine.orientation == BambookOrientation.R) ||
              lastRunFromPrevLine.isTateChuYoko) {
            initialW = math.max(initialW, lastRunFromPrevLine.width);
          }
          maxLineWidthInLine = math.max(initialW, runColumnWidth);
          movedLastRunToNextLine = true;
        }

        if (!movedLastRunToNextLine) {
          if (_lines.isNotEmpty) _totalWidth += lineSpacing;
          _lines.add(_BambookLineInfo(
              currentLineRuns, currentLineHeight, maxLineWidthInLine));
          _totalWidth += maxLineWidthInLine;
          _totalHeight = math.max(_totalHeight, currentLineHeight);

          currentLineRuns = [run];
          currentLineHeight = run.height;
          maxLineWidthInLine = runColumnWidth;
        }
        continue;
      }

      currentLineRuns.add(run);
      if (currentLineRuns.length > 1) {
        currentLineHeight += letterSpacing;
      }
      currentLineHeight += run.height;
      maxLineWidthInLine = math.max(maxLineWidthInLine, runColumnWidth);
    }

    if (currentLineRuns.isNotEmpty) {
      if (_lines.isNotEmpty) {
          _totalWidth += lineSpacing; 
          /// add line spacing
      }
      _lines.add(_BambookLineInfo(currentLineRuns, currentLineHeight, maxLineWidthInLine));
      _totalWidth += maxLineWidthInLine;
      _totalHeight = math.max(_totalHeight, currentLineHeight);
    }
  }

  void draw(ui.Canvas canvas, ui.Offset offset) {
    assert(!_disposed);
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    double currentDx = (direction == BambookTextDirection.rtl)
        ? _totalWidth
        : 0.0;

    for (int i = 0; i < _lines.length; i++) {
      final line = _lines[i];

      if (direction == BambookTextDirection.rtl) {
        currentDx -= line.width;
      }

      double currentDy = 0;
      double justifySpacing = letterSpacing;
      final double effectiveHeight = _appliedMaxHeight.isFinite ? _appliedMaxHeight : line.height;

      if (textAlign == BambookTextAlign.justify && i < _lines.length - 1 && line.runs.length > 1) {
        justifySpacing = letterSpacing + (effectiveHeight - line.height) / (line.runs.length - 1);
      } else if (textAlign == BambookTextAlign.center) {
        currentDy = (effectiveHeight - line.height) / 2;
      } else if (textAlign == BambookTextAlign.bottom) {
        currentDy = effectiveHeight - line.height;
      }

      for (int runIdx = 0; runIdx < line.runs.length; runIdx++) {
        final run = line.runs[runIdx];
        _drawRun(canvas, run, ui.Offset(currentDx, currentDy), line.width);
        
        if (runIdx < line.runs.length - 1) {
          currentDy += run.height + justifySpacing;
        } else {
          currentDy += run.height;
        }
      }

      if (direction == BambookTextDirection.ltr) {
        currentDx += line.width + lineSpacing;
      } else {
        currentDx -= lineSpacing;
      }
    }
    canvas.restore();
  }

  void _drawRun(
    ui.Canvas canvas,
    BambookTextRun run,
    ui.Offset offset,
    double lineWidth,
  ) {
    final bool enableTCY =
        tateChuYoko != null && tateChuYoko!.$1 && tateChuYoko!.$2 > 0;
    final bool isTateChuYokoChunk = enableTCY && run.isTateChuYoko;
    final bool isHorizontalInVertical =
        (textOrientation == BambookTextOrientation.tateChuYoko &&
                run.orientation == BambookOrientation.R) ||
            isTateChuYokoChunk;

    // R or Tu
    final bool shouldRotate =
        (run.orientation == BambookOrientation.R &&
                textOrientation == BambookTextOrientation.mixed &&
                !isHorizontalInVertical) ||
            (run.orientation == BambookOrientation.Tu);

    // upright latin/digit
    final bool isUprightEnglish =
        textOrientation == BambookTextOrientation.upright &&
            run.orientation == BambookOrientation.R &&
            OrientationResolver.isLatinOrDigit(run.text.runes.first);

    if (shouldRotate) {
      // optical alignment logic 視覺校正
      final double alphabeticBaseline = run.paragraph.alphabeticBaseline;
      final double fontSize = run.style.fontSize ?? 14.0;
      final double capHeight = fontSize * 0.7;
      final double capTop = alphabeticBaseline - capHeight;
      final double opticalCenterInParagraph = (capTop + alphabeticBaseline) / 2;
      final double H = run.paragraph.height;
      final double centerAdjustment =
          (lineWidth / 2) - (H - opticalCenterInParagraph);

      canvas.save();
      canvas.translate(offset.dx + centerAdjustment, offset.dy);
      canvas.rotate(math.pi / 2); // rotate 90 deg
      canvas.drawParagraph(run.paragraph, ui.Offset(0, -H));
      canvas.restore();
    } else if (isHorizontalInVertical) {
      // horizontal display center
      final double centerAdjustment = (lineWidth / 2) - (run.width / 2);
      canvas.drawParagraph(
        run.paragraph,
        ui.Offset(offset.dx + centerAdjustment, offset.dy),
      );
    } else if (isUprightEnglish) {
      // optical center via Bounding box\ em框
      final boxes = run.paragraph.getBoxesForRange(0, run.text.length);
      double offsetX = 0;
      if (boxes.isNotEmpty) {
        final box = boxes.first;
        final double glyphVisualCenterX = (box.left + box.right) / 2;
        final double targetCenterX = lineWidth / 2;
        offsetX = targetCenterX - glyphVisualCenterX;
      } else {
        offsetX = (lineWidth - run.paragraph.maxIntrinsicWidth) / 2;
      }
      canvas.drawParagraph(
        run.paragraph,
        ui.Offset(offset.dx + offsetX, offset.dy),
      );
    } else {
      double offsetX = 0;
      double offsetY = 0;
      
      bool shouldFix = false;
      if (punctuationFixMode == PunctuationFixMode.force) {
        shouldFix = true;
      } else if (punctuationFixMode == PunctuationFixMode.disable) {
        shouldFix = false;
      } else {

        
        final bool isSystemFont = run.style.fontFamily == null;
        if (language != BambookLanguage.tc || isSystemFont) {
          shouldFix = true;
        }
      }

      if (run.isPunctuation && shouldFix) {
        final double fontSize = run.style.fontSize ?? 14.0;
        double ratio = 0.35;
        if (language != BambookLanguage.tc) {
          ratio = 0.5;
        }
        final double shift = fontSize * ratio;
        offsetX = shift;
        offsetY = -shift;
      }
      final double centerAdjustment = (lineWidth / 2) - (run.width / 2);
      canvas.drawParagraph(
        run.paragraph,
        ui.Offset(offset.dx + centerAdjustment + offsetX, offset.dy + offsetY),
      );
    }
  }

  ui.Size get size => ui.Size(_totalWidth, _totalHeight);
}

class _BambookLineInfo {
  final List<BambookTextRun> runs;
  final double height;
  final double width;
  _BambookLineInfo(this.runs, this.height, this.width);
}
