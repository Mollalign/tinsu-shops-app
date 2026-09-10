import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/workers_repository.dart';
import '../../domain/worker_model.dart';
import 'workers_screen.dart';

part 'worker_detail_screen.g.dart';

@riverpod
Future<WorkerModel> workerDetail(Ref ref, String shopId, String workerId) =>
    ref.watch(workersRepositoryProvider).getWorker(shopId, workerId);

class WorkerDetailScreen extends ConsumerWidget {
  final String workerId;
  const WorkerDetailScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final workerAsync = ref.watch(workerDetailProvider(shopId, workerId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.workerRole)),
      body: workerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadWorker,
          onRetry: () => ref.invalidate(workerDetailProvider(shopId, workerId)),
        ),
        data: (worker) => _WorkerDetailBody(
          worker: worker,
          shopId: shopId,
        ),
      ),
    );
  }
}

class _WorkerDetailBody extends ConsumerStatefulWidget {
  final WorkerModel worker;
  final String shopId;
  const _WorkerDetailBody({required this.worker, required this.shopId});

  @override
  ConsumerState<_WorkerDetailBody> createState() => _WorkerDetailBodyState();
}

class _WorkerDetailBodyState extends ConsumerState<_WorkerDetailBody> {
  late final TextEditingController _nameCtrl;
  bool _loading = false;
  String? _newPin;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.worker.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _nameChanged =>
      _nameCtrl.text.trim().isNotEmpty &&
      _nameCtrl.text.trim() != widget.worker.name;

  Future<void> _saveChanges() async {
    final l = AppLocalizations.of(context)!;
    final newName = _nameCtrl.text.trim();
    if (newName.isEmpty) {
      setState(() => _nameError = l.workerNameRequired);
      return;
    }
    setState(() { _loading = true; _nameError = null; });
    try {
      await ref.read(workersRepositoryProvider).updateWorker(
            widget.shopId,
            widget.worker.id,
            name: newName,
          );
      ref.invalidate(shopWorkersListProvider(widget.shopId));
      ref.invalidate(workerDetailProvider(widget.shopId, widget.worker.id));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.workerUpdated)));
      context.pop();
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toUserMessage(AppLocalizations.of(context)!))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openChangePinModal() async {
    final l = AppLocalizations.of(context)!;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      builder: (ctx) => _ChangeWorkerPinSheet(
        onUpdate: ({String? manualPin}) async {
          setState(() => _loading = true);
          try {
            final pin = await ref
                .read(workersRepositoryProvider)
                .resetPin(widget.shopId, widget.worker.id, newPin: manualPin);
            if (!mounted) return;
            if (manualPin == null) {
              setState(() => _newPin = pin);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(l.pinReset)));
            } else {
              setState(() => _newPin = null);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(l.pinChangedSuccess)));
            }
          } on AppError catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toUserMessage(l))),
            );
          } finally {
            if (mounted) setState(() => _loading = false);
          }
        },
      ),
    );
  }

  Future<void> _toggleWorker() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    try {
      await ref.read(workersRepositoryProvider).toggleWorker(
            widget.shopId,
            widget.worker.id,
            !widget.worker.isActive,
          );
      ref.invalidate(shopWorkersListProvider(widget.shopId));
      ref.invalidate(workerDetailProvider(widget.shopId, widget.worker.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.worker.isActive ? l.workerDisabled : l.workerEnabled,
            ),
          ),
        );
        context.pop();
      }
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toUserMessage(AppLocalizations.of(context)!))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final worker = widget.worker;
    final initials = worker.name
        .trim()
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + status ──
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryContainer,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  worker.isActive ? l.activeStatus : l.disabledStatus,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: worker.isActive ? AppTheme.outline : AppTheme.error,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Name field ──
          Text(l.workerName, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: l.workerNameHint,
              errorText: _nameError,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() => _nameError = null),
          ),
          const SizedBox(height: 20),

          // ── Save Changes ──
          PrimaryButton(
            label: l.saveChanges,
            icon: Icons.check,
            onPressed: (_loading || !_nameChanged) ? null : _saveChanges,
            loading: _loading && _newPin == null,
          ),
          const SizedBox(height: 24),

          const Divider(),
          const SizedBox(height: 16),

          // ── New PIN display ──
          if (_newPin != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Column(
                children: [
                  Text(l.newPin, style: const TextStyle(color: AppTheme.outline)),
                  const SizedBox(height: 8),
                  Text(
                    _newPin!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.shareWithWorker,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.outline),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: Text(l.copyPin),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _newPin!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.pinCopied)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          SecondaryButton(
            label: l.changePin,
            icon: Icons.lock_reset,
            onPressed: _loading ? null : _openChangePinModal,
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: worker.isActive ? l.disableWorker : l.enableWorker,
            icon: worker.isActive ? Icons.person_off_outlined : Icons.person_outlined,
            onPressed: _loading ? null : _toggleWorker,
          ),
        ],
      ),
    );
  }
}

enum _ChangePinMode { manual, auto }

class _ChangeWorkerPinSheet extends StatefulWidget {
  final Future<void> Function({String? manualPin}) onUpdate;

  const _ChangeWorkerPinSheet({required this.onUpdate});

  @override
  State<_ChangeWorkerPinSheet> createState() => _ChangeWorkerPinSheetState();
}

class _ChangeWorkerPinSheetState extends State<_ChangeWorkerPinSheet> {
  _ChangePinMode _mode = _ChangePinMode.manual;
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l) async {
    if (_mode == _ChangePinMode.manual) {
      final pin = _pinCtrl.text.trim();
      final confirm = _confirmCtrl.text.trim();
      if (pin.length < 4) {
        setState(() => _error = l.pinMustBe4Digits);
        return;
      }
      if (!RegExp(r'^\d+$').hasMatch(pin)) {
        setState(() => _error = l.pinMustBeDigitsOnly);
        return;
      }
      if (pin != confirm) {
        setState(() => _error = l.pinsMustMatch);
        return;
      }
      setState(() {
        _loading = true;
        _error = null;
      });
      try {
        await widget.onUpdate(manualPin: pin);
        if (mounted) Navigator.pop(context);
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    } else {
      setState(() {
        _loading = true;
        _error = null;
      });
      try {
        await widget.onUpdate(manualPin: null);
        if (mounted) Navigator.pop(context);
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.changePin, style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Mode selection ──
            InkWell(
              onTap: () => setState(() { _mode = _ChangePinMode.manual; _error = null; }),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      _mode == _ChangePinMode.manual
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: _mode == _ChangePinMode.manual
                          ? AppTheme.primary
                          : AppTheme.outline,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l.enterManually,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: _mode == _ChangePinMode.manual
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => setState(() { _mode = _ChangePinMode.auto; _error = null; }),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      _mode == _ChangePinMode.auto
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: _mode == _ChangePinMode.auto
                          ? AppTheme.primary
                          : AppTheme.outline,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l.generateAutomatically,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: _mode == _ChangePinMode.auto
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Manual PIN fields ──
            if (_mode == _ChangePinMode.manual) ...[
              TextField(
                controller: _pinCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l.newPin,
                  hintText: l.pinDigitsHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                onChanged: (_) => setState(() => _error = null),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l.confirmNewPin,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                onChanged: (_) => setState(() => _error = null),
              ),
              const SizedBox(height: 16),
            ],

            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, size: 16, color: AppTheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppTheme.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            PrimaryButton(
              label: l.updatePin,
              loading: _loading,
              onPressed: _loading ? null : () => _submit(l),
            ),
          ],
        ),
      ),
    );
  }
}
