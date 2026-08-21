import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/components.dart';
import '../../data/auth_repository.dart';
import '../session_provider.dart';

class WorkerPinScreen extends ConsumerStatefulWidget {
  final String shopId;
  final String workerId;
  final String workerName;

  const WorkerPinScreen({
    super.key,
    required this.shopId,
    required this.workerId,
    required this.workerName,
  });

  @override
  ConsumerState<WorkerPinScreen> createState() => _WorkerPinScreenState();
}

class _WorkerPinScreenState extends ConsumerState<WorkerPinScreen> {
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
    if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final auth = await ref.read(authRepositoryProvider).workerLogin(
            shopId: widget.shopId,
            workerId: widget.workerId,
            pin: _pin,
          );
      await ref.read(sessionProvider.notifier).login(auth);
      if (mounted) context.go('/worker/sell');
    } on AppError catch (e) {
      setState(() {
        _error = e.toUserMessage();
        _pin = '';
      });
    } catch (e) {
      setState(() {
        _error = 'Incorrect PIN. Try again.';
        _pin = '';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.workerName
        .trim()
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go(
                        '/worker/select-worker?shopId=${widget.shopId}&shopName='),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppTheme.primaryContainer,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.workerName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Enter your PIN',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            PinDots(
              filledCount: _pin.length,
              totalCount: AppConstants.pinLength,
            ),
            const SizedBox(height: 8),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            const Spacer(),
            if (_loading)
              const CircularProgressIndicator()
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: NumericKeypad(onKey: _onKey, onDelete: _onDelete),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
