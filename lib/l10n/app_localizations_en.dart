// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tinsu-Shops';

  @override
  String get tagline => 'Simple selling, powerful results';

  @override
  String get signIn => 'Sign In';

  @override
  String get logout => 'Logout';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get pin => 'PIN';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get invalidCredentials => 'Invalid phone or PIN. Please try again.';

  @override
  String get selectShop => 'Select Shop';

  @override
  String get whoAreYou => 'Who are you?';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get searchProduct => 'Search product';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get myShops => 'My Shops';

  @override
  String get allShops => 'All Shops';

  @override
  String get addShop => 'Add Shop';

  @override
  String get shopName => 'Shop name';

  @override
  String get location => 'Location';

  @override
  String get phone => 'Phone';

  @override
  String get createShop => 'Create Shop';

  @override
  String get switchShop => 'Switch Shop';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get todaySales => 'Today\'s Sales';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get sales => 'Sales';

  @override
  String get items => 'Items';

  @override
  String get itemsSold => 'Items sold';

  @override
  String get numberOfSales => 'Number of sales';

  @override
  String get paymentBreakdown => 'Payment Breakdown';

  @override
  String get cash => 'Cash';

  @override
  String get telebirr => 'Telebirr';

  @override
  String get cbeBirr => 'CBE Birr';

  @override
  String get other => 'Other';

  @override
  String get howDidCustomerPay => 'How did the customer pay?';

  @override
  String get products => 'Products';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productName => 'Product name';

  @override
  String get sellingPrice => 'Selling price';

  @override
  String get startingStock => 'Starting stock';

  @override
  String get category => 'Category';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deactivateProduct => 'Deactivate Product';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get noProducts => 'No products yet';

  @override
  String get noProductsDesc => 'Add your first product to start selling.';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get inStock => 'In Stock';

  @override
  String stockLeft(int count) {
    return '$count left';
  }

  @override
  String get stock => 'Stock';

  @override
  String get currentStock => 'Current stock';

  @override
  String get restock => 'Restock';

  @override
  String get restockProduct => 'Restock';

  @override
  String get addQuantity => 'Add quantity';

  @override
  String get newStock => 'New stock';

  @override
  String get confirmRestock => 'Confirm Restock';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get allProducts => 'All';

  @override
  String get lowStockFilter => 'Low Stock';

  @override
  String get outOfStockFilter => 'Out of Stock';

  @override
  String productsNeedAttention(int count) {
    return '$count products need attention';
  }

  @override
  String get currentSale => 'Current Sale';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get howMany => 'How many?';

  @override
  String get addToSale => 'Add to Sale';

  @override
  String get sell => 'Sell';

  @override
  String get today => 'Today';

  @override
  String get saleComplete => 'Sale Complete';

  @override
  String get viewSale => 'View Sale';

  @override
  String get nextSale => 'Done';

  @override
  String saleNumber(String number) {
    return 'Sale #$number';
  }

  @override
  String get products2 => 'products';

  @override
  String get noSalesToday => 'No sales today';

  @override
  String get noSalesTodayDesc =>
      'Sales will appear here after something is sold.';

  @override
  String get mySalesToday => 'My Sales Today';

  @override
  String get couldNotCompleteSale => 'We couldn\'t complete the sale.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get updateCart => 'Update Cart';

  @override
  String get notEnoughStock => 'Not enough stock';

  @override
  String get cartEmpty => 'Cart is empty';

  @override
  String get cartEmptyDesc => 'Tap a product to start selling.';

  @override
  String itemsWithCount(int count, String plural, String total) {
    return '$count item$plural · $total ETB';
  }

  @override
  String get workers => 'Workers';

  @override
  String get addWorker => 'Add Worker';

  @override
  String get workerName => 'Name';

  @override
  String get workerAdded => 'Worker Added';

  @override
  String get pinAutoGenerated => 'PIN Auto-generated';

  @override
  String get sharePinWithWorker => 'Share this PIN with the worker.';

  @override
  String get copyPin => 'Copy PIN';

  @override
  String get pinCopied => 'PIN copied to clipboard';

  @override
  String get noWorkers => 'No workers yet';

  @override
  String get noWorkersDesc => 'Add your first worker.';

  @override
  String get resetPin => 'Reset PIN';

  @override
  String get disableWorker => 'Disable Worker';

  @override
  String get enableWorker => 'Enable Worker';

  @override
  String get workerRole => 'Worker';

  @override
  String get workerDisabled => 'Worker disabled';

  @override
  String get workerEnabled => 'Worker enabled';

  @override
  String get pinReset => 'PIN has been reset';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get language => 'Language';

  @override
  String get security => 'Security';

  @override
  String get shopSettings => 'Shop Settings';

  @override
  String get help => 'Help';

  @override
  String get english => 'English';

  @override
  String get amharic => 'አማርኛ';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get errorNetwork => 'Please check your connection and try again.';

  @override
  String get errorServer => 'Something went wrong. Please try again.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please log in again.';

  @override
  String errorInsufficientStock(int count) {
    return 'Only $count items are available.';
  }

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String get more => 'More';

  @override
  String get salesHistory => 'Sales History';

  @override
  String get saleDetails => 'Sale Details';

  @override
  String get soldBy => 'Sold by';

  @override
  String get payment => 'Payment';

  @override
  String get workerSalesToday => 'Sales Today';

  @override
  String get totalToday => 'Total Today';

  @override
  String get confirmLogout => 'Are you sure you want to logout?';

  @override
  String get currencySymbol => 'ETB';
}
