/// UTR #50 Orientation/Unicode 垂直取向屬性
enum BambookOrientation {
  U,/// Upright/垂直直立
  
  R,/// Rotated| 順時針旋轉 90 度

  Tu,/// Transformed Upright/直立並使用垂直變體

  Tr,/// Transformed Rotated/變換後旋轉
}

/// Layout Mode
enum BambookTextOrientation {
  /// Mixed: CJK upright, Latin rotated (default)
  mixed,

  /// Upright: All characters upright
  upright,

  /// Tatechuyoko（縱中橫）: Short Latin as horizontal block
  tateChuYoko,
}

/// Line Direction
enum BambookTextDirection {
  /// rtl: Right to Left (CJK default)
  rtl,

  /// LTR: Left to Right (Mongolian, Modern)
  ltr,
}

/// Text Alignment
enum BambookTextAlign {
  /// Top alignment/靠上對齊
  top,

  /// Center alignment/居中對齊
  center,

  /// Bottom alignment/靠下對齊
  bottom,

  /// Justify alignment/兩端對齊
  justify,
}

enum BambookLanguage {
  /// Traditional Chinese (center)/繁體中文
  tc,

  /// Simplified Chinese/簡體中文
  sc,

  /// Japanese/日文
  jp,

  /// Korean/韓文
  kr,
}

/// Punctuation modification mode/標點修正模式
enum PunctuationFixMode {
  /// Automatic (Fix if no font family specified)/自動 (若無指定字體則修正)
  auto,

  /// Force enable fix/強制修正
  force,

  /// Force disable fix/強制不修正
  disable,
}
