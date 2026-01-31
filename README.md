<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

![Bambook preview](https://image.twintype.co/images/001.png)
# Bambook
## CJK Vertical Layout for Flutter | Flutter 垂直文字排版引擎


Documentation: https://bambook-doc.twintype.co/
Pub.dev: https://pub.dev/packages/bambook
Github: https://github.com/twinTypeFont/bambook


Banbook is a Flutter engine for high-quality vertical typesetting. It offers an elegant layout alternative for CJK and the essential solution for Mongolian script, supporting vertical writing, tate-chu-yoko, kinsoku, and optical adjustments.

Banbook 是一款針對 Flutter 的套件。可你提供您垂直排版能力，為 CJK 語種提供另一種選項(甚至在蒙古文中是唯一選項)。該文字排版引擎，支援垂直書寫、縱中橫、避頭尾與標點視覺修正等功能。

Banbook は、Flutter 向けの高度なテキストレイアウトエンジンです。CJK（中日韓）言語における高品質な縦書きを実現し、モンゴル語においては必須となる縦組み表示を完全にサポートします。縦中横、禁則処理、そして**句読点の視覚的調整（Optical Adjustment）**など、タイポグラフィの細部までこだわり抜いた垂直排版機能を提供します。

Banbook은 Flutter를 위한 고품질 텍스트 레이아웃 엔진으로, CJK(한중일)의 정교한 세로쓰기 구현에 최적화되어 있습니다. CJK 언어에서는 선택적으로, 몽골어에서는 필수적인 세로 배판 기능을 제공합니다. 세로쓰기, 종중횡(tate-chu-yoko), 금칙 처리(kinsoku), 그리고 문장 부호 시각 보정 등 타이포그래피의 완성도를 높이는 강력한 기능을 지원합니다.

## Features

- Vertical CJK layout with per-glyph orientation control.
- `upright` / `mixed` western (Latin) orientation.
- Tate-chu-yoko (TCY) for short Latin/number chunks.
- Kinsoku processing for CJK punctuation.
- Punctuation optical adjustment for different platforms.
 - Supports Traditional Chinese, Simplified Chinese, Japanese, Korean, Vietnamese Han characters (Chữ Nôm), and Mongolian vertical script.  

 - Design inspired by **W3C Unicode Vertical Text Layout (UTR #50)** to reduce the learning cost for developers and align with existing standards.  


## Getting started

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
	bambook: ^0.0.4
```

Then import the package:

```dart
import 'package:bambook/bambook.dart';
```

## Usage

### BambookText 基本用法 (Basic usage)

```dart
BambookText(
	"我知道我的未來不是夢，我認眞的過每一分鍾；我的未來不是夢，我的心跟着希望在動。",
	style: const TextStyle(fontSize: 24),
	textAlign: BambookTextAlign.top,
	direction: BambookTextDirection.rtl,
	orientation: BambookTextOrientation.mixed,
	language: BambookLanguage.tc,
	applyKinsoku: true,
	punctuationFixMode: PunctuationFixMode.auto,
	tateChuYoko: (true, 2),
)
```

### 參數說明 (Parameter reference)

完整資訊請參考 (For more details, please visit)：https://bambook-doc.twintype.co/



| 參數名 (Parameter) | 型別 (Type) | 預設值 (Default) | 說明 (Description) |
| ------------------ | ----------- | ---------------- | ------------------ |
| `data` | `String` | **必填 / required** |Text content to display. |
| `style` | `TextStyle?` | `null` | 文字樣式|
| `textAlign` | `BambookTextAlign` | `BambookTextAlign.top` | 垂直對齊方式：`top`, `center`, `bottom`, `justify`。<br>Vertical alignment for each column. |
| `direction` | `BambookTextDirection` | `BambookTextDirection.rtl` | 換行方向：`rtl` (由右往左) 或 `ltr`。<br>Line flow direction: right-to-left or left-to-right. |
| `orientation` | `BambookTextOrientation` | `BambookTextOrientation.mixed` | 西文取向：`mixed` (橫躺) 或 `upright` (直立)。`tateChuYoko` 時，Latin 與數字將以縱中橫方式顯示。Latin and munber orientation: mixed or upright. Works together with `tateChuYoko` for TCY. |
| `language` | `BambookLanguage` | `BambookLanguage.tc` | 文種設定：`tc` (繁體中文，居中標點)，`sc`/`jp`/`kr` (簡中/日文/韓文，右上標點)。Language hint for punctuation positioning. |
| `applyKinsoku` | `bool` | `true` | 是否開啟避頭尾功能（防止標點出現在行首）。Enable kinsoku rules to avoid punctuation at line head/tail. |
| `punctuationFixMode` | `PunctuationFixMode` | `PunctuationFixMode.auto` | `auto`、`force`、`disable`。修正部分平台下 CJK 字體標點位置異常問題。若是 iOS 平台或已有自訂字體，通常建議 `disable`。</br>auto, force, disable. Resolves CJK punctuation positioning anomalies on certain platforms. For iOS or environments with custom fonts already applied, disable is generally recommended.|
| `tateChuYoko` | `(bool, int)` | `(false, 0)` | 縱中橫。例：「25」、「US」等較短 Latin 或數字，可自動橫排。若設為 `(true, N)`，則長度 **小於等於 N** 的連續 Latin/數字會套用 TCY，在直排中以橫向顯示。Tate-chu-yoko configuration for short Latin/number chunks. |

## Roadmap / 展望

- We are actively exploring and designing support for features such as **bopomofo (注音) annotations**, **Jpanese ruby (furigana)**, **Hanyu Pinyin**, and **rich text editing/containers**. Stay tuned, and feel free to join the discussion and share your needs.  
<br>
- 未來版本，我們正進一步討論與規劃包括：**注音標註**、**日文假名（ruby）註解**、**漢語拼音**、以及開明式......等，更完善的**富文本框／排版容器**等功能。敬請期待，也非常歡迎您加入討論。

## License / 授權條款

- This package is released under the **MIT License** and is developed and maintained by **TwinType Foundry**.  

- For questions or business inquiries, please contact: **willy@twintype.co**.  

## Fonts used for examples / 範例使用之字型

- The examples in this project use the **LINE Seed** font family. Please refer to the official license terms here: https://seed.line.me/index_tw.html  
	本專案範例中使用 **LINE Seed** 字型，其授權與使用條款請參閱官方網站：https://seed.line.me/index_tw.html

## Warning / 請注意！

- Due to the rich typographic traditions of CJK and related logographic scripts, actual usage conventions can vary significantly by region, language, and context. We do our best to cover common patterns, but the engine cannot guarantee 100% correctness in all cases. Please always review the output carefully, especially for educational materials for children, thx!  
	東亞語系十分複雜，本專案致力於盡量貼近多數使用情境，但目前仍在持續改進中，無法保證在所有情況下皆正確。請您務必自行核對排版結果是否正確，特別是在涉及孩童教育等重要用途時。如您是語言或字體排印相關領域的專家，歡迎與我們聯繫提供建議與指正。


## 使用案例 (Usage Example)

![Bambook usage example](https://image.twintype.co/images/003.jpg)

