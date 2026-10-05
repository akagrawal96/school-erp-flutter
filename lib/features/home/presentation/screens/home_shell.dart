import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/layouts/adaptive_scaffold.dart';

/// Signed-in app shell with adaptive navigation.
///
/// Destinations are fixed for the student app; in step 5 they are built from
/// the institution's enabled modules and the user's permissions.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveScaffold(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        // Tapping the active tab returns to its first page.
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: [
        AdaptiveDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: l10n.navHome,
        ),
        AdaptiveDestination(
          icon: Icons.fact_check_outlined,
          selectedIcon: Icons.fact_check,
          label: l10n.navAttendance,
        ),
        AdaptiveDestination(
          icon: Icons.menu_book_outlined,
          selectedIcon: Icons.menu_book,
          label: l10n.navAcademics,
        ),
        AdaptiveDestination(
          icon: Icons.account_balance_wallet_outlined,
          selectedIcon: Icons.account_balance_wallet,
          label: l10n.navFees,
        ),
        AdaptiveDestination(
          icon: Icons.grid_view_outlined,
          selectedIcon: Icons.grid_view_rounded,
          label: l10n.navMore,
        ),
      ],
      body: navigationShell,
    );
  }
}
