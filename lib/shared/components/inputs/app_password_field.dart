import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/inputs/app_text_field.dart';

/// Password input with a show/hide toggle.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required this.label,
    this.controller,
    this.validator,
    this.errorText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofillHints = const [AutofillHints.password],
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  var _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      errorText: widget.errorText,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: widget.autofillHints,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Icons.lock_outline,
      obscureText: _obscured,
      suffix: IconButton(
        tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: AppIconSize.md,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      ),
    );
  }
}
