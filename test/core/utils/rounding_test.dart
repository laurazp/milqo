import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/core/utils/rounding.dart';

void main() {
  group('Rounding.toNearestWater', () {
    test('rounds to the nearest multiple of 5', () {
      expect(Rounding.toNearestWater(1333), 1335);
      expect(Rounding.toNearestWater(998), 1000);
      expect(Rounding.toNearestWater(1002), 1000);
      expect(Rounding.toNearestWater(0), 0);
    });
  });

  group('Rounding.toNearestGram', () {
    test('rounds to the nearest whole gram', () {
      expect(Rounding.toNearestGram(149.6), 150);
      expect(Rounding.toNearestGram(149.4), 149);
      expect(Rounding.toNearestGram(150.5), 151);
    });
  });

  group('Rounding.toSimpleFraction', () {
    test('snaps to the nearest quarter', () {
      expect(Rounding.toSimpleFraction(0.1), 0);
      expect(Rounding.toSimpleFraction(0.3), 0.25);
      expect(Rounding.toSimpleFraction(0.4), 0.5);
      expect(Rounding.toSimpleFraction(1.4), 1.5);
    });
  });

  group('Rounding.fractionLabel', () {
    test('formats whole numbers without a fraction', () {
      expect(Rounding.fractionLabel(0), '0');
      expect(Rounding.fractionLabel(2), '2');
    });

    test('formats a bare fraction below one with no leading zero', () {
      expect(Rounding.fractionLabel(0.25), '¼');
      expect(Rounding.fractionLabel(0.5), '½');
      expect(Rounding.fractionLabel(0.75), '¾');
    });

    test('formats a whole number plus a fraction', () {
      expect(Rounding.fractionLabel(1.5), '1 ½');
      expect(Rounding.fractionLabel(2.25), '2 ¼');
    });

    test('never produces an ugly decimal — always snaps to a quarter first', () {
      // 1.4 rounds to 1.5 before formatting, per toSimpleFraction.
      expect(Rounding.fractionLabel(1.4), '1 ½');
    });
  });
}
