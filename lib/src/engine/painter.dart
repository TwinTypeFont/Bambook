import 'dart:ui' as ui;
import 'package:flutter/painting.dart' as painting; 
import 'package:flutter/widgets.dart' show InlineSpan, TextSpan;
import '../base/types.dart';
import 'paragraph.dart';
import 'line_breaker.dart';
import 'text_run.dart';

class BambookTextPainter {
    // orientation getter/setter
    BambookTextOrientation get orientation => _orientation;
    set orientation(BambookTextOrientation value) {
      _orientation = value;
      _paragraph = null;
    }
  double lineSpacing;
  double letterSpacing;
  PunctuationFixMode punctuationFixMode;
  (bool, int)? tateChuYoko;
  BambookTextPainter({
    InlineSpan? text,
    BambookTextDirection direction = BambookTextDirection.rtl,
    BambookTextOrientation orientation = BambookTextOrientation.mixed,
    BambookTextAlign textAlign = BambookTextAlign.top,
    this.language = BambookLanguage.tc,// 預設TC
    this.applyKinsoku = true,
    this.tateChuYoko,
    this.lineSpacing = 10.0,
    this.letterSpacing = 0.0,
    this.punctuationFixMode = PunctuationFixMode.auto,
  }) : _text = text,
       _direction = direction,
       _orientation = orientation,
       _textAlign = textAlign;
  bool applyKinsoku;
  // Getter/Setter
  bool get applyKinsokuValue => applyKinsoku;
  set applyKinsokuValue(bool value) {
    applyKinsoku = value;
    _paragraph = null;
  }

  InlineSpan? _text;
  BambookTextDirection _direction;
  BambookTextOrientation _orientation;
  BambookTextAlign _textAlign;
  BambookLanguage language;
  BambookParagraph? _paragraph;

  set text(InlineSpan? value) { _text = value; _paragraph = null; }
  set textAlign(BambookTextAlign value) { _textAlign = value; _paragraph = null; }

  BambookTextDirection get direction => _direction;
  set direction(BambookTextDirection value) {
    _direction = value;
    _paragraph = null;
  }

  void layout({double maxHeight = double.infinity}) {
    if (_text == null) return;

    final List<BambookTextRun> allRuns = [];
    _text!.visitChildren((InlineSpan span) {
      if (span is TextSpan && span.text != null) {
        final currentStyle = span.style ?? const painting.TextStyle();
        final rawRuns = BambookLineBreaker.split(
          span.text!,
          orientation: _orientation,
          tateChuYoko: tateChuYoko,
        );
        for (var raw in rawRuns) {
          allRuns.add(BambookTextRun(
            text: raw.text,
            style: currentStyle, 
            orientation: raw.orientation,
            isPunctuation: raw.isPunctuation,
            isTateChuYoko: raw.isTateChuYoko,
            textOrientation: _orientation,
          ));
        }
      }
      return true;
    });

    _paragraph?.dispose();
    _paragraph = BambookParagraph(
      allRuns,
      direction: _direction,
      textOrientation: _orientation,
      textAlign: _textAlign,
      language: language,
      applyKinsoku: applyKinsoku,
      tateChuYoko: tateChuYoko,
      lineSpacing: lineSpacing,
      letterSpacing: letterSpacing,
      punctuationFixMode: punctuationFixMode,
    );

    _paragraph!.layout(maxHeight);
  }

  void paint(ui.Canvas canvas, ui.Offset offset) {
    _paragraph?.draw(canvas, offset);
  }

  ui.Size get size => _paragraph?.size ?? ui.Size.zero;

  void dispose() {
    _paragraph?.dispose();
    _paragraph = null;
  }
}