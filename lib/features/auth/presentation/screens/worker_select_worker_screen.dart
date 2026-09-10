import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../workers/domain/worker_model.dart';

part 'worker_select_worker_screen.g.dart';

/// Fetches active workers via the public (no-auth) endpoint.
@riverpod
Future<List<WorkerModel>> publicShopWorkers(Ref ref, String shopId) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );
  try {
    final res = await dio.get(ApiConstants.publicWorkers(shopId));
    final data = res.data as List;
    return data
        .map((e) => WorkerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    if (status != null && status >= 500) throw ServerError(status);
    throw const NetworkError();
  }
}

class WorkerSelectWorkerScreen extends ConsumerWidget {
  final String shopId;
  final String shopName;
  const WorkerSelectWorkerScreen({
    super.key,
    required this.shopId,
    required this.shopName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final workersAsync = ref.watch(publicShopWorkersProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/worker/select'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.whoAreYou,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.selectYourShop,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: workersAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorState(
                  message: e is AppError
                      ? e.toUserMessage(l)
                      : l.couldNotLoadWorkers,
                  onRetry: () =>
                      ref.invalidate(publicShopWorkersProvider(shopId)),
                ),
                data: (workers) {
                  final active =
                      workers.where((w) => w.isActive).toList();
                  if (active.isEmpty) {
                    return EmptyState(
                      icon: Icons.person_off_outlined,
                      title: l.noWorkers,
                      description: l.noWorkersDesc,
                    );
                  }
                  return GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: active.length,
                    itemBuilder: (context, i) {
                      return _WorkerCard(
                        worker: active[i],
                        shopId: shopId,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final WorkerModel worker;
  final String shopId;
  const _WorkerCard({required this.worker, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final initials = worker.name
        .trim()
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: () {
          context.go(
              '/worker/pin?shopId=$shopId&workerId=${worker.id}&workerName=${Uri.encodeComponent(worker.name)}');
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primaryContainer,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                worker.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
