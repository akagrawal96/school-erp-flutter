import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/content/app_avatar.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/components/dialogs/confirmation_dialog.dart';
import 'package:school_erp/shared/states/state_view.dart';

import '../helpers/test_app.dart';

void main() {
  group('AppButton', () {
    testWidgets('calls onPressed when enabled', (tester) async {
      var taps = 0;
      await pumpTestWidget(tester, AppButton(label: 'Save', onPressed: () => taps++));

      await tester.tap(find.text('Save'));
      expect(taps, 1);
    });

    testWidgets('loading shows a spinner and ignores taps', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        AppButton(label: 'Save', isLoading: true, onPressed: () => taps++),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Save'), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('variants map to the matching Material buttons', (tester) async {
      await pumpTestWidget(
        tester,
        Column(
          children: [
            AppButton(label: 'a', onPressed: () {}),
            AppButton(label: 'b', variant: AppButtonVariant.secondary, onPressed: () {}),
            AppButton(label: 'c', variant: AppButtonVariant.text, onPressed: () {}),
            AppButton(label: 'd', variant: AppButtonVariant.destructive, onPressed: () {}),
          ],
        ),
      );

      expect(find.byType(FilledButton), findsNWidgets(2));
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  test('AppAvatar initials', () {
    expect(AppAvatar.initialsOf('Ananya Sharma'), 'AS');
    expect(AppAvatar.initialsOf('  ravi  '), 'R');
    expect(AppAvatar.initialsOf('Ravi Kumar Verma'), 'RV');
    expect(AppAvatar.initialsOf('अनन्या शर्मा'), 'अश');
    expect(AppAvatar.initialsOf(''), '');
  });

  testWidgets('StatusChip renders every tone', (tester) async {
    await pumpTestWidget(
      tester,
      Wrap(
        children: [for (final tone in StatusTone.values) StatusChip(label: tone.name, tone: tone)],
      ),
    );
    for (final tone in StatusTone.values) {
      expect(find.text(tone.name), findsOneWidget);
    }
  });

  testWidgets('ErrorStateView shows default copy and retries', (tester) async {
    var retries = 0;
    await pumpTestWidget(tester, ErrorStateView(onRetry: () => retries++));

    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('EmptyStateView hides the action without a callback', (tester) async {
    await pumpTestWidget(tester, const EmptyStateView(title: 'Nothing', actionLabel: 'Add'));

    expect(find.text('Nothing'), findsOneWidget);
    expect(find.text('Add'), findsNothing);
  });

  testWidgets('confirmation dialog resolves true only on confirm', (tester) async {
    final results = <bool>[];
    await pumpTestWidget(
      tester,
      Builder(
        builder: (context) => AppButton(
          label: 'Open',
          onPressed: () async => results.add(
            await showConfirmationDialog(context, title: 'Delete?', message: 'Sure?'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(results, [false, true]);
  });
}
