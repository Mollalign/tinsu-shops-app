import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/workers_repository.dart';
import '../../domain/worker_model.dart';

part 'workers_screen.g.dart';

@riverpod
Future<List<WorkerModel>> shopWorkersList(Ref ref, String shopId) =>
    ref.watch(workersRepositoryProvider).listWorkers(shopId);

class WorkersScreen extends ConsumerWidget {
  const WorkersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId,
      orElse: () => null,
    );

    if (shopId == null || shopId.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: Text(l.workers)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.store_outlined,
                  size: 48, color: AppTheme.outline),
              const SizedBox(height: 16),
              Text(
                l.noShopSelected,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/owner/shops'),
                child: Text(l.selectAShop),
              ),
            ],
          ),
        ),
      );
    }

    final workersAsync = ref.watch(shopWorkersListProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.workers)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/workers/add'),
        icon: const Icon(Icons.person_add_outlined),
        label: Text(l.addWorker),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        top: false,
        child: workersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadWorkers,
            onRetry: () => ref.invalidate(shopWorkersListProvider(shopId)),
          ),
          data: (workers) {
            if (workers.isEmpty) {
              return EmptyState(
                icon: Icons.people_outline,
                title: l.noWorkers,
                description: l.noWorkersDesc,
              );
            }
            final bottomPad = MediaQuery.viewPaddingOf(context).bottom + 88;
            return RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: () async =>
                  ref.invalidate(shopWorkersListProvider(shopId)),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
                itemCount: workers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _WorkerTile(
                  worker: workers[i],
                  onTap: () =>
                      context.push('/owner/workers/${workers[i].id}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkerTile extends StatelessWidget {
  final WorkerModel worker;
  final VoidCallback onTap;
  const _WorkerTile({required this.worker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final initials = worker.name
        .trim()
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return Material(
      color: worker.isActive ? AppTheme.surface : AppTheme.surfaceVariant,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: worker.isActive
                    ? AppTheme.primaryContainer
                    : AppTheme.divider,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: worker.isActive ? AppTheme.primary : AppTheme.outline,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: worker.isActive ? null : AppTheme.outline,
                          ),
                    ),
                    Text(
                      worker.isActive ? l.workerRole : l.disabledStatus,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: worker.isActive
                                ? AppTheme.outline
                                : AppTheme.error,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
