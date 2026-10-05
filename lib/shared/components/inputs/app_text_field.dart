import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';

/// Labeled text input for forms. Styling comes from the input decoration theme.
///
/// Always pass a visible [label]; placeholders alone are not accessible.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.controller,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.minLines,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
    this.autocorrect = true,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helperText;

  /// Error shown regardless of [validator], e.g. from a server response.
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? minLines;

  /// Use `null` for unlimited lines. Obscured fields are always single-line.
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    final prefixIcon = this.prefixIcon;
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      autocorrect: autocorrect && !obscureText,
      enableSuggestions: !obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      minLines: obscureText ? null : minLines,
      maxLines: obscureText ? 1 : maxLines,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        errorMaxLines: 3,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: AppIconSize.md),
        suffixIcon: suffix,
      ),
    );
  }
}
