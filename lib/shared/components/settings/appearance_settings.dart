import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_mode_controller.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Theme mode and language switches, shared by settings and the design preview.
class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final languageCode = ref.watch(localeProvider)?.languageCode;

    return AppSection(
      title: l10n.appearanceSectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionLabel(l10n.themeModeLabel),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeModeSystem)),
              ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeModeLight)),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeModeDark)),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) =>
                unawaited(ref.read(themeModeProvider.notifier).setThemeMode(selection.single)),
          ),
          AppGap.lg,
          AppSectionLabel(l10n.languageLabel),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: _system, label: Text(l10n.languageSystem)),
              ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
              ButtonSegment(value: 'hi', label: Text(l10n.languageHindi)),
            ],
            selected: {languageCode ?? _system},
            onSelectionChanged: (selection) {
              final code = selection.single;
              unawaited(
                ref.read(localeProvider.notifier).setLocale(code == _system ? null : Locale(code)),
              );
            },
          ),
        ],
      ),
    );
  }

  static const _system = 'system';
}
