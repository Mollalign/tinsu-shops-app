/// Centralized app-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Tinsu-Shops';
  static const String currencyCode = 'ETB';
  static const String currencySymbol = 'ETB';

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyShopId = 'shop_id';
  static const String keyOwnerPhone = 'owner_phone';
  static const String keyLanguage = 'language';

  // Debounce — 300 ms balances perceived immediacy with reduced API calls
  static const int searchDebounceMs = 300;

  // Pagination
  static const int defaultPageSize = 20;

  // Product grid
  static const int productGridColumns = 2;

  // PIN length
  static const int pinLength = 4;

  // Low stock threshold default
  static const int defaultLowStockThreshold = 5;
}
