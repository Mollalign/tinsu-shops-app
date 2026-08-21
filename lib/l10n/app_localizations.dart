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

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

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

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

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

  /// No description provided for @stockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String stockLeft(int count);

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

  /// No description provided for @itemsWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item{plural} · {total} ETB'**
  String itemsWithCount(int count, String plural, String total);

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

  /// No description provided for @workerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get workerName;

  /// No description provided for @workerAdded.
  ///
  /// In en, this message translates to:
  /// **'Worker Added'**
  String get workerAdded;

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

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

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
  /// **'Only {count} items are available.'**
  String errorInsufficientStock(int count);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

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
