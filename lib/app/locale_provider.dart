import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/storage/preferences.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale('am');

  void setLocale(Locale locale) {
    state = locale;
    // Persist the choice
    final prefs = ref.read(preferencesProvider);
    prefs.setLanguage(locale.languageCode);
  }

  void init(String code) {
    state = Locale(code);
  }
}
