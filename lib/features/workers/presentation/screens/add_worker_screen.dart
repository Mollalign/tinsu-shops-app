import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/workers_repository.dart';
import '../../domain/worker_model.dart';
import 'workers_screen.dart';

enum _PinMode { auto, manual }

class AddWorkerScreen extends ConsumerStatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  ConsumerState<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends ConsumerState<AddWorkerScreen> {
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _confirmPinCtrl = TextEditingController();

  _PinMode _pinMode = _PinMode.auto;
  bool _loading = false;
  String? _error;
  WorkerCreatedModel? _created;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _confirmPinCtrl.dispose();
    super.dispose();
  }

  String? _validationError(AppLocalizations l) {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return l.workerNameRequired;
    if (_pinMode == _PinMode.manual) {
      final pin = _pinCtrl.text.trim();
      final confirm = _confirmPinCtrl.text.trim();
      if (pin.length < 4) return l.pinMustBe4Digits;
      if (!RegExp(r'^\d+$').hasMatch(pin)) return l.pinMustBeDigitsOnly;
      if (pin != confirm) return l.pinsMustMatch;
    }
    return null;
  }

  Future<void> _add() async {
    final l = AppLocalizations.of(context)!;
    final validationErr = _validationError(l);
    if (validationErr != null) {
      setState(() => _error = validationErr);
      return;
    }
    setState(() { _loading = true; _error = null; });

    final session = ref.read(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    try {
      final created = await ref.read(workersRepositoryProvider).createWorker(
            shopId: shopId,
            name: _nameCtrl.text.trim(),
            pin: _pinMode == _PinMode.manual ? _pinCtrl.text.trim() : null,
          );
      ref.invalidate(shopWorkersListProvider(shopId));
      setState(() => _created = created);
    } on AppError catch (e) {
      if (mounted) setState(() => _error = e.toUserMessage(AppLocalizations.of(context)!));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (_created != null) {
      return _PinRevealScreen(created: _created!);
    }

    final canSubmit = _nameCtrl.text.trim().isNotEmpty &&
        (_pinMode == _PinMode.auto ||
            (_pinCtrl.text.trim().length >= 4 &&
                _pinCtrl.text.trim() == _confirmPinCtrl.text.trim()));

    return Scaffold(
      appBar: AppBar(title: Text(l.addNewWorker)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.addNewWorker,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // ── Name ──
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l.workerName,
                hintText: l.workerNameHint,
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 24),

            // ── PIN mode ──
            Text(l.pin, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _PinModeOption(
              label: l.generateAutomatically,
              value: _PinMode.auto,
              groupValue: _pinMode,
              onChanged: (v) => setState(() {
                _pinMode = v;
                _error = null;
              }),
            ),
            _PinModeOption(
              label: l.enterManually,
              value: _PinMode.manual,
              groupValue: _pinMode,
              onChanged: (v) => setState(() {
                _pinMode = v;
                _error = null;
              }),
            ),

            // ── Manual PIN fields ──
            if (_pinMode == _PinMode.manual) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _pinCtrl,
                decoration: InputDecoration(
                  labelText: l.pin,
                  hintText: l.pinDigitsHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() => _error = null),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPinCtrl,
                decoration: InputDecoration(
                  labelText: l.confirmPin,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() => _error = null),
              ),
            ],

            const SizedBox(height: 24),

            // ── Error ──
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(_error!, style: const TextStyle(color: AppTheme.error)),
              ),
              const SizedBox(height: 16),
            ],

            PrimaryButton(
              label: l.createWorker,
              onPressed: canSubmit ? _add : null,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

class _PinModeOption extends StatelessWidget {
  final String label;
  final _PinMode value;
  final _PinMode groupValue;
  final ValueChanged<_PinMode> onChanged;

  const _PinModeOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppTheme.primary : AppTheme.outline,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinRevealScreen extends StatelessWidget {
  final WorkerCreatedModel created;
  const _PinRevealScreen({required this.created});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_add, size: 40, color: AppTheme.primary),
              ),
              const SizedBox(height: 20),
              Text(l.workerCreated,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                created.worker.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 32),
              Text(l.pin, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Text(
                  created.pin,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 12,
                        color: AppTheme.onBackground,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l.pinOnlyShownOnce,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.outline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: created.pin));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.shareWithWorker)),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: Text(l.copyPin),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(l.done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
