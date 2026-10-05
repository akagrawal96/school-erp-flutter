import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/component_gallery/presentation/widgets/gallery_sections.dart';

/// Developer-facing gallery of shared components and screen states.
/// Not an ERP feature; used for design review on staging builds.
class ComponentGalleryScreen extends StatelessWidget {
  const ComponentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navComponents)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
            children: const [
              ButtonsGallerySection(),
              AppGap.lg,
              InputsGallerySection(),
              AppGap.lg,
              ContentGallerySection(),
              AppGap.lg,
              StatesGallerySection(),
              AppGap.lg,
              DialogsGallerySection(),
            ],
          ),
        ),
      ),
    );
  }
}
