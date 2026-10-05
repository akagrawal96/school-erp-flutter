import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/states/skeleton.dart';

/// Placeholder matching the dashboard layout while it loads.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  static const double _avatarSize = AppSpacing.xxxl + AppSpacing.xs;
  static const double _cardHeight = AppSpacing.xxxl * 2;

  @override
  Widget build(BuildContext context) {
    // A non-scrolling list clips on short screens instead of overflowing.
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SkeletonBox(width: _avatarSize, height: _avatarSize, radius: AppRadius.pillAll),
                  AppGap.md,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: double.infinity, height: AppSpacing.lg),
                        AppGap.sm,
                        SkeletonBox(width: AppSpacing.xxxl * 3),
                      ],
                    ),
                  ),
                ],
              ),
              AppGap.lg,
              SkeletonBox(width: double.infinity, height: _cardHeight, radius: AppRadius.lgAll),
              AppGap.lg,
              SkeletonBox(width: double.infinity, height: _cardHeight, radius: AppRadius.lgAll),
              AppGap.sm,
              Row(
                children: [
                  Expanded(
                    child: SkeletonBox(height: _cardHeight, radius: AppRadius.lgAll),
                  ),
                  AppGap.sm,
                  Expanded(
                    child: SkeletonBox(height: _cardHeight, radius: AppRadius.lgAll),
                  ),
                ],
              ),
              AppGap.lg,
              AppCard(child: SizedBox(height: _cardHeight)),
            ],
          ),
        ],
      ),
    );
  }
}
