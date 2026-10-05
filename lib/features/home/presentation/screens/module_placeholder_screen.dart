import 'package:flutter/material.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Temporary screen for modules whose UI is not designed yet.
class ModulePlaceholderScreen extends StatelessWidget {
  const ModulePlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyStateView(
        icon: Icons.design_services_outlined,
        title: l10n.comingSoonTitle,
        message: l10n.comingSoonMessage,
      ),
    );
  }
}
