import '../base/types.dart';
import 'data/character_data.dart';

/// Bambook 'Main' orientation resolver
class OrientationResolver {
  /// resolve orientation (UTR #50)
  static BambookOrientation resolve(int codePoint) {
    // cjk Unified Ideographs
    if (codePoint >= 0x4E00 && codePoint <= 0x9FFF) {
      return BambookOrientation.U;
    }

    // basic latin and Aascii 
    if (codePoint >= 0x0021 && codePoint <= 0x007E) {
      return BambookOrientation.R;
    }

    // transform needed(Tu)
    if (isVerticalTransformNeeded(codePoint)) {
      return BambookOrientation.Tu;
    }

    // fullwidth and cjk Punctuation marks
    if (isCjkPunctuation(codePoint)) {
      return BambookOrientation.U;
    }

    // emoji, approximate range
    if (codePoint >= 0x1F000 && codePoint <= 0x1F9FF) {
      return BambookOrientation.U;
    }

    return BambookOrientation.U;
  }

  /// checks if transform needed(Tu) 
  static bool isVerticalTransformNeeded(int cp) {
    return BambookCharacterData.verticalTransformSet.contains(cp);
  }

  /// checks if CJK Punctuation marks
  static bool isCjkPunctuation(int cp) {
    return (cp >= 0x3000 && cp <= 0x303F) ||
        (cp >= 0xFF00 && cp <= 0xFFEF);
  }

  /// checks if Latin letter or numbers
  static bool isLatinOrDigit(int cp) {
    return (cp >= 0x41 && cp <= 0x5A) || /// A-Z
        (cp >= 0x61 && cp <= 0x7A) || /// a-z
        (cp >= 0x30 && cp <= 0x39); /// 0-9
  }
}
