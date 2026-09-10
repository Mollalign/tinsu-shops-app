import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'locale_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class TinsuShopsApp extends ConsumerWidget {
  const TinsuShopsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'Tinsu-Shops',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: const [
        Locale('am'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
