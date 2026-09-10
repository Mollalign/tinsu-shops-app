import 'package:flutter/material.dart';
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

  Future<void> _resetPin() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    try {
      final pin = await ref
          .read(workersRepositoryProvider)
          .resetPin(widget.shopId, widget.worker.id);
      if (!mounted) return;
      setState(() => _newPin = pin);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.pinReset)));
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toUserMessage(AppLocalizations.of(context)!))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          SecondaryButton(
            label: l.resetPin,
            icon: Icons.lock_reset,
            onPressed: _loading ? null : _resetPin,
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
