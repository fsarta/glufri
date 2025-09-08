// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Glufri';

  @override
  String get newPurchase => 'New Purchase';

  @override
  String get purchaseHistory => 'Purchase History';

  @override
  String get settings => 'Settings';

  @override
  String get addItem => 'Add Item';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get savePurchase => 'Save Purchase';

  @override
  String get store => 'Store';

  @override
  String get productName => 'Product Name';

  @override
  String get price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get total => 'Total';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get login => 'Login';

  @override
  String get loginAction => 'LOGIN';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordScreenTitle => 'Recover Password';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordInstruction =>
      'Enter the email associated with your account. We\'ll send you a link to reset your password.';

  @override
  String get sendResetEmail => 'SEND RESET EMAIL';

  @override
  String get resetEmailSuccess =>
      'Recovery email sent successfully! Check your inbox.';

  @override
  String get resetEmailError =>
      'Error sending the email. The address may not be valid.';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get or => 'or';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get signup => 'Sign up';

  @override
  String get signupAction => 'SIGN UP';

  @override
  String get signupTitle => 'Create your account';

  @override
  String get email => 'Email';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get invalidEmailError => 'Please enter a valid email.';

  @override
  String get passwordLengthError =>
      'The password must be at least 6 characters long.';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match.';

  @override
  String get signupError =>
      'Error during signup. Please try again. (e.g., the email might already be in use)';

  @override
  String get account => 'Account';

  @override
  String loggedInAs(String email) {
    return 'Logged in as $email';
  }

  @override
  String get searchPlaceholder => 'Search by store or product...';

  @override
  String noProductsFoundFor(String query) {
    return 'No products found for \"$query\"';
  }

  @override
  String get noPurchases =>
      'No purchases recorded.\nPress \"+\" to get started!';

  @override
  String get purchaseDetail => 'Purchase Detail';

  @override
  String get shareSummary => 'Share Summary';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get exportCsvPro => 'Export CSV (Pro)';

  @override
  String get delete => 'Delete';

  @override
  String get noStoreSpecified => 'No store specified';

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
  String get exportError => 'Export error.';

  @override
  String get shareError => 'Sharing error.';

  @override
  String get deleteConfirmationTitle => 'Delete Confirmation';

  @override
  String get deleteConfirmationMessage =>
      'Are you sure you want to delete this purchase? This action is irreversible.';

  @override
  String get cancel => 'Cancel';

  @override
  String get purchaseDeletedSuccess => 'Purchase deleted successfully.';

  @override
  String get editPurchase => 'Edit Purchase';

  @override
  String get purchaseSavedSuccess => 'Purchase saved successfully!';

  @override
  String get addProductToStart => 'Add a product to get started.';

  @override
  String get productNotFoundOrNetworkError =>
      'Product not found or network error.';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productNameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get mustBeGreaterThanZero => 'Must be > 0';

  @override
  String get barcodeOptional => 'Barcode (Optional)';

  @override
  String get update => 'Update';

  @override
  String get glutenFreeProduct => 'Gluten-Free Product';

  @override
  String get totalGlutenFree => 'Gluten-Free Total';

  @override
  String get totalOther => 'Other Total';

  @override
  String get totalOverall => 'Overall Total';

  @override
  String get foundProducts => 'Found products:';

  @override
  String get glutenFree => 'Gluten-Free';

  @override
  String get other => 'Other';

  @override
  String get scanBarcodeTitle => 'Scan EAN-13';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Glufri!';

  @override
  String get onboardingWelcomeBody =>
      'Your app to track gluten-free purchases quickly and easily.';

  @override
  String get onboardingScanTitle => 'Scan and Add';

  @override
  String get onboardingScanBody =>
      'Use the camera to scan product barcodes and add them to your cart.';

  @override
  String get onboardingTrackTitle => 'Keep Everything Under Control';

  @override
  String get onboardingTrackBody =>
      'Save your purchases and view the history to analyze your spending.';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageItalian => 'Italian';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAccountAndBackup => 'Account and Backup (Pro)';

  @override
  String get settingsLoginForBackup => 'Log in with Google to enable backup';

  @override
  String get settingsLoginFailed => 'Login failed. Please try again.';

  @override
  String get user => 'User';

  @override
  String get settingsBackupNow => 'Back Up Now';

  @override
  String get settingsRestoreFromCloud => 'Restore from Cloud';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get settingsAuthError => 'Authentication error';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get upsellTitle => 'Go Pro with Glufri';

  @override
  String get upsellHeadline => 'Unlock Powerful Features!';

  @override
  String get upsellFeature1 => 'Multi-device Backup and Sync';

  @override
  String get upsellFeature2 => 'Unlimited CSV Exports';

  @override
  String get upsellFeature3 => 'Ad-free experience';

  @override
  String get upsellFeature4 => 'Priority Support';

  @override
  String get upsellAction => 'Subscribe Now (Annual Price)';

  @override
  String get upsellRestore => 'Restore Purchases';

  @override
  String get migrationDialogTitle => 'Local Purchases Detected';

  @override
  String migrationDialogBody(int count) {
    return 'You have $count purchases saved on this device. What do you want to do?';
  }

  @override
  String get migrationDialogActionDelete => 'DELETE';

  @override
  String get migrationDialogActionIgnore => 'NO, LEAVE THEM';

  @override
  String get migrationDialogActionMerge => 'YES, MERGE';

  @override
  String get migrationSuccess => 'Local purchases merged with your account!';

  @override
  String get migrationDeleted => 'Local data deleted successfully.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyBody =>
      'Your privacy is important...\n[INSERT FULL PRIVACY POLICY TEXT HERE]\n\nData Collected: The app saves purchase data exclusively on your device. If you choose to use the cloud backup feature (Pro feature), your data will be encrypted and saved on Google Firebase\'s secure servers.\n\nData Sharing: No personal or purchase data is shared with third parties.\n...';

  @override
  String get genericPurchase => 'Generic purchase';

  @override
  String get mainProducts => 'Main products:';

  @override
  String andMoreProducts(int count) {
    return '... and $count more products.';
  }

  @override
  String get trackedWith => 'Tracked with Glufri App';

  @override
  String get shareText =>
      'Here\'s my latest gluten-free purchase tracked with the Glufri app! 🛒';

  @override
  String genericError(Object error) {
    return 'An error occurred:\n$error';
  }

  @override
  String purchaseExport(String store) {
    return 'Glufri Purchase Export - $store';
  }

  @override
  String get storeHint => 'e.g., Rossi Supermarket';

  @override
  String get loginSuccess => 'Welcome!';

  @override
  String get logoutSuccess => 'Logged out successfully.';

  @override
  String get undoAction => 'UNDO';

  @override
  String get purchaseMarkedForDeletion => 'Purchase deleted.';

  @override
  String get backupInProgress => 'Backup in progress...';

  @override
  String get backupSuccess => 'Backup completed successfully!';

  @override
  String get backupError => 'Error during backup.';

  @override
  String get restoreConfirmationTitle => 'Restore Confirmation';

  @override
  String get restoreConfirmationBody =>
      'This will overwrite all local data with the data saved in the cloud. Continue?';

  @override
  String get restoreInProgress => 'Restoring in progress...';

  @override
  String get restoreSuccess => 'Data restored successfully!';

  @override
  String get restoreError => 'Error during restore.';

  @override
  String get productHistoryTitle => 'Product already purchased!';

  @override
  String get lastPrice => 'Last price:';

  @override
  String get atStore => 'at';

  @override
  String get times => 'times';

  @override
  String priceRange(Object max, Object min) {
    return 'Prices: from €$min to €$max';
  }

  @override
  String get continueAction => 'CONTINUE';
}
