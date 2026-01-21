import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import '../base/types.dart';

class BambookTextRun {
  /// raw context/原始文本
  final String text;

  /// framework level style
  final TextStyle style;

  /// orientation/垂直取向
  final BambookOrientation orientation;

  /// is punctuation/標點符號判定
  final bool isPunctuation;

  /// is tcy?/縱中橫塊判定
  final bool isTateChuYoko;

  /// layout mode/整體排版模式
  final BambookTextOrientation textOrientation;

  /// underlying render object/底層渲染對象
  late ui.Paragraph _paragraph;

  BambookTextRun({
    required this.text,
    required this.style,
    required this.orientation,
    this.isPunctuation = false,
    this.isTateChuYoko = false,
    this.textOrientation = BambookTextOrientation.mixed,
  });


  ui.Paragraph get paragraph => _paragraph;
  void layout() {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle())
      // flutter textStyle to ui.TextStyle
      ..pushStyle(style.getTextStyle())
      ..addText(text);

    _paragraph = builder.build();
    _paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));
  }

  /// logical height in vertical flow/垂直流邏輯高度
  double get height {
    // 1/4 Space
    if (text == ' ') {
      return _paragraph.height * 0.25;
    }

    // logic must match drawing/判定與繪製邏輯一致
    final bool willRotate =
        (orientation == BambookOrientation.R && textOrientation == BambookTextOrientation.mixed && !isTateChuYoko) ||
        (orientation == BambookOrientation.Tu);

    return willRotate ? _paragraph.maxIntrinsicWidth : _paragraph.height;
  }

  /// logical width in vertical flow/垂直流邏輯寬度
  double get width {
    final bool willRotate =
        (orientation == BambookOrientation.R && textOrientation == BambookTextOrientation.mixed && !isTateChuYoko) ||
        (orientation == BambookOrientation.Tu);

    return willRotate ? _paragraph.height : _paragraph.maxIntrinsicWidth;
  }

  /// Dispose native resources
  void dispose() {
    _paragraph.dispose();
  }
}