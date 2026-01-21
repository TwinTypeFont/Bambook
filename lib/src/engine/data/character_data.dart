/// Character Data and Constants | 字元屬性數據與常量
class BambookCharacterData {
  /// hex unicode codes for characters need 90 degree transformation in vertical mode
  static const Set<int> verticalTransformSet = {
    0x0028, 0x0029, // ( )
    0x005B, 0x005D, // [ ]
    0x007B, 0x007D, // { }
    0x3008, 0x3009, // 〈 〉
    0x300A, 0x300B, // 《 》
    0x300C, 0x300D, // 「 」
    0x300E, 0x300F, // 『 』
    0x3010, 0x3011, // 【 】
    0x3014, 0x3015, // 〔 〕
    0xFF08, 0xFF09, // （ ）
    0xFF3B, 0xFF3D, // ［ ］
    0xFF5B, 0xFF5D, // ｛ ｝
    0x2014,         // — (Em dash)
  };

  /// Characters prohibited at the start of a line
  static const Set<String> kinsokuHeadProhibited = {
    '，', '。', '、', '？', '！', '；', '：',
    '」', '』', '》', '〉', '）', '］', '｝', '】',
    '〔', '（', ' ',
  };
}
