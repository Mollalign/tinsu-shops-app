import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

part 'preferences.g.dart';

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) =>
    SharedPreferences.getInstance();

@riverpod
Preferences preferences(Ref ref) {
  // This will be overridden in main.dart after initialization
  throw UnimplementedError('SharedPreferences not yet initialized');
}

/// Light key-value store for non-sensitive preferences (language, etc.)
class Preferences {
  final SharedPreferences _prefs;
  Preferences(this._prefs);

  String get language =>
      _prefs.getString(AppConstants.keyLanguage) ?? 'am';

  Future<void> setLanguage(String code) =>
      _prefs.setString(AppConstants.keyLanguage, code);
}
