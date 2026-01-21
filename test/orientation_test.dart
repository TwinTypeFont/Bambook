import 'package:flutter_test/flutter_test.dart';
import 'package:bambook/src/base/types.dart';
import 'package:bambook/src/engine/orientation_resolver.dart';

void main() {
  group('OrientationResolver UTR #50 Testing', () {
    
    test('chinese characters should be determined as U(Upright)', () {
      expect(OrientationResolver.resolve('東'.runes.first), BambookOrientation.U);
      expect(OrientationResolver.resolve('短'.runes.first), BambookOrientation.U);
      expect(OrientationResolver.resolve('貓'.runes.first), BambookOrientation.U);
    });

    test('latin and numbers should be determined sa R(Rotated)', () {
      expect(OrientationResolver.resolve('g'.runes.first), BambookOrientation.R);
      expect(OrientationResolver.resolve('R'.runes.first), BambookOrientation.R);
      expect(OrientationResolver.resolve('1'.runes.first), BambookOrientation.R);
      expect(OrientationResolver.resolve('&'.runes.first), BambookOrientation.R);
    });

    test('chinese punctuation marks should be determined Tu (Transformed Upright)', () {
      expect(OrientationResolver.resolve('（'.runes.first), BambookOrientation.Tu);
      expect(OrientationResolver.resolve('「'.runes.first), BambookOrientation.Tu);
      expect(OrientationResolver.resolve('【'.runes.first), BambookOrientation.Tu);
    });

    test('全型英數(fullwidth latin and numbers) ===> U(Upright)', () {
      expect(OrientationResolver.resolve('Ａ'.runes.first), BambookOrientation.U);
      expect(OrientationResolver.resolve('１'.runes.first), BambookOrientation.U);
    });

    test('Emoji ===> U(Upright)', () {
      expect(OrientationResolver.resolve('😊'.runes.first), BambookOrientation.U);
      expect(OrientationResolver.resolve('🚀'.runes.first), BambookOrientation.U);
    });
  });
}