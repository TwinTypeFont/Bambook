import 'package:flutter/material.dart';
import 'package:bambook/bambook.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  runApp(const BambookDemo());
}

class BambookDemo extends StatefulWidget {
  const BambookDemo({super.key});

  @override
  State<BambookDemo> createState() => _BambookDemoState();
}

class _BambookDemoState extends State<BambookDemo> {
  double _textHeight = 400;
  final double _minHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Bambook 垂直排版測試')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight - 220;
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: _textHeight > availableHeight
                          ? availableHeight
                          : _textHeight,
                      constraints: const BoxConstraints(maxWidth: 360),
                      decoration: const BoxDecoration(border: null),
                      alignment: Alignment.center,
                      child: const BambookText(
                        "四季遞嬗，日月更迭，唯有筆墨如石堅。--TwinType",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 8, 19, 76),
                          fontFamily: 'LINESeed-TW_Rg',
                        ),

                        textAlign: BambookTextAlign.justify, /// 文本對齊
                        language: BambookLanguage.tc, /// 文種模式，目前涉及標點樣式
                        direction:BambookTextDirection.rtl,
                        orientation: BambookTextOrientation.mixed, /// latin處理模式
                        applyKinsoku: true, /// 避頭尾
                        tateChuYoko: (false, 0), /// 縱中橫
                        punctuationFixMode:PunctuationFixMode.auto, /// CJK預設字體修正，如果您未安裝對應語言字型，建議開啟
                        lineSpacing: 24.0, /// 垂直行距
                        letterSpacing: -10, /// 垂直字元間距
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _textHeight += details.delta.dy;
                        if (_textHeight < _minHeight) _textHeight = _minHeight;
                        if (_textHeight > availableHeight) {
                          _textHeight = availableHeight;
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Icon(Icons.drag_handle, color: Colors.grey),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Powered By TwinType",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
