import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/components.dart';
import '../../../../core/widgets/language_toggle.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/auth_repository.dart';
import '../session_provider.dart';

class OwnerLoginScreen extends ConsumerStatefulWidget {
  const OwnerLoginScreen({super.key});

  @override
  ConsumerState<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends ConsumerState<OwnerLoginScreen> {
  final _phoneCtrl = TextEditingController();
  String _pin = '';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onKey(String key) {
    ref.read(sessionProvider.notifier).clearSessionExpiredFlag();
    if (_pin.length < 4) {
      setState(() {
        _pin += key;
        _error = null;
      });
    }
  }

  void _onDelete() {
    ref.read(sessionProvider.notifier).clearSessionExpiredFlag();
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _error = null;
      });
    }
  }

  Future<void> _login() async {
    if (_phoneCtrl.text.trim().isEmpty || _pin.length < 4) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final auth = await ref.read(authRepositoryProvider).ownerLogin(
            phone: _phoneCtrl.text.trim(),
            pin: _pin,
          );
      await ref.read(sessionProvider.notifier).login(
            auth,
            ownerPhone: _phoneCtrl.text.trim(),
          );
      if (mounted) context.go('/owner/shops');
    } on AppError catch (e) {
      if (mounted) setState(() => _error = e.toUserMessage(AppLocalizations.of(context)!));
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.errorServer);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final canLogin = _phoneCtrl.text.trim().isNotEmpty && _pin.length == 4;
    final session = ref.watch(sessionProvider);
    final isSessionExpired = session.maybeWhen(
      unauthenticated: (_, __, isExpired, ___) => isExpired,
      orElse: () => false,
    );
    final displayError =
        _error ?? (isSessionExpired ? l.errorUnauthorized : null);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Logo and Language Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.storefront,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l.appName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const LanguageToggle(compact: true),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                l.welcomeBack,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l.signInToOwnerAccount,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Phone field
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  ref.read(sessionProvider.notifier).clearSessionExpiredFlag();
                  setState(() => _error = null);
                },
                decoration: InputDecoration(
                  labelText: l.phoneNumber,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // PIN section
              Text(
                l.enterPin,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              PinDots(filledCount: _pin.length, totalCount: 4),
              const SizedBox(height: 20),
              NumericKeypad(onKey: _onKey, onDelete: _onDelete),
              const SizedBox(height: 24),

              if (displayError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppTheme.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          displayError,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.error,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              PrimaryButton(
                label: l.signIn,
                onPressed: canLogin ? _login : null,
                loading: _loading,
              ),
              const SizedBox(height: 20),

              // Worker login link
              Center(
                child: TextButton(
                  onPressed: () => context.go('/worker/select'),
                  child: Text(
                    l.loginAsWorker,
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
