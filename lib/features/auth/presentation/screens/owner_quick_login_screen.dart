import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/components.dart';
import '../../data/auth_repository.dart';
import '../session_provider.dart';

/// Shown when the session has expired but we have a remembered owner phone.
/// The owner only needs to re-enter their 4-digit PIN — no phone field.
class OwnerQuickLoginScreen extends ConsumerStatefulWidget {
  final String ownerPhone;
  final String ownerName;

  const OwnerQuickLoginScreen({
    super.key,
    required this.ownerPhone,
    required this.ownerName,
  });

  @override
  ConsumerState<OwnerQuickLoginScreen> createState() =>
      _OwnerQuickLoginScreenState();
}

class _OwnerQuickLoginScreenState
    extends ConsumerState<OwnerQuickLoginScreen> {
  String _pin = '';
  bool _loading = false;
  String? _error;

  void _onKey(String key) {
    if (_pin.length < AppConstants.pinLength) {
      setState(() {
        _pin += key;
        _error = null;
      });
      if (_pin.length == AppConstants.pinLength) {
        _login();
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final auth = await ref.read(authRepositoryProvider).ownerLogin(
            phone: widget.ownerPhone,
            pin: _pin,
          );
      // Pass the phone again so it stays persisted.
      await ref.read(sessionProvider.notifier).login(
            auth,
            ownerPhone: widget.ownerPhone,
          );
      if (mounted) context.go('/owner/shops');
    } on AppError catch (e) {
      setState(() {
        _error = e.toUserMessage();
        _pin = '';
      });
    } catch (_) {
      setState(() {
        _error = 'Incorrect PIN. Please try again.';
        _pin = '';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _switchAccount() async {
    await ref.read(sessionProvider.notifier).switchAccount();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.ownerName.split(' ').first;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.storefront,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.outline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    firstName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onBackground,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your PIN to continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ── PIN dots ────────────────────────────────────────────
            PinDots(
              filledCount: _pin.length,
              totalCount: AppConstants.pinLength,
            ),
            const SizedBox(height: 12),

            // ── Error message ────────────────────────────────────────
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
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
                          _error!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.error,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // ── Keypad ──────────────────────────────────────────────
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: CircularProgressIndicator(),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: NumericKeypad(onKey: _onKey, onDelete: _onDelete),
              ),

            const SizedBox(height: 24),

            // ── "Use another account" ────────────────────────────────
            TextButton(
              onPressed: _switchAccount,
              child: Text(
                'Use another account',
                style: TextStyle(
                  color: AppTheme.outline,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
