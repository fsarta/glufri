// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get add => 'Add';

  @override
  String get appName => 'Glufri';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get continueAction => 'CONTINUE';

  @override
  String get create => 'Create';

  @override
  String get delete => 'Delete';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get edit => 'Edit';

  @override
  String get loading => 'Loading...';

  @override
  String get or => 'or';

  @override
  String get price => 'Price';

  @override
  String get productName => 'Product Name';

  @override
  String get quantity => 'Quantity';

  @override
  String get save => 'Save';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get store => 'Store';

  @override
  String get total => 'Total';

  @override
  String get undoAction => 'UNDO';

  @override
  String get update => 'Update';

  @override
  String get favoriteProducts => 'Favorite Products';

  @override
  String get forgotPasswordScreenTitle => 'Recover Password';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get purchaseHistory => 'Purchase History';

  @override
  String get scanBarcodeTitle => 'Scan EAN-13';

  @override
  String get settings => 'Settings';

  @override
  String get shoppingLists => 'Shopping Lists';

  @override
  String get shoppingListsScreenTitle => 'Shopping Lists';

  @override
  String get onboardingScanBody =>
      'Use the camera to scan product barcodes and add them to your cart.';

  @override
  String get onboardingScanTitle => 'Scan and Add';

  @override
  String get onboardingTrackBody =>
      'Save your purchases and view the history to analyze your spending.';

  @override
  String get onboardingTrackTitle => 'Keep Everything Under Control';

  @override
  String get onboardingWelcomeBody =>
      'Your app to track gluten-free purchases quickly and easily.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Glufri!';

  @override
  String get account => 'Account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get alreadyHaveAccountPrompt => 'Already have an account?';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get email => 'Email';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordInstruction =>
      'Enter the email associated with your account. We\'ll send you a link to reset your password.';

  @override
  String get forgotPasswordSubtitle =>
      'No problem! Enter your email and we\'ll help you out.';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get googleLoginFailed => 'Google login failed. Please try again.';

  @override
  String get invalidEmailError => 'Please enter a valid email.';

  @override
  String loggedInAs(String email) {
    return 'Logged in as $email';
  }

  @override
  String get login => 'Login';

  @override
  String get loginAction => 'LOGIN';

  @override
  String get loginError => 'Invalid email or password. Please try again.';

  @override
  String get loginToSaveData => 'Log in to save your data';

  @override
  String get loginSubtitle => 'Login to your account to continue.';

  @override
  String get loginSuccess => 'Welcome!';

  @override
  String get loginWelcome => 'Welcome Back!';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get logoutSuccess => 'Logged out successfully.';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get password => 'Password';

  @override
  String get passwordLengthError =>
      'The password must be at least 6 characters long.';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match.';

  @override
  String get resetEmailError =>
      'Error sending the email. The address may not be valid.';

  @override
  String get resetEmailSuccess =>
      'Recovery email sent successfully! Check your inbox.';

  @override
  String get sendResetEmail => 'SEND RESET EMAIL';

  @override
  String get signup => 'Sign up';

  @override
  String get signupAction => 'SIGN UP';

  @override
  String get signupError =>
      'Error during signup. Please try again. (e.g., the email might already be in use)';

  @override
  String get signupSubtitle => 'Create an account to save your data';

  @override
  String get signupTitle => 'Create your account';

  @override
  String get user => 'User';

  @override
  String get userGuest => 'Guest User';

  @override
  String get addItem => 'Add Item';

  @override
  String get addProductToStart => 'Add a product to get started.';

  @override
  String andMoreProducts(int count) {
    return '... and $count more products.';
  }

  @override
  String get atStore => 'at';

  @override
  String get barcodeOptional => 'Barcode (Optional)';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get editPurchase => 'Edit Purchase';

  @override
  String get exportCsvPro => 'Export CSV (Pro)';

  @override
  String get exportPdfAnnualReport => 'Export Annual Report';

  @override
  String get exportPdfCompleteReport => 'Complete Report';

  @override
  String get exportPdfMonthlyReport => 'Export Monthly Report';

  @override
  String get exportPdfReportTooltip => 'Export Report';

  @override
  String get filterByDateTooltip => 'Filter by date';

  @override
  String get foundProducts => 'Found products:';

  @override
  String get genericPurchase => 'Generic purchase';

  @override
  String get glutenFree => 'Gluten-Free';

  @override
  String get glutenFreeProduct => 'Gluten-Free Product';

  @override
  String get lastPrice => 'Last price:';

  @override
  String get mainProducts => 'Main products:';

  @override
  String get mustBeGreaterThanZero => 'Must be > 0';

  @override
  String get newPurchase => 'New Purchase';

  @override
  String noProductsFoundFor(String query) {
    return 'No products found for \"$query\"';
  }

  @override
  String get noPurchases =>
      'No purchases recorded.\nPress \"+\" to get started!';

  @override
  String get noStoreSpecified => 'No store specified';

  @override
  String get other => 'Other';

  @override
  String pdfReportTitleAnnual(String year) {
    return 'Spending Report - $year';
  }

  @override
  String get pdfReportTitleComplete => 'Complete Spending Report';

  @override
  String pdfReportTitleMonthly(String date) {
    return 'Spending Report - $date';
  }

  @override
  String priceRange(Object max, Object min) {
    return 'Prices: from €$min to €$max';
  }

  @override
  String get productHistoryTitle => 'Product already purchased!';

  @override
  String get productNameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get productNotFoundOrNetworkError =>
      'Product not found or network error.';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String get purchaseDetail => 'Purchase Detail';

  @override
  String purchaseExport(String store) {
    return 'Glufri Purchase Export - $store';
  }

  @override
  String get purchaseMarkedForDeletion => 'Purchase deleted.';

  @override
  String get purchaseSavedSuccess => 'Purchase saved successfully!';

  @override
  String purchasedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Purchased $count times',
      one: 'Purchased 1 time',
      zero: 'Never purchased',
    );
    return '$_temp0';
  }

  @override
  String get removeDateFilterTooltip => 'Remove date filter';

  @override
  String get savePurchase => 'Save Purchase';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get searchPlaceholder => 'Search by store or product...';

  @override
  String selectMonthOfYear(String year) {
    return 'Select a Month of $year';
  }

  @override
  String get shareSummary => 'Share Summary';

  @override
  String get shareText =>
      'Here\'s my latest gluten-free purchase tracked with the Glufri app! 🛒';

  @override
  String get storeHint => 'e.g., Rossi Supermarket';

  @override
  String get times => 'times';

  @override
  String get totalGlutenFree => 'Gluten-Free Total';

  @override
  String get totalOther => 'Other Total';

  @override
  String get totalOverall => 'Overall Total';

  @override
  String get trackedWith => 'Tracked with Glufri App';

  @override
  String get addFromFavorites => 'Add from Favorites';

  @override
  String get addItemToShoppingList => 'Add Item';

  @override
  String get addItemTooltip => 'Add item';

  @override
  String get addManual => 'Add manually';

  @override
  String checkedItems(String checked, String total) {
    return '$checked/$total completed';
  }

  @override
  String get createNewListTooltip => 'New List';

  @override
  String get createListDialogTitle => 'Create New List';

  @override
  String deleteListConfirmationBody(String listName) {
    return 'Are you sure you want to delete the list \'$listName\'?';
  }

  @override
  String get deleteListConfirmationTitle => 'Confirm Deletion';

  @override
  String get emptyShoppingList =>
      'No shopping lists found.\nPress \'+\' to create one.';

  @override
  String itemAddedToList(String itemName) {
    return '\'$itemName\' added to list.';
  }

  @override
  String get listName => 'List name';

  @override
  String get listNameEmptyError => 'Name cannot be empty.';

  @override
  String get noItemsInShoppingList =>
      'Add or un-check at least one item to start.';

  @override
  String get startPurchaseFromList => 'Start Purchase from List';

  @override
  String get addEditFavoriteDialogAdd => 'Add Favorite';

  @override
  String get addEditFavoriteDialogEdit => 'Edit Favorite';

  @override
  String get addFavoriteProduct => 'Add Favorite';

  @override
  String get addFromFavoritesTooltip => 'Add from Favorites';

  @override
  String get addToFavorites => 'Add to favorite products';

  @override
  String get defaultPrice => 'Default Price (Optional)';

  @override
  String deleteFavoriteConfirmationBody(String productName) {
    return 'Are you sure you want to remove \'$productName\' from your favorites?';
  }

  @override
  String favoriteProductRemoved(Object productName) {
    return '\'$productName\' removed from favorites.';
  }

  @override
  String get noFavoriteProducts =>
      'You don\'t have any favorite products yet.\nSave them from a purchase to find them here.';

  @override
  String get noFavoritesAvailable => 'You don\'t have any favorite products.';

  @override
  String get selectFavorite => 'Select a Favorite';

  @override
  String get settingsFavProducts => 'Favorite Products';

  @override
  String get budgetSaved => 'Budget saved!';

  @override
  String get budgetSetGlutenFree => 'Gluten-Free Budget';

  @override
  String get budgetSetTotal => 'Total Budget';

  @override
  String budgetTitle(String monthYear) {
    return 'Budget for $monthYear';
  }

  @override
  String get budgetTrend => 'Spending Trend';

  @override
  String get remainingBudget => 'Remaining Budget';

  @override
  String get saveBudget => 'Save Budget';

  @override
  String get setBudget => 'Set Budgets';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get light => 'Light';

  @override
  String get privacyPolicyBody =>
      'Your privacy is important...\n[INSERT FULL PRIVACY POLICY TEXT HERE]\n\nData Collected: The app saves purchase data exclusively on your device. If you choose to use the cloud backup feature (Pro feature), your data will be encrypted and saved on Google Firebase\'s secure servers.\n\nData Sharing: No personal or purchase data is shared with third parties.\n...';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get settingsAccountAndBackup => 'Account and Backup (Pro)';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLoginForBackup => 'Log in with Google to enable backup';

  @override
  String get settingsLoginFailed => 'Login failed. Please try again.';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get system => 'System';

  @override
  String get theme => 'Theme';

  @override
  String get proRequiredForHistory => 'Go Pro to see price history!';

  @override
  String get unlockPro => 'UNLOCK';

  @override
  String get upsellAction => 'Subscribe Now (Annual Price)';

  @override
  String get upsellFeature1 => 'Multi-device Backup and Sync';

  @override
  String get upsellFeature2 => 'Unlimited CSV Exports';

  @override
  String get upsellFeature3 => 'Ad-free experience';

  @override
  String get upsellFeature4 => 'Priority Support';

  @override
  String get upsellHeadline => 'Unlock Powerful Features!';

  @override
  String get upsellRestore => 'Restore Purchases';

  @override
  String get upsellTitle => 'Go Pro with Glufri';

  @override
  String get backupError => 'Error during backup.';

  @override
  String get backupInProgress => 'Backup in progress...';

  @override
  String get backupSuccess => 'Backup completed successfully!';

  @override
  String get migrationDeleted => 'Local data deleted successfully.';

  @override
  String get migrationDialogActionDelete => 'DELETE';

  @override
  String get migrationDialogActionIgnore => 'NO, LEAVE THEM';

  @override
  String get migrationDialogActionMerge => 'YES, MERGE';

  @override
  String migrationDialogBody(int count) {
    return 'You have $count purchases saved on this device. What do you want to do?';
  }

  @override
  String get migrationDialogTitle => 'Local Purchases Detected';

  @override
  String get migrationSuccess => 'Local purchases merged with your account!';

  @override
  String get restoreConfirmationBody =>
      'This will overwrite all local data with the data saved in the cloud. Continue?';

  @override
  String get restoreConfirmationTitle => 'Restore Confirmation';

  @override
  String get restoreError => 'Error during restore.';

  @override
  String get restoreInProgress => 'Restoring in progress...';

  @override
  String get restoreSuccess => 'Data restored successfully!';

  @override
  String get settingsAuthError => 'Authentication error';

  @override
  String get settingsBackupNow => 'Back Up Now';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get settingsRestoreFromCloud => 'Restore from Cloud';

  @override
  String get deleteConfirmationMessage =>
      'Are you sure you want to delete this purchase? This action is irreversible.';

  @override
  String get deleteConfirmationTitle => 'Delete Confirmation';

  @override
  String get exportError => 'Export error.';

  @override
  String genericError(Object error) {
    return 'An error occurred:\n$error';
  }

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get listNotFound => 'List not found or deleted.';

  @override
  String get pdfCreationError => 'Error creating the PDF.';

  @override
  String get purchaseDeletedSuccess => 'Purchase deleted successfully.';

  @override
  String get requiredField => 'Required field';

  @override
  String get shareError => 'Sharing error.';

  @override
  String get shoppingListError => 'Error loading lists.';

  @override
  String get syncError => 'Synchronization error.';
}
