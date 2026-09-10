/// API endpoint constants — single source of truth
class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    return 'http://127.0.0.1:8000';
    // return 'https://tinsu-shops-api.vercel.app';
  }
  static const String apiV1 = '/api/v1';

  // Auth
  static const String ownerLogin = '$apiV1/auth/owner/login';
  static const String workerLogin = '$apiV1/auth/worker/login';

  // Owner
  static const String ownerDashboard = '$apiV1/owner/dashboard';

  // Shops
  static const String shops = '$apiV1/shops';
  static String shop(String id) => '$apiV1/shops/$id';

  // Public (no auth required)
  static const String publicShops = '$apiV1/public/shops';
  static String publicWorkers(String shopId) => '$apiV1/public/shops/$shopId/workers';

  // Workers
  static String workers(String shopId) =>
      '$apiV1/shops/$shopId/workers';
  static String worker(String shopId, String workerId) =>
      '$apiV1/shops/$shopId/workers/$workerId';
  static String workerResetPin(String shopId, String workerId) =>
      '$apiV1/shops/$shopId/workers/$workerId/reset-pin';
  static String workerToday(String shopId) =>
      '$apiV1/shops/$shopId/workers/me/today';
  static String workerRecentProducts(String shopId) =>
      '$apiV1/shops/$shopId/workers/me/recent-products';

  // Products
  static String products(String shopId) =>
      '$apiV1/shops/$shopId/products';
  static String product(String shopId, String productId) =>
      '$apiV1/shops/$shopId/products/$productId';
  static String productSearch(String shopId) =>
      '$apiV1/shops/$shopId/products/search';
  static String lowStock(String shopId) =>
      '$apiV1/shops/$shopId/products/low-stock';
  static String restock(String shopId, String productId) =>
      '$apiV1/shops/$shopId/products/$productId/restock';

  // Inventory
  static String inventory(String shopId) =>
      '$apiV1/shops/$shopId/inventory';

  // Sales
  static String sales(String shopId) =>
      '$apiV1/shops/$shopId/sales';
  static String sale(String shopId, String saleId) =>
      '$apiV1/shops/$shopId/sales/$saleId';

  // Reports
  static String shopToday(String shopId) =>
      '$apiV1/shops/$shopId/reports/today';

  // Categories
  static String categories(String shopId) =>
      '$apiV1/shops/$shopId/categories';
  static String category(String shopId, String categoryId) =>
      '$apiV1/shops/$shopId/categories/$categoryId';
}
