import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Shown for unknown routes, e.g. an outdated deep link.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: StateView(
        icon: Icons.explore_off_outlined,
        title: l10n.notFoundTitle,
        message: l10n.notFoundMessage,
        actionLabel: l10n.actionGoHome,
        onAction: () => context.go(AppRoutes.home),
      ),
    );
  }
}
