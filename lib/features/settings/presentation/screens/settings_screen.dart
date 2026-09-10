import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../auth/domain/user_model.dart';
import '../../../../app/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final currentLocale = ref.watch(localeNotifierProvider);

    final user = session.maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );
    final isOwner = user?.role == UserRole.owner;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.more)),
      body: ListView(
        children: [
          // Profile header
          Container(
            color: AppTheme.surface,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primaryContainer,
                  child: Text(
                    (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? '',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      isOwner ? l.ownerLabel : l.workerRole,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (isOwner) ...[
            _SectionHeader(l.management),
            _SettingsTile(
              icon: Icons.warehouse_outlined,
              title: l.stock,
              subtitle: l.stockSubtitle,
              onTap: () => context.go('/owner/stock'),
            ),
            _SettingsTile(
              icon: Icons.people_outline,
              title: l.workers,
              subtitle: l.workersSubtitle,
              onTap: () => context.go('/owner/workers'),
            ),
            _SettingsTile(
              icon: Icons.store_outlined,
              title: l.shopsLabel,
              subtitle: l.shopsSubtitle,
              onTap: () => context.go('/owner/shops'),
            ),
            const SizedBox(height: 16),
            _SectionHeader(l.account),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: l.changePin,
              subtitle: l.changePinSubtitle,
              onTap: () => context.push('/owner/change-pin'),
            ),
          ],

          const SizedBox(height: 16),
          _SectionHeader(l.preferences),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: l.language,
            subtitle: currentLocale.languageCode == 'am' ? l.amharic : l.english,
            onTap: () => _showLanguagePicker(context, ref, currentLocale.languageCode),
          ),

          const SizedBox(height: 16),
          _SectionHeader(l.support),
          _SettingsTile(
            icon: Icons.help_outline,
            title: l.help,
            onTap: () {},
          ),
          const SizedBox(height: 16),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error),
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => _logout(context, ref),
              icon: const Icon(Icons.logout),
              label: Text(l.logout),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, String current) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.chooseLanguage,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _LangOption(
              label: l.amharic,
              subtitle: 'አማርኛ',
              code: 'am',
              selected: current == 'am',
              onTap: () {
                ref
                    .read(localeNotifierProvider.notifier)
                    .setLocale(const Locale('am'));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _LangOption(
              label: l.english,
              subtitle: 'English',
              code: 'en',
              selected: current == 'en',
              onTap: () {
                ref
                    .read(localeNotifierProvider.notifier)
                    .setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.logout),
        content: Text(l.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l.logout,
                style: const TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sessionProvider.notifier).logout();
      });
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.outline,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: Theme.of(context).textTheme.bodySmall),
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

class _LangOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final String code;
  final bool selected;
  final VoidCallback onTap;
  const _LangOption({
    required this.label,
    required this.subtitle,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.primaryContainer : AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle,
                    color: AppTheme.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
