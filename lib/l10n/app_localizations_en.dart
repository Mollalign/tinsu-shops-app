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
  String get signInToOwnerAccount => 'Sign in to your owner account';

  @override
  String get loginAsWorker => 'Login as Worker';

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
  String get selectYourShop => 'Select your shop to continue';

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
  String get searchProductsHint => 'Search products or categories…';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get clear => 'Clear';

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
  String get locationOptional => 'Location (optional)';

  @override
  String get phone => 'Phone';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get createShop => 'Create Shop';

  @override
  String get switchShop => 'Switch Shop';

  @override
  String get shopCreated => 'Shop created';

  @override
  String get shopsLabel => 'Shops';

  @override
  String get shopsSubtitle => 'View and switch shops';

  @override
  String get noShopsYet => 'No shops yet';

  @override
  String get noShopsDesc => 'Add your first shop to get started.';

  @override
  String get noShopSelected => 'No shop selected';

  @override
  String get selectAShop => 'Select a shop';

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
  String get productLabel => 'Product';

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
  String get categoryOptional => 'Category (optional)';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deactivateProduct => 'Deactivate Product';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivateProductTitle => 'Deactivate Product?';

  @override
  String get deactivateProductContent =>
      'This product will be hidden. Historical sales are preserved.';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get noProducts => 'No products yet';

  @override
  String get noProductsDesc => 'Add your first product to start selling.';

  @override
  String noProductsMatched(String query) {
    return 'No products matched \"$query\". Try a different name or category.';
  }

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get inStock => 'In Stock';

  @override
  String get inactive => 'Inactive';

  @override
  String stockLeft(int count) {
    return '$count left';
  }

  @override
  String get productSaved => 'Product saved';

  @override
  String get productUpdated => 'Product updated';

  @override
  String get noCategoriesForProducts => 'No categories yet';

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
  String get stockSubtitle => 'Manage inventory levels';

  @override
  String get management => 'Management';

  @override
  String get categories => 'Categories';

  @override
  String get addCategory => 'Add Category';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryHint => 'e.g. Drinks';

  @override
  String get renameCategory => 'Rename Category';

  @override
  String get newName => 'New name';

  @override
  String get rename => 'Rename';

  @override
  String deleteCategoryTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteCategoryContent =>
      'Products in this category will remain but will have no category assigned.';

  @override
  String get noCategoriesYet => 'No categories yet';

  @override
  String get noCategoriesDesc =>
      'Add categories to help organise your products.';

  @override
  String get couldNotLoadCategories => 'Could not load categories.';

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
  String get noSalesHistory => 'No sales yet';

  @override
  String get noSalesHistoryDesc =>
      'Sales will appear here after the first sale.';

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
  String get saleEmpty => 'Your sale is empty';

  @override
  String get saleEmptyDesc => 'Tap a product to add it.';

  @override
  String itemsWithCount(int count, String plural, String total) {
    return '$count item$plural · $total ETB';
  }

  @override
  String get completeSale => 'Complete Sale';

  @override
  String get completing => 'Completing...';

  @override
  String get recentLabel => 'Recent';

  @override
  String get noRecentProducts => 'No recent products';

  @override
  String get noRecentProductsDesc => 'Products you sell will appear here.';

  @override
  String get noProductsInCategory => 'No products in this category.';

  @override
  String get noSearchResults => 'No results';

  @override
  String noSearchResultsDesc(String query) {
    return 'No products or categories matched \"$query\".';
  }

  @override
  String get endShift => 'End Shift';

  @override
  String get endShiftTitle => 'End Shift?';

  @override
  String get endShiftContent => 'This will clear your cart and log you out.';

  @override
  String get clearSaleTitle => 'Clear sale?';

  @override
  String get clearSaleContent => 'All items will be removed.';

  @override
  String get backToProducts => '← Back to Products';

  @override
  String get couldNotLoadSales => 'Could not load sales.';

  @override
  String get couldNotLoadSale => 'Could not load sale.';

  @override
  String get couldNotLoadProducts => 'Could not load products.';

  @override
  String get couldNotLoadShops => 'Could not load shops.';

  @override
  String get couldNotLoadReport => 'Could not load report.';

  @override
  String get dateLabel => 'Date';

  @override
  String get workers => 'Workers';

  @override
  String get addWorker => 'Add Worker';

  @override
  String get addNewWorker => 'Add a new worker';

  @override
  String get workerName => 'Name';

  @override
  String get workerNameHint => 'e.g. Hana';

  @override
  String get workerAdded => 'Worker Added';

  @override
  String get workerCreated => 'Worker Created';

  @override
  String get workerUpdated => 'Worker updated';

  @override
  String get pinAutoGenerated => 'PIN Auto-generated';

  @override
  String get sharePinWithWorker => 'Share this PIN with the worker.';

  @override
  String get shareWithWorker => 'Share this with the worker.';

  @override
  String get pinOnlyShownOnce => 'This is the only time it will be shown.';

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
  String get ownerLabel => 'Owner';

  @override
  String get workerDisabled => 'Worker disabled';

  @override
  String get workerEnabled => 'Worker enabled';

  @override
  String get pinReset => 'PIN has been reset';

  @override
  String get activeStatus => 'Active';

  @override
  String get disabledStatus => 'Disabled';

  @override
  String get workerNameEmpty => 'Name cannot be empty.';

  @override
  String get workerNameRequired => 'Name is required.';

  @override
  String get couldNotLoadWorkers => 'Could not load workers.';

  @override
  String get couldNotLoadWorker => 'Could not load worker.';

  @override
  String get workersSubtitle => 'Manage your team';

  @override
  String get generateAutomatically => 'Generate automatically';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get createWorker => 'Create Worker';

  @override
  String get pinDigitsHint => '4+ digits';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get pinMustBe4Digits => 'PIN must be at least 4 digits.';

  @override
  String get pinMustBeDigitsOnly => 'PIN must contain only digits.';

  @override
  String get pinsMustMatch => 'PINs do not match.';

  @override
  String get newPinsMustMatch => 'New PIN and confirmation do not match.';

  @override
  String get settings => 'Settings';

  @override
  String get more => 'More';

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
  String get preferences => 'Preferences';

  @override
  String get support => 'Support';

  @override
  String get changePin => 'Change PIN';

  @override
  String get changePinSubtitle => 'Update your login PIN';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get confirmNewPin => 'Confirm New PIN';

  @override
  String get pinChangedSuccess => 'PIN changed successfully.';

  @override
  String get updateLoginPin => 'Update your login PIN';

  @override
  String get enterCurrentPinHint =>
      'Enter your current PIN to confirm, then set a new one.';

  @override
  String get currentPinRequired => 'Current PIN is required.';

  @override
  String get newPinMustBe4Digits => 'New PIN must be at least 4 digits.';

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
  String get nameRequired => 'Name is required.';

  @override
  String get priceRequired => 'Price is required.';

  @override
  String get priceInvalid => 'Enter a valid price.';

  @override
  String get stockInvalid => 'Enter a whole number.';

  @override
  String get errorNetwork => 'Please check your connection and try again.';

  @override
  String get errorServer => 'Something went wrong. Please try again.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please log in again.';

  @override
  String errorInsufficientStock(int count, String productName) {
    return 'Only $count of \"$productName\" available.';
  }

  @override
  String get errorNotFound => 'The requested item was not found.';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

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

  @override
  String get home => 'Home';

  @override
  String get shopLabel => 'Shop';

  @override
  String get recentSales => 'Recent Sales';

  @override
  String get allStocked => 'All products well-stocked';

  @override
  String get allStockedDesc => 'No products need attention right now.';

  @override
  String stockRemaining(int count) {
    return '$count remaining';
  }

  @override
  String currentStockValue(int count) {
    return 'Current stock: $count';
  }

  @override
  String get noProductsFilter => 'No products match the selected filter.';

  @override
  String get useAnotherAccount => 'Use another account';

  @override
  String get recent => 'Recent';

  @override
  String get all => 'All';

  @override
  String get stockLabel => 'Stock';
}
