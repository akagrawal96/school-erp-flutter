import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/config/app_flavor.dart';

void main() {
  group('AppFlavor.parse', () {
    test('parses every variant/environment combination', () {
      for (final variant in AppVariant.values) {
        for (final environment in AppEnvironment.values) {
          final flavor = AppFlavor(variant: variant, environment: environment);
          expect(AppFlavor.parse(flavor.name), flavor);
        }
      }
    });

    test('builds native flavor names', () {
      const flavor = AppFlavor(variant: AppVariant.erp, environment: AppEnvironment.staging);
      expect(flavor.name, 'erpStaging');
    });

    test('fails fast when flavor is missing', () {
      expect(() => AppFlavor.parse(null), throwsFormatException);
      expect(() => AppFlavor.parse(''), throwsFormatException);
    });

    test('fails fast on unknown flavor', () {
      expect(() => AppFlavor.parse('erpQa'), throwsFormatException);
      expect(() => AppFlavor.parse('otherStaging'), throwsFormatException);
      expect(() => AppFlavor.parse('erpDev'), throwsFormatException);
      expect(() => AppFlavor.parse('erp'), throwsFormatException);
    });
  });

  test('only prod is production', () {
    expect(AppEnvironment.prod.isProduction, isTrue);
    expect(AppEnvironment.staging.isProduction, isFalse);
  });
}
