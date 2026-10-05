import 'package:flutter/material.dart';
import 'package:school_erp/core/localization/locale_controller.dart';

/// Centered spinner for short, blocking loads. Prefer [SkeletonList] when the
/// shape of the content is known.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: context.l10n.loadingLabel,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
