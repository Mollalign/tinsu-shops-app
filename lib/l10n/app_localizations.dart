import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tinsu-Shops'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Simple selling, powerful results'**
  String get tagline;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInToOwnerAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your owner account'**
  String get signInToOwnerAccount;

  /// No description provided for @loginAsWorker.
  ///
  /// In en, this message translates to:
  /// **'Login as Worker'**
  String get loginAsWorker;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone or PIN. Please try again.'**
  String get invalidCredentials;

  /// No description provided for @selectShop.
  ///
  /// In en, this message translates to:
  /// **'Select Shop'**
  String get selectShop;

  /// No description provided for @selectYourShop.
  ///
  /// In en, this message translates to:
  /// **'Select your shop to continue'**
  String get selectYourShop;

  /// No description provided for @whoAreYou.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get whoAreYou;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get searchProduct;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products or categories…'**
  String get searchProductsHint;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @myShops.
  ///
  /// In en, this message translates to:
  /// **'My Shops'**
  String get myShops;

  /// No description provided for @allShops.
  ///
  /// In en, this message translates to:
  /// **'All Shops'**
  String get allShops;

  /// No description provided for @addShop.
  ///
  /// In en, this message translates to:
  /// **'Add Shop'**
  String get addShop;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopName;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationOptional.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get locationOptional;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @createShop.
  ///
  /// In en, this message translates to:
  /// **'Create Shop'**
  String get createShop;

  /// No description provided for @switchShop.
  ///
  /// In en, this message translates to:
  /// **'Switch Shop'**
  String get switchShop;

  /// No description provided for @shopCreated.
  ///
  /// In en, this message translates to:
  /// **'Shop created'**
  String get shopCreated;

  /// No description provided for @shopsLabel.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get shopsLabel;

  /// No description provided for @shopsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and switch shops'**
  String get shopsSubtitle;

  /// No description provided for @noShopsYet.
  ///
  /// In en, this message translates to:
  /// **'No shops yet'**
  String get noShopsYet;

  /// No description provided for @noShopsDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first shop to get started.'**
  String get noShopsDesc;

  /// No description provided for @noShopSelected.
  ///
  /// In en, this message translates to:
  /// **'No shop selected'**
  String get noShopSelected;

  /// No description provided for @selectAShop.
  ///
  /// In en, this message translates to:
  /// **'Select a shop'**
  String get selectAShop;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @todaySales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaySales;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @itemsSold.
  ///
  /// In en, this message translates to:
  /// **'Items sold'**
  String get itemsSold;

  /// No description provided for @numberOfSales.
  ///
  /// In en, this message translates to:
  /// **'Number of sales'**
  String get numberOfSales;

  /// No description provided for @paymentBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Payment Breakdown'**
  String get paymentBreakdown;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @telebirr.
  ///
  /// In en, this message translates to:
  /// **'Telebirr'**
  String get telebirr;

  /// No description provided for @cbeBirr.
  ///
  /// In en, this message translates to:
  /// **'CBE Birr'**
  String get cbeBirr;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @howDidCustomerPay.
  ///
  /// In en, this message translates to:
  /// **'How did the customer pay?'**
  String get howDidCustomerPay;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price'**
  String get sellingPrice;

  /// No description provided for @startingStock.
  ///
  /// In en, this message translates to:
  /// **'Starting stock'**
  String get startingStock;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get categoryOptional;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product'**
  String get deactivateProduct;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deactivateProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product?'**
  String get deactivateProductTitle;

  /// No description provided for @deactivateProductContent.
  ///
  /// In en, this message translates to:
  /// **'This product will be hidden. Historical sales are preserved.'**
  String get deactivateProductContent;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProducts;

  /// No description provided for @noProductsDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first product to start selling.'**
  String get noProductsDesc;

  /// No description provided for @noProductsMatched.
  ///
  /// In en, this message translates to:
  /// **'No products matched \"{query}\". Try a different name or category.'**
  String noProductsMatched(String query);

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @stockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String stockLeft(int count);

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get productSaved;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productUpdated;

  /// No description provided for @noCategoriesForProducts.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesForProducts;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current stock'**
  String get currentStock;

  /// No description provided for @restock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock;

  /// No description provided for @restockProduct.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restockProduct;

  /// No description provided for @addQuantity.
  ///
  /// In en, this message translates to:
  /// **'Add quantity'**
  String get addQuantity;

  /// No description provided for @newStock.
  ///
  /// In en, this message translates to:
  /// **'New stock'**
  String get newStock;

  /// No description provided for @confirmRestock.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restock'**
  String get confirmRestock;

  /// No description provided for @stockUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stock updated'**
  String get stockUpdated;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allProducts;

  /// No description provided for @lowStockFilter.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStockFilter;

  /// No description provided for @outOfStockFilter.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStockFilter;

  /// No description provided for @productsNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'{count} products need attention'**
  String productsNeedAttention(int count);

  /// No description provided for @stockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage inventory levels'**
  String get stockSubtitle;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Drinks'**
  String get categoryHint;

  /// No description provided for @renameCategory.
  ///
  /// In en, this message translates to:
  /// **'Rename Category'**
  String get renameCategory;

  /// No description provided for @newName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newName;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteCategoryTitle(String name);

  /// No description provided for @deleteCategoryContent.
  ///
  /// In en, this message translates to:
  /// **'Products in this category will remain but will have no category assigned.'**
  String get deleteCategoryContent;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesYet;

  /// No description provided for @noCategoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add categories to help organise your products.'**
  String get noCategoriesDesc;

  /// No description provided for @couldNotLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories.'**
  String get couldNotLoadCategories;

  /// No description provided for @currentSale.
  ///
  /// In en, this message translates to:
  /// **'Current Sale'**
  String get currentSale;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @howMany.
  ///
  /// In en, this message translates to:
  /// **'How many?'**
  String get howMany;

  /// No description provided for @addToSale.
  ///
  /// In en, this message translates to:
  /// **'Add to Sale'**
  String get addToSale;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @saleComplete.
  ///
  /// In en, this message translates to:
  /// **'Sale Complete'**
  String get saleComplete;

  /// No description provided for @viewSale.
  ///
  /// In en, this message translates to:
  /// **'View Sale'**
  String get viewSale;

  /// No description provided for @nextSale.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get nextSale;

  /// No description provided for @saleNumber.
  ///
  /// In en, this message translates to:
  /// **'Sale #{number}'**
  String saleNumber(String number);

  /// No description provided for @products2.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get products2;

  /// No description provided for @noSalesToday.
  ///
  /// In en, this message translates to:
  /// **'No sales today'**
  String get noSalesToday;

  /// No description provided for @noSalesTodayDesc.
  ///
  /// In en, this message translates to:
  /// **'Sales will appear here after something is sold.'**
  String get noSalesTodayDesc;

  /// No description provided for @noSalesHistory.
  ///
  /// In en, this message translates to:
  /// **'No sales yet'**
  String get noSalesHistory;

  /// No description provided for @noSalesHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Sales will appear here after the first sale.'**
  String get noSalesHistoryDesc;

  /// No description provided for @mySalesToday.
  ///
  /// In en, this message translates to:
  /// **'My Sales Today'**
  String get mySalesToday;

  /// No description provided for @couldNotCompleteSale.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete the sale.'**
  String get couldNotCompleteSale;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @updateCart.
  ///
  /// In en, this message translates to:
  /// **'Update Cart'**
  String get updateCart;

  /// No description provided for @notEnoughStock.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock'**
  String get notEnoughStock;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap a product to start selling.'**
  String get cartEmptyDesc;

  /// No description provided for @saleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your sale is empty'**
  String get saleEmpty;

  /// No description provided for @saleEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap a product to add it.'**
  String get saleEmptyDesc;

  /// No description provided for @itemsWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item{plural} · {total} ETB'**
  String itemsWithCount(int count, String plural, String total);

  /// No description provided for @completeSale.
  ///
  /// In en, this message translates to:
  /// **'Complete Sale'**
  String get completeSale;

  /// No description provided for @completing.
  ///
  /// In en, this message translates to:
  /// **'Completing...'**
  String get completing;

  /// No description provided for @recentLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentLabel;

  /// No description provided for @noRecentProducts.
  ///
  /// In en, this message translates to:
  /// **'No recent products'**
  String get noRecentProducts;

  /// No description provided for @noRecentProductsDesc.
  ///
  /// In en, this message translates to:
  /// **'Products you sell will appear here.'**
  String get noRecentProductsDesc;

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products in this category.'**
  String get noProductsInCategory;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noSearchResults;

  /// No description provided for @noSearchResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'No products or categories matched \"{query}\".'**
  String noSearchResultsDesc(String query);

  /// No description provided for @endShift.
  ///
  /// In en, this message translates to:
  /// **'End Shift'**
  String get endShift;

  /// No description provided for @endShiftTitle.
  ///
  /// In en, this message translates to:
  /// **'End Shift?'**
  String get endShiftTitle;

  /// No description provided for @endShiftContent.
  ///
  /// In en, this message translates to:
  /// **'This will clear your cart and log you out.'**
  String get endShiftContent;

  /// No description provided for @clearSaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear sale?'**
  String get clearSaleTitle;

  /// No description provided for @clearSaleContent.
  ///
  /// In en, this message translates to:
  /// **'All items will be removed.'**
  String get clearSaleContent;

  /// No description provided for @backToProducts.
  ///
  /// In en, this message translates to:
  /// **'← Back to Products'**
  String get backToProducts;

  /// No description provided for @couldNotLoadSales.
  ///
  /// In en, this message translates to:
  /// **'Could not load sales.'**
  String get couldNotLoadSales;

  /// No description provided for @couldNotLoadSale.
  ///
  /// In en, this message translates to:
  /// **'Could not load sale.'**
  String get couldNotLoadSale;

  /// No description provided for @couldNotLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Could not load products.'**
  String get couldNotLoadProducts;

  /// No description provided for @couldNotLoadShops.
  ///
  /// In en, this message translates to:
  /// **'Could not load shops.'**
  String get couldNotLoadShops;

  /// No description provided for @couldNotLoadReport.
  ///
  /// In en, this message translates to:
  /// **'Could not load report.'**
  String get couldNotLoadReport;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @workers.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get workers;

  /// No description provided for @addWorker.
  ///
  /// In en, this message translates to:
  /// **'Add Worker'**
  String get addWorker;

  /// No description provided for @addNewWorker.
  ///
  /// In en, this message translates to:
  /// **'Add a new worker'**
  String get addNewWorker;

  /// No description provided for @workerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get workerName;

  /// No description provided for @workerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hana'**
  String get workerNameHint;

  /// No description provided for @workerAdded.
  ///
  /// In en, this message translates to:
  /// **'Worker Added'**
  String get workerAdded;

  /// No description provided for @workerCreated.
  ///
  /// In en, this message translates to:
  /// **'Worker Created'**
  String get workerCreated;

  /// No description provided for @workerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Worker updated'**
  String get workerUpdated;

  /// No description provided for @pinAutoGenerated.
  ///
  /// In en, this message translates to:
  /// **'PIN Auto-generated'**
  String get pinAutoGenerated;

  /// No description provided for @sharePinWithWorker.
  ///
  /// In en, this message translates to:
  /// **'Share this PIN with the worker.'**
  String get sharePinWithWorker;

  /// No description provided for @shareWithWorker.
  ///
  /// In en, this message translates to:
  /// **'Share this with the worker.'**
  String get shareWithWorker;

  /// No description provided for @pinOnlyShownOnce.
  ///
  /// In en, this message translates to:
  /// **'This is the only time it will be shown.'**
  String get pinOnlyShownOnce;

  /// No description provided for @copyPin.
  ///
  /// In en, this message translates to:
  /// **'Copy PIN'**
  String get copyPin;

  /// No description provided for @pinCopied.
  ///
  /// In en, this message translates to:
  /// **'PIN copied to clipboard'**
  String get pinCopied;

  /// No description provided for @noWorkers.
  ///
  /// In en, this message translates to:
  /// **'No workers yet'**
  String get noWorkers;

  /// No description provided for @noWorkersDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first worker.'**
  String get noWorkersDesc;

  /// No description provided for @resetPin.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN'**
  String get resetPin;

  /// No description provided for @disableWorker.
  ///
  /// In en, this message translates to:
  /// **'Disable Worker'**
  String get disableWorker;

  /// No description provided for @enableWorker.
  ///
  /// In en, this message translates to:
  /// **'Enable Worker'**
  String get enableWorker;

  /// No description provided for @workerRole.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get workerRole;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @workerDisabled.
  ///
  /// In en, this message translates to:
  /// **'Worker disabled'**
  String get workerDisabled;

  /// No description provided for @workerEnabled.
  ///
  /// In en, this message translates to:
  /// **'Worker enabled'**
  String get workerEnabled;

  /// No description provided for @pinReset.
  ///
  /// In en, this message translates to:
  /// **'PIN has been reset'**
  String get pinReset;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @disabledStatus.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabledStatus;

  /// No description provided for @workerNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty.'**
  String get workerNameEmpty;

  /// No description provided for @workerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get workerNameRequired;

  /// No description provided for @couldNotLoadWorkers.
  ///
  /// In en, this message translates to:
  /// **'Could not load workers.'**
  String get couldNotLoadWorkers;

  /// No description provided for @couldNotLoadWorker.
  ///
  /// In en, this message translates to:
  /// **'Could not load worker.'**
  String get couldNotLoadWorker;

  /// No description provided for @workersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your team'**
  String get workersSubtitle;

  /// No description provided for @generateAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Generate automatically'**
  String get generateAutomatically;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @createWorker.
  ///
  /// In en, this message translates to:
  /// **'Create Worker'**
  String get createWorker;

  /// No description provided for @pinDigitsHint.
  ///
  /// In en, this message translates to:
  /// **'4+ digits'**
  String get pinDigitsHint;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @pinMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits.'**
  String get pinMustBe4Digits;

  /// No description provided for @pinMustBeDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'PIN must contain only digits.'**
  String get pinMustBeDigitsOnly;

  /// No description provided for @pinsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match.'**
  String get pinsMustMatch;

  /// No description provided for @newPinsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'New PIN and confirmation do not match.'**
  String get newPinsMustMatch;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @shopSettings.
  ///
  /// In en, this message translates to:
  /// **'Shop Settings'**
  String get shopSettings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @amharic.
  ///
  /// In en, this message translates to:
  /// **'አማርኛ'**
  String get amharic;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @changePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your login PIN'**
  String get changePinSubtitle;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get confirmNewPin;

  /// No description provided for @pinChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully.'**
  String get pinChangedSuccess;

  /// No description provided for @updateLoginPin.
  ///
  /// In en, this message translates to:
  /// **'Update your login PIN'**
  String get updateLoginPin;

  /// No description provided for @enterCurrentPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN to confirm, then set a new one.'**
  String get enterCurrentPinHint;

  /// No description provided for @currentPinRequired.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is required.'**
  String get currentPinRequired;

  /// No description provided for @newPinMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'New PIN must be at least 4 digits.'**
  String get newPinMustBe4Digits;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String goodMorning(String name);

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String goodAfternoon(String name);

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String goodEvening(String name);

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get nameRequired;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required.'**
  String get priceRequired;

  /// No description provided for @priceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price.'**
  String get priceInvalid;

  /// No description provided for @stockInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number.'**
  String get stockInvalid;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorServer;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorInsufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Only {count} of \"{productName}\" available.'**
  String errorInsufficientStock(int count, String productName);

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get errorNotFound;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// No description provided for @salesHistory.
  ///
  /// In en, this message translates to:
  /// **'Sales History'**
  String get salesHistory;

  /// No description provided for @saleDetails.
  ///
  /// In en, this message translates to:
  /// **'Sale Details'**
  String get saleDetails;

  /// No description provided for @soldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by'**
  String get soldBy;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @workerSalesToday.
  ///
  /// In en, this message translates to:
  /// **'Sales Today'**
  String get workerSalesToday;

  /// No description provided for @totalToday.
  ///
  /// In en, this message translates to:
  /// **'Total Today'**
  String get totalToday;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'ETB'**
  String get currencySymbol;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @shopLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopLabel;

  /// No description provided for @recentSales.
  ///
  /// In en, this message translates to:
  /// **'Recent Sales'**
  String get recentSales;

  /// No description provided for @allStocked.
  ///
  /// In en, this message translates to:
  /// **'All products well-stocked'**
  String get allStocked;

  /// No description provided for @allStockedDesc.
  ///
  /// In en, this message translates to:
  /// **'No products need attention right now.'**
  String get allStockedDesc;

  /// No description provided for @stockRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String stockRemaining(int count);

  /// No description provided for @currentStockValue.
  ///
  /// In en, this message translates to:
  /// **'Current stock: {count}'**
  String currentStockValue(int count);

  /// No description provided for @noProductsFilter.
  ///
  /// In en, this message translates to:
  /// **'No products match the selected filter.'**
  String get noProductsFilter;

  /// No description provided for @useAnotherAccount.
  ///
  /// In en, this message translates to:
  /// **'Use another account'**
  String get useAnotherAccount;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockLabel;

  /// No description provided for @updatePin.
  ///
  /// In en, this message translates to:
  /// **'Update PIN'**
  String get updatePin;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @workerAccount.
  ///
  /// In en, this message translates to:
  /// **'Worker Account'**
  String get workerAccount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
