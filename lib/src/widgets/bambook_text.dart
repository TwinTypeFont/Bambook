import 'package:flutter/widgets.dart';
import '../base/types.dart';
import '../engine/painter.dart';

class BambookText extends LeafRenderObjectWidget {
  final String data;
  final TextStyle? style;
  final BambookTextAlign textAlign;
  final BambookLanguage language;
  final bool applyKinsoku;
  final BambookTextOrientation orientation;
  final (bool, int)? tateChuYoko;
  final BambookTextDirection direction;
  final double lineSpacing;
  final double letterSpacing;
  final PunctuationFixMode punctuationFixMode;

  const BambookText(
    this.data, {
    super.key,
    this.style,
    this.textAlign = BambookTextAlign.top,
    this.language = BambookLanguage.tc,
    this.applyKinsoku = true,
    this.orientation = BambookTextOrientation.mixed,
    this.tateChuYoko,
    this.direction = BambookTextDirection.rtl,
    this.lineSpacing = 10.0,
    this.letterSpacing = 0.0,
    this.punctuationFixMode = PunctuationFixMode.auto,
  });

  @override
  RenderBambookText createRenderObject(BuildContext context) {
    TextStyle effectiveStyle = style ?? const TextStyle();
    if (effectiveStyle.locale == null) {
      if (language == BambookLanguage.tc) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('zh', 'Hant'));
      } else if (language == BambookLanguage.sc) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('zh', 'CN'));
      } else if (language == BambookLanguage.jp) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('ja', 'JP'));
      } else if (language == BambookLanguage.kr) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('ko', 'KR'));
      }
    }

    return RenderBambookText(
      text: TextSpan(text: data, style: effectiveStyle),
      textAlign: textAlign,
      language: language,
      applyKinsoku: applyKinsoku,
      orientation: orientation,
      tateChuYoko: tateChuYoko,
      direction: direction,
      lineSpacing: lineSpacing,
      letterSpacing: letterSpacing,
      punctuationFixMode: punctuationFixMode,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderBambookText renderObject) {
    TextStyle effectiveStyle = style ?? const TextStyle();
    if (effectiveStyle.locale == null) {
      if (language == BambookLanguage.tc) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('zh', 'Hant'));
      } else if (language == BambookLanguage.sc) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('zh', 'CN'));
      } else if (language == BambookLanguage.jp) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('ja', 'JP'));
      } else if (language == BambookLanguage.kr) {
        effectiveStyle =
            effectiveStyle.copyWith(locale: const Locale('ko', 'KR'));
      }
    }

    renderObject
      ..text = TextSpan(text: data, style: effectiveStyle)
      ..textAlign = textAlign
      ..language = language
      ..applyKinsoku = applyKinsoku
      ..orientation = orientation
      ..tateChuYoko = tateChuYoko
      ..direction = direction
      ..lineSpacing = lineSpacing
      ..letterSpacing = letterSpacing
      ..punctuationFixMode = punctuationFixMode;
  }
}

class RenderBambookText extends RenderBox {
  (bool, int)? _tateChuYoko;
  RenderBambookText({
    required InlineSpan text,
    required BambookTextAlign textAlign,
    required BambookLanguage language,
    required bool applyKinsoku,
    required BambookTextOrientation orientation,
    (bool, int)? tateChuYoko,
    BambookTextDirection direction = BambookTextDirection.rtl,
    double lineSpacing = 10.0,
    double letterSpacing = 0.0,
    PunctuationFixMode punctuationFixMode = PunctuationFixMode.auto,
  }) : _tateChuYoko = tateChuYoko,
       _painter = BambookTextPainter(
         text: text,
         textAlign: textAlign,
         language: language,
         applyKinsoku: applyKinsoku,
         orientation: orientation,
         tateChuYoko: tateChuYoko,
         direction: direction,
         lineSpacing: lineSpacing,
         letterSpacing: letterSpacing,
         punctuationFixMode: punctuationFixMode,
       );
  
  set direction(BambookTextDirection value) {
    if (_painter.direction == value) return;
    _painter.direction = value;
    markNeedsLayout();
  }

  set lineSpacing(double value) {
    if (_painter.lineSpacing == value) return;
    _painter.lineSpacing = value;
    markNeedsLayout();
  }

  set letterSpacing(double value) {
    if (_painter.letterSpacing == value) return;
    _painter.letterSpacing = value;
    markNeedsLayout();
  }
  
  set punctuationFixMode(PunctuationFixMode value) {
    if (_painter.punctuationFixMode == value) return;
    _painter.punctuationFixMode = value;
    markNeedsLayout();
  }

  final BambookTextPainter _painter;

  set tateChuYoko((bool, int)? value) {
    if (_tateChuYoko == value) return;
    _tateChuYoko = value;
    _painter.tateChuYoko = value;
    markNeedsLayout();
  }

  set orientation(BambookTextOrientation value) {
    _painter.orientation = value;
    markNeedsLayout();
  }

  set text(InlineSpan value) {
    _painter.text = value;
    markNeedsLayout();
  }

  set textAlign(BambookTextAlign value) {
    _painter.textAlign = value;
    markNeedsLayout();
  }

  set language(BambookLanguage value) {
    if (_painter.language == value) return;
    _painter.language = value;
    markNeedsLayout();
  }

  set applyKinsoku(bool value) {
    if (_painter.applyKinsoku == value) return;
    _painter.applyKinsokuValue = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    _painter.layout(maxHeight: constraints.maxHeight);
    size = constraints.constrain(_painter.size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _painter.paint(context.canvas, offset);
  }
}