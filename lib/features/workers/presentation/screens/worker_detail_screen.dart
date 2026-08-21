import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/states.dart';
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
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final workerAsync = ref.watch(workerDetailProvider(shopId, workerId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Worker')),
      body: workerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage() : 'Could not load worker.',
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
  bool _loading = false;
  String? _newPin;

  Future<void> _resetPin() async {
    setState(() => _loading = true);
    try {
      final pin = await ref
          .read(workersRepositoryProvider)
          .resetPin(widget.shopId, widget.worker.id);
      if (!mounted) return;
      setState(() => _newPin = pin);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN has been reset')));
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toUserMessage())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleWorker() async {
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
              widget.worker.isActive ? 'Worker disabled' : 'Worker enabled',
            ),
          ),
        );
        context.pop();
      }
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toUserMessage())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          // Avatar
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
          const SizedBox(height: 12),
          Text(worker.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            worker.isActive ? 'Worker' : 'Disabled',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: worker.isActive ? AppTheme.outline : AppTheme.error,
                ),
          ),
          const SizedBox(height: 32),

          // New PIN display
          if (_newPin != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Column(
                children: [
                  const Text('New PIN', style: TextStyle(color: AppTheme.outline)),
                  const SizedBox(height: 8),
                  Text(
                    _newPin!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          PrimaryButton(
            label: 'Reset PIN',
            icon: Icons.lock_reset,
            onPressed: _loading ? null : _resetPin,
            loading: _loading && _newPin == null,
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: worker.isActive ? 'Disable Worker' : 'Enable Worker',
            icon: worker.isActive ? Icons.person_off_outlined : Icons.person_outlined,
            onPressed: _loading ? null : _toggleWorker,
          ),
        ],
      ),
    );
  }
}
