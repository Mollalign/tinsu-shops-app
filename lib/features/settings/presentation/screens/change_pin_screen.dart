import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/data/auth_repository.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final _currentPinCtrl = TextEditingController();
  final _newPinCtrl = TextEditingController();
  final _confirmPinCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _currentPinCtrl.dispose();
    _newPinCtrl.dispose();
    _confirmPinCtrl.dispose();
    super.dispose();
  }

  String? _validate(AppLocalizations l) {
    if (_currentPinCtrl.text.trim().isEmpty) return l.currentPinRequired;
    if (_newPinCtrl.text.trim().length < 4) return l.newPinMustBe4Digits;
    if (!RegExp(r'^\d+$').hasMatch(_newPinCtrl.text.trim())) {
      return l.pinMustBeDigitsOnly;
    }
    if (_newPinCtrl.text.trim() != _confirmPinCtrl.text.trim()) {
      return l.newPinsMustMatch;
    }
    return null;
  }

  bool get _canSubmit =>
      _currentPinCtrl.text.trim().isNotEmpty &&
      _newPinCtrl.text.trim().length >= 4 &&
      _newPinCtrl.text.trim() == _confirmPinCtrl.text.trim();

  Future<void> _changePin() async {
    final l = AppLocalizations.of(context)!;
    final validationErr = _validate(l);
    if (validationErr != null) {
      setState(() => _error = validationErr);
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authRepositoryProvider).changeOwnerPin(
            currentPin: _currentPinCtrl.text.trim(),
            newPin: _newPinCtrl.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pinChangedSuccess)),
      );
      Navigator.of(context).pop();
    } on AppError catch (e) {
      if (mounted) setState(() => _error = e.toUserMessage(AppLocalizations.of(context)!));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.changePin)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.updateLoginPin,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              l.enterCurrentPinHint,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.outline),
            ),
            const SizedBox(height: 28),

            _PinField(
              controller: _currentPinCtrl,
              label: l.currentPin,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 16),

            _PinField(
              controller: _newPinCtrl,
              label: l.newPin,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 16),

            _PinField(
              controller: _confirmPinCtrl,
              label: l.confirmNewPin,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 24),

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppTheme.error),
                ),
              ),
              const SizedBox(height: 16),
            ],

            PrimaryButton(
              label: l.changePin,
              icon: Icons.lock_reset,
              onPressed: _canSubmit ? _changePin : null,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

class _PinField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;

  const _PinField({
    required this.controller,
    required this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
      ),
      onChanged: onChanged,
    );
  }
}
