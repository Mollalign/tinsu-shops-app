import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/shops_repository.dart';
import 'shops_screen.dart';

class AddShopScreen extends ConsumerStatefulWidget {
  const AddShopScreen({super.key});

  @override
  ConsumerState<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends ConsumerState<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(shopsRepositoryProvider).createShop(
            name: _nameCtrl.text.trim(),
            location: _locationCtrl.text.trim().isEmpty
                ? null
                : _locationCtrl.text.trim(),
            phone: _phoneCtrl.text.trim().isEmpty
                ? null
                : _phoneCtrl.text.trim(),
          );
      ref.invalidate(ownerShopsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.shopCreated)),
        );
        context.pop();
      }
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
      appBar: AppBar(title: Text(l.addShop)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l.shopName),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? l.nameRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationCtrl,
                decoration: InputDecoration(labelText: l.locationOptional),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l.phoneOptional),
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(_error!,
                      style: const TextStyle(color: AppTheme.error)),
                ),
                const SizedBox(height: 16),
              ],
              PrimaryButton(
                label: l.createShop,
                onPressed: _submit,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
