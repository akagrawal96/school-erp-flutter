import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_elevation.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:school_erp/features/authentication/presentation/controllers/login_controller.dart';
import 'package:school_erp/features/authentication/presentation/providers/auth_providers.dart';
import 'package:school_erp/features/authentication/presentation/widgets/login_header.dart';
import 'package:school_erp/features/authentication/presentation/widgets/login_message_banner.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/inputs/app_password_field.dart';
import 'package:school_erp/shared/components/inputs/app_text_field.dart';

/// Sign-in screen. After a successful sign-in the router opens the home screen.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompact = context.windowSize.isCompact;
    const language = _LanguageToggle();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status-bar icons over the brand panel.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: isCompact
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginHero(trailing: language),
                    Transform.translate(
                      // Lift the form card over the bottom of the brand panel.
                      offset: const Offset(0, -AppSpacing.xxl),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutterCompact),
                        child: _FormCard(),
                      ),
                    ),
                  ],
                ),
              )
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: LoginHero(trailing: language, expand: true)),
                  Expanded(
                    child: SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(AppSpacing.xxl),
                          child: _FormCard(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FormCard extends ConsumerStatefulWidget {
  const _FormCard();

  @override
  ConsumerState<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends ConsumerState<_FormCard> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  var _remember = false;

  static const double _maxWidth = 440;

  @override
  void initState() {
    super.initState();
    unawaited(_prefillSavedLogin());
  }

  /// Fills in the details saved with "Remember me", unless the user already typed.
  Future<void> _prefillSavedLogin() async {
    final saved = await ref.read(savedLoginProvider.future);
    if (saved == null || !mounted) return;
    if (_loginIdController.text.isNotEmpty || _passwordController.text.isNotEmpty) return;
    setState(() {
      _loginIdController.text = saved.loginId;
      _passwordController.text = saved.password;
      _remember = true;
    });
  }

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final signedIn = await ref
        .read(loginControllerProvider.notifier)
        .signIn(
          loginId: _loginIdController.text,
          password: _passwordController.text,
          remember: _remember,
        );
    if (signedIn) TextInput.finishAutofillContext();
  }

  void _showForgotPasswordHelp() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.loginForgotPasswordHelp)));
  }

  String _failureMessage(Object error) {
    final l10n = context.l10n;
    return switch (error) {
      AuthFailure(reason: AuthFailureReason.invalidCredentials) => l10n.loginInvalidCredentials,
      AuthFailure(reason: AuthFailureReason.network) => l10n.errorOfflineMessage,
      AuthFailure(reason: AuthFailureReason.unavailable) => l10n.loginUnavailable,
      _ => l10n.errorGenericMessage,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(loginControllerProvider);
    final flavor = ref.watch(appFlavorProvider);
    final error = state.error;
    final sessionExpired = ref.watch(sessionExpiredProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: AppRadius.xlAll,
          boxShadow: AppShadows.floating(Theme.of(context).brightness),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(l10n.loginWelcomeTitle, style: context.textStyles.headlineSmall),
                  ),
                  AppGap.xs,
                  Text(
                    l10n.loginSignInTitle,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  AppGap.xl,
                  if (error != null) ...[
                    LoginMessageBanner.error(message: _failureMessage(error)),
                    AppGap.lg,
                  ] else if (sessionExpired) ...[
                    LoginMessageBanner.info(message: l10n.loginSessionExpired),
                    AppGap.lg,
                  ],
                  AppTextField(
                    label: l10n.loginIdLabel,
                    hint: l10n.loginIdHintRegistration,
                    controller: _loginIdController,
                    prefixIcon: Icons.badge_outlined,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? l10n.loginIdRequired : null,
                  ),
                  AppGap.lg,
                  AppPasswordField(
                    label: l10n.passwordLabel,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => unawaited(_submit()),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? l10n.passwordRequired : null,
                  ),
                  AppGap.xs,
                  // Wraps onto two lines on narrow forms or with long translations.
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _RememberMe(
                        value: _remember,
                        onChanged: (value) => setState(() => _remember = value),
                      ),
                      AppButton(
                        label: l10n.loginForgotPassword,
                        variant: AppButtonVariant.text,
                        onPressed: _showForgotPasswordHelp,
                      ),
                    ],
                  ),
                  AppGap.xs,
                  AppButton(
                    label: l10n.loginSubmit,
                    icon: Icons.login_rounded,
                    isLoading: state.isLoading,
                    expand: true,
                    onPressed: () => unawaited(_submit()),
                  ),
                  AppGap.lg,
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent_outlined,
                        size: AppIconSize.md,
                        color: context.appColors.textTertiary,
                      ),
                      AppGap.sm,
                      Expanded(
                        child: Text(
                          l10n.loginHelp,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!flavor.environment.isProduction) ...[
                    AppGap.md,
                    Text(
                      l10n.buildFlavorLabel(flavor.name),
                      textAlign: TextAlign.center,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.appColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Remember me" checkbox with a tappable label.
class _RememberMe extends StatelessWidget {
  const _RememberMe({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        borderRadius: AppRadius.smAll,
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: value, onChanged: (checked) => onChanged(checked ?? false)),
            Flexible(
              child: Text(context.l10n.loginRememberMe, style: context.textStyles.bodyMedium),
            ),
            AppGap.sm,
          ],
        ),
      ),
    );
  }
}

/// Switches between English and Hindi before sign-in.
class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final color = context.colors.onPrimary;
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        shape: const StadiumBorder(),
        minimumSize: const Size(0, AppSpacing.xxl + AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      icon: const Icon(Icons.translate, size: AppIconSize.md),
      label: Text(isHindi ? l10n.languageEnglish : l10n.languageHindi),
      onPressed: () => unawaited(
        ref.read(localeProvider.notifier).setLocale(Locale(isHindi ? 'en' : 'hi')),
      ),
    );
  }
}
