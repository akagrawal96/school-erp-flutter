import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_spacing.dart';

/// Bordered surface grouping related content. Tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Card(
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
