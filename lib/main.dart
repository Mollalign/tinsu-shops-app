import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/locale_provider.dart';
import 'core/storage/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final preferences = Preferences(prefs);

  runApp(
    ProviderScope(
      overrides: [
        preferencesProvider.overrideWithValue(preferences),
      ],
      child: _AppInit(preferences: preferences),
    ),
  );
}

class _AppInit extends ConsumerStatefulWidget {
  final Preferences preferences;
  const _AppInit({required this.preferences});

  @override
  ConsumerState<_AppInit> createState() => _AppInitState();
}

class _AppInitState extends ConsumerState<_AppInit> {
  @override
  void initState() {
    super.initState();
    // Initialize locale from saved preference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(localeNotifierProvider.notifier).init(
            widget.preferences.language,
          );
    });
  }

  @override
  Widget build(BuildContext context) => const TinsuShopsApp();
}
