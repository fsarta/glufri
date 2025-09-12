import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @add.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi'**
  String get add;

  /// No description provided for @appName.
  ///
  /// In it, this message translates to:
  /// **'Glufri'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get close;

  /// No description provided for @continueAction.
  ///
  /// In it, this message translates to:
  /// **'CONTINUA'**
  String get continueAction;

  /// No description provided for @create.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get create;

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get delete;

  /// No description provided for @duplicate.
  ///
  /// In it, this message translates to:
  /// **'Duplica'**
  String get duplicate;

  /// No description provided for @edit.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get edit;

  /// No description provided for @loading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento...'**
  String get loading;

  /// No description provided for @or.
  ///
  /// In it, this message translates to:
  /// **'oppure'**
  String get or;

  /// No description provided for @price.
  ///
  /// In it, this message translates to:
  /// **'Prezzo'**
  String get price;

  /// No description provided for @productName.
  ///
  /// In it, this message translates to:
  /// **'Nome Prodotto'**
  String get productName;

  /// No description provided for @quantity.
  ///
  /// In it, this message translates to:
  /// **'Quantità'**
  String get quantity;

  /// No description provided for @save.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get save;

  /// No description provided for @skip.
  ///
  /// In it, this message translates to:
  /// **'Salta'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In it, this message translates to:
  /// **'Inizia'**
  String get start;

  /// No description provided for @store.
  ///
  /// In it, this message translates to:
  /// **'Negozio'**
  String get store;

  /// No description provided for @total.
  ///
  /// In it, this message translates to:
  /// **'Totale'**
  String get total;

  /// No description provided for @unit.
  ///
  /// In it, this message translates to:
  /// **'Unità'**
  String get unit;

  /// No description provided for @undoAction.
  ///
  /// In it, this message translates to:
  /// **'ANNULLA'**
  String get undoAction;

  /// No description provided for @update.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna'**
  String get update;

  /// No description provided for @favoriteProducts.
  ///
  /// In it, this message translates to:
  /// **'Prodotti Preferiti'**
  String get favoriteProducts;

  /// No description provided for @forgotPasswordScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Recupera Password'**
  String get forgotPasswordScreenTitle;

  /// No description provided for @monthlyBudget.
  ///
  /// In it, this message translates to:
  /// **'Budget Mensile'**
  String get monthlyBudget;

  /// No description provided for @purchaseHistory.
  ///
  /// In it, this message translates to:
  /// **'Cronologia Acquisti'**
  String get purchaseHistory;

  /// No description provided for @scanBarcodeTitle.
  ///
  /// In it, this message translates to:
  /// **'Scansiona EAN-13'**
  String get scanBarcodeTitle;

  /// No description provided for @settings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings;

  /// No description provided for @shoppingLists.
  ///
  /// In it, this message translates to:
  /// **'Liste della Spesa'**
  String get shoppingLists;

  /// No description provided for @shoppingListsScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Liste della Spesa'**
  String get shoppingListsScreenTitle;

  /// No description provided for @onboardingScanBody.
  ///
  /// In it, this message translates to:
  /// **'Usa la fotocamera per scansionare il codice a barre dei prodotti e aggiungerli al tuo carrello.'**
  String get onboardingScanBody;

  /// No description provided for @onboardingScanTitle.
  ///
  /// In it, this message translates to:
  /// **'Scansiona e Aggiungi'**
  String get onboardingScanTitle;

  /// No description provided for @onboardingTrackBody.
  ///
  /// In it, this message translates to:
  /// **'Salva i tuoi acquisti e consulta la cronologia per analizzare le tue spese.'**
  String get onboardingTrackBody;

  /// No description provided for @onboardingTrackTitle.
  ///
  /// In it, this message translates to:
  /// **'Tieni Tutto Sotto Controllo'**
  String get onboardingTrackTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In it, this message translates to:
  /// **'La tua app per tracciare gli acquisti senza glutine in modo semplice e veloce.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto in Glufri!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @account.
  ///
  /// In it, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In it, this message translates to:
  /// **'Hai già un account? Accedi'**
  String get alreadyHaveAccount;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In it, this message translates to:
  /// **'Hai già un account?'**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @backToLogin.
  ///
  /// In it, this message translates to:
  /// **'Torna al Login'**
  String get backToLogin;

  /// No description provided for @confirmPassword.
  ///
  /// In it, this message translates to:
  /// **'Conferma Password'**
  String get confirmPassword;

  /// No description provided for @email.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @forgotPassword.
  ///
  /// In it, this message translates to:
  /// **'Password dimenticata?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordInstruction.
  ///
  /// In it, this message translates to:
  /// **'Inserisci l\'email associata al tuo account. Ti invieremo un link per reimpostare la tua password.'**
  String get forgotPasswordInstruction;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun problema! Inserisci la tua email e ti aiuteremo.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In it, this message translates to:
  /// **'Password Dimenticata?'**
  String get forgotPasswordTitle;

  /// No description provided for @googleLoginFailed.
  ///
  /// In it, this message translates to:
  /// **'Login con Google fallito. Riprova.'**
  String get googleLoginFailed;

  /// No description provided for @invalidEmailError.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un\'email valida.'**
  String get invalidEmailError;

  /// No description provided for @loggedInAs.
  ///
  /// In it, this message translates to:
  /// **'Loggato come {email}'**
  String loggedInAs(String email);

  /// No description provided for @login.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get login;

  /// No description provided for @loginAction.
  ///
  /// In it, this message translates to:
  /// **'ACCEDI'**
  String get loginAction;

  /// No description provided for @loginError.
  ///
  /// In it, this message translates to:
  /// **'Email o password errati. Riprova.'**
  String get loginError;

  /// No description provided for @loginToSaveData.
  ///
  /// In it, this message translates to:
  /// **'Accedi per salvare i tuoi dati'**
  String get loginToSaveData;

  /// No description provided for @loginSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Accedi al tuo account per continuare.'**
  String get loginSubtitle;

  /// No description provided for @loginSuccess.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto/a!'**
  String get loginSuccess;

  /// No description provided for @loginWelcome.
  ///
  /// In it, this message translates to:
  /// **'Bentornato!'**
  String get loginWelcome;

  /// No description provided for @loginWithGoogle.
  ///
  /// In it, this message translates to:
  /// **'Accedi con Google'**
  String get loginWithGoogle;

  /// No description provided for @logoutSuccess.
  ///
  /// In it, this message translates to:
  /// **'Logout effettuato con successo.'**
  String get logoutSuccess;

  /// No description provided for @noAccount.
  ///
  /// In it, this message translates to:
  /// **'Non hai un account? Registrati'**
  String get noAccount;

  /// No description provided for @noAccountPrompt.
  ///
  /// In it, this message translates to:
  /// **'Non hai un account?'**
  String get noAccountPrompt;

  /// No description provided for @password.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordLengthError.
  ///
  /// In it, this message translates to:
  /// **'La password deve essere di almeno 6 caratteri.'**
  String get passwordLengthError;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In it, this message translates to:
  /// **'Le password non coincidono.'**
  String get passwordsDoNotMatchError;

  /// No description provided for @resetEmailError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante l\'invio dell\'email. L\'indirizzo potrebbe non essere valido.'**
  String get resetEmailError;

  /// No description provided for @resetEmailSuccess.
  ///
  /// In it, this message translates to:
  /// **'Email di recupero inviata con successo! Controlla la tua casella di posta.'**
  String get resetEmailSuccess;

  /// No description provided for @sendResetEmail.
  ///
  /// In it, this message translates to:
  /// **'INVIA EMAIL DI RECUPERO'**
  String get sendResetEmail;

  /// No description provided for @signup.
  ///
  /// In it, this message translates to:
  /// **'Registrati'**
  String get signup;

  /// No description provided for @signupAction.
  ///
  /// In it, this message translates to:
  /// **'REGISTRATI'**
  String get signupAction;

  /// No description provided for @signupError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante la registrazione. Riprova. (es. l\'email potrebbe essere già in uso)'**
  String get signupError;

  /// No description provided for @signupSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Crea un account per salvare i tuoi dati'**
  String get signupSubtitle;

  /// No description provided for @signupTitle.
  ///
  /// In it, this message translates to:
  /// **'Crea il tuo account'**
  String get signupTitle;

  /// No description provided for @user.
  ///
  /// In it, this message translates to:
  /// **'Utente'**
  String get user;

  /// No description provided for @userGuest.
  ///
  /// In it, this message translates to:
  /// **'Utente Ospite'**
  String get userGuest;

  /// No description provided for @addItem.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Prodotto'**
  String get addItem;

  /// No description provided for @addProductToStart.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un prodotto per iniziare.'**
  String get addProductToStart;

  /// No description provided for @andMoreProducts.
  ///
  /// In it, this message translates to:
  /// **'... e altri {count} prodotti.'**
  String andMoreProducts(int count);

  /// No description provided for @atStore.
  ///
  /// In it, this message translates to:
  /// **'presso'**
  String get atStore;

  /// No description provided for @barcodeOptional.
  ///
  /// In it, this message translates to:
  /// **'Codice a Barre (Opzionale)'**
  String get barcodeOptional;

  /// No description provided for @editProduct.
  ///
  /// In it, this message translates to:
  /// **'Modifica Prodotto'**
  String get editProduct;

  /// No description provided for @editPurchase.
  ///
  /// In it, this message translates to:
  /// **'Modifica Acquisto'**
  String get editPurchase;

  /// No description provided for @exportCsvPro.
  ///
  /// In it, this message translates to:
  /// **'Esporta CSV (Pro)'**
  String get exportCsvPro;

  /// No description provided for @exportPdfAnnualReport.
  ///
  /// In it, this message translates to:
  /// **'Esporta Report Annuale'**
  String get exportPdfAnnualReport;

  /// No description provided for @exportPdfCompleteReport.
  ///
  /// In it, this message translates to:
  /// **'Report Completo'**
  String get exportPdfCompleteReport;

  /// No description provided for @exportPdfMonthlyReport.
  ///
  /// In it, this message translates to:
  /// **'Esporta Report Mensile'**
  String get exportPdfMonthlyReport;

  /// No description provided for @exportPdfReportTooltip.
  ///
  /// In it, this message translates to:
  /// **'Esporta Report'**
  String get exportPdfReportTooltip;

  /// No description provided for @filterByDateTooltip.
  ///
  /// In it, this message translates to:
  /// **'Filtra per data'**
  String get filterByDateTooltip;

  /// No description provided for @foundProducts.
  ///
  /// In it, this message translates to:
  /// **'Prodotti trovati:'**
  String get foundProducts;

  /// No description provided for @genericPurchase.
  ///
  /// In it, this message translates to:
  /// **'Acquisto generico'**
  String get genericPurchase;

  /// No description provided for @glutenFree.
  ///
  /// In it, this message translates to:
  /// **'Senza Glutine'**
  String get glutenFree;

  /// No description provided for @glutenFreeProduct.
  ///
  /// In it, this message translates to:
  /// **'Prodotto Senza Glutine'**
  String get glutenFreeProduct;

  /// No description provided for @lastPrice.
  ///
  /// In it, this message translates to:
  /// **'Ultimo prezzo:'**
  String get lastPrice;

  /// No description provided for @mainProducts.
  ///
  /// In it, this message translates to:
  /// **'Prodotti principali:'**
  String get mainProducts;

  /// No description provided for @mustBeGreaterThanZero.
  ///
  /// In it, this message translates to:
  /// **'Deve essere > 0'**
  String get mustBeGreaterThanZero;

  /// No description provided for @newPurchase.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Acquisto'**
  String get newPurchase;

  /// No description provided for @noProductsFoundFor.
  ///
  /// In it, this message translates to:
  /// **'Nessun prodotto trovato per \"{query}\"'**
  String noProductsFoundFor(String query);

  /// No description provided for @noPurchases.
  ///
  /// In it, this message translates to:
  /// **'Nessun acquisto registrato.\nPremi \"+\" per iniziare!'**
  String get noPurchases;

  /// No description provided for @noStoreSpecified.
  ///
  /// In it, this message translates to:
  /// **'Nessun negozio specificato'**
  String get noStoreSpecified;

  /// No description provided for @other.
  ///
  /// In it, this message translates to:
  /// **'Altro'**
  String get other;

  /// No description provided for @pdfReportTitleAnnual.
  ///
  /// In it, this message translates to:
  /// **'Report Spese - {year}'**
  String pdfReportTitleAnnual(String year);

  /// No description provided for @pdfReportTitleComplete.
  ///
  /// In it, this message translates to:
  /// **'Report Spese Completo'**
  String get pdfReportTitleComplete;

  /// No description provided for @pdfReportTitleMonthly.
  ///
  /// In it, this message translates to:
  /// **'Report Spese - {date}'**
  String pdfReportTitleMonthly(String date);

  /// No description provided for @priceRange.
  ///
  /// In it, this message translates to:
  /// **'Prezzi: da {min}€ a {max}€'**
  String priceRange(Object max, Object min);

  /// No description provided for @productHistoryTitle.
  ///
  /// In it, this message translates to:
  /// **'Prodotto già acquistato!'**
  String get productHistoryTitle;

  /// No description provided for @productNameCannotBeEmpty.
  ///
  /// In it, this message translates to:
  /// **'Il nome non può essere vuoto'**
  String get productNameCannotBeEmpty;

  /// No description provided for @productNotFoundOrNetworkError.
  ///
  /// In it, this message translates to:
  /// **'Prodotto non trovato o errore di rete.'**
  String get productNotFoundOrNetworkError;

  /// Numero di prodotti in un acquisto
  ///
  /// In it, this message translates to:
  /// **'{count,plural, =0{Nessun prodotto} =1{1 prodotto} other{{count} prodotti}}'**
  String productsCount(int count);

  /// No description provided for @purchaseDetail.
  ///
  /// In it, this message translates to:
  /// **'Dettaglio Acquisto'**
  String get purchaseDetail;

  /// No description provided for @purchaseExport.
  ///
  /// In it, this message translates to:
  /// **'Esportazione Acquisto Glufri - {store}'**
  String purchaseExport(String store);

  /// No description provided for @purchaseMarkedForDeletion.
  ///
  /// In it, this message translates to:
  /// **'Acquisto eliminato.'**
  String get purchaseMarkedForDeletion;

  /// No description provided for @purchaseSavedSuccess.
  ///
  /// In it, this message translates to:
  /// **'Acquisto salvato con successo!'**
  String get purchaseSavedSuccess;

  /// No description provided for @purchasedXTimes.
  ///
  /// In it, this message translates to:
  /// **'{count,plural, =0{Mai acquistato} =1{Acquistato 1 volta} other{Acquistato {count} volte}}'**
  String purchasedXTimes(int count);

  /// No description provided for @removeDateFilterTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi filtro data'**
  String get removeDateFilterTooltip;

  /// No description provided for @savePurchase.
  ///
  /// In it, this message translates to:
  /// **'Salva Acquisto'**
  String get savePurchase;

  /// No description provided for @scanBarcode.
  ///
  /// In it, this message translates to:
  /// **'Scansiona Codice'**
  String get scanBarcode;

  /// No description provided for @searchPlaceholder.
  ///
  /// In it, this message translates to:
  /// **'Cerca per negozio o prodotto...'**
  String get searchPlaceholder;

  /// No description provided for @selectMonthOfYear.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un Mese del {year}'**
  String selectMonthOfYear(String year);

  /// No description provided for @shareSummary.
  ///
  /// In it, this message translates to:
  /// **'Condividi Riepilogo'**
  String get shareSummary;

  /// No description provided for @shareText.
  ///
  /// In it, this message translates to:
  /// **'Ecco il mio ultimo acquisto senza glutine tracciato con l\'app Glufri! 🛒'**
  String get shareText;

  /// No description provided for @storeHint.
  ///
  /// In it, this message translates to:
  /// **'Es. Supermercato Rossi'**
  String get storeHint;

  /// No description provided for @times.
  ///
  /// In it, this message translates to:
  /// **'volte'**
  String get times;

  /// No description provided for @totalGlutenFree.
  ///
  /// In it, this message translates to:
  /// **'Totale Senza Glutine'**
  String get totalGlutenFree;

  /// No description provided for @totalOther.
  ///
  /// In it, this message translates to:
  /// **'Totale Altro'**
  String get totalOther;

  /// No description provided for @totalOverall.
  ///
  /// In it, this message translates to:
  /// **'Totale Complessivo'**
  String get totalOverall;

  /// No description provided for @trackedWith.
  ///
  /// In it, this message translates to:
  /// **'Tracciato con Glufri App'**
  String get trackedWith;

  /// No description provided for @weightVolumePieces.
  ///
  /// In it, this message translates to:
  /// **'Peso / Volume / Pezzi'**
  String get weightVolumePieces;

  /// No description provided for @addFromFavorites.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi da Preferiti'**
  String get addFromFavorites;

  /// No description provided for @addItemToShoppingList.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Prodotto'**
  String get addItemToShoppingList;

  /// No description provided for @addItemTooltip.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi item'**
  String get addItemTooltip;

  /// No description provided for @addManual.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi manualmente'**
  String get addManual;

  /// No description provided for @checkedItems.
  ///
  /// In it, this message translates to:
  /// **'{checked}/{total} completati'**
  String checkedItems(String checked, String total);

  /// No description provided for @createNewListTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nuova Lista'**
  String get createNewListTooltip;

  /// No description provided for @createListDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Crea Nuova Lista'**
  String get createListDialogTitle;

  /// No description provided for @deleteListConfirmationBody.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare la lista \'{listName}\'?'**
  String deleteListConfirmationBody(String listName);

  /// No description provided for @deleteListConfirmationTitle.
  ///
  /// In it, this message translates to:
  /// **'Conferma Eliminazione'**
  String get deleteListConfirmationTitle;

  /// No description provided for @emptyShoppingList.
  ///
  /// In it, this message translates to:
  /// **'Nessuna lista della spesa.\nPremi \'+\' per crearne una.'**
  String get emptyShoppingList;

  /// No description provided for @itemAddedToList.
  ///
  /// In it, this message translates to:
  /// **'\'{itemName}\' aggiunto alla lista.'**
  String itemAddedToList(String itemName);

  /// No description provided for @listName.
  ///
  /// In it, this message translates to:
  /// **'Nome della lista'**
  String get listName;

  /// No description provided for @listNameEmptyError.
  ///
  /// In it, this message translates to:
  /// **'Il nome non può essere vuoto.'**
  String get listNameEmptyError;

  /// No description provided for @noItemsInShoppingList.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi o de-seleziona almeno un item per iniziare.'**
  String get noItemsInShoppingList;

  /// No description provided for @startPurchaseFromList.
  ///
  /// In it, this message translates to:
  /// **'Inizia Acquisto dalla Lista'**
  String get startPurchaseFromList;

  /// No description provided for @addEditFavoriteDialogAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Preferito'**
  String get addEditFavoriteDialogAdd;

  /// No description provided for @addEditFavoriteDialogEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica Preferito'**
  String get addEditFavoriteDialogEdit;

  /// No description provided for @addFavoriteProduct.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Preferito'**
  String get addFavoriteProduct;

  /// No description provided for @addFromFavoritesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi da Preferiti'**
  String get addFromFavoritesTooltip;

  /// No description provided for @addToFavorites.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi ai prodotti preferiti'**
  String get addToFavorites;

  /// No description provided for @defaultPrice.
  ///
  /// In it, this message translates to:
  /// **'Prezzo di Default (Opzionale)'**
  String get defaultPrice;

  /// No description provided for @deleteFavoriteConfirmationBody.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare \'{productName}\' dai preferiti?'**
  String deleteFavoriteConfirmationBody(String productName);

  /// No description provided for @favoriteProductRemoved.
  ///
  /// In it, this message translates to:
  /// **'\'{productName}\' rimosso dai preferiti.'**
  String favoriteProductRemoved(Object productName);

  /// No description provided for @noFavoriteProducts.
  ///
  /// In it, this message translates to:
  /// **'Non hai ancora prodotti preferiti.\nSalvali da un acquisto per trovarli qui.'**
  String get noFavoriteProducts;

  /// No description provided for @noFavoritesAvailable.
  ///
  /// In it, this message translates to:
  /// **'Non hai prodotti preferiti.'**
  String get noFavoritesAvailable;

  /// No description provided for @selectFavorite.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un Preferito'**
  String get selectFavorite;

  /// No description provided for @settingsFavProducts.
  ///
  /// In it, this message translates to:
  /// **'Prodotti Preferiti'**
  String get settingsFavProducts;

  /// No description provided for @budgetSaved.
  ///
  /// In it, this message translates to:
  /// **'Budget salvato!'**
  String get budgetSaved;

  /// No description provided for @budgetSetGlutenFree.
  ///
  /// In it, this message translates to:
  /// **'Budget Senza Glutine'**
  String get budgetSetGlutenFree;

  /// No description provided for @budgetSetTotal.
  ///
  /// In it, this message translates to:
  /// **'Budget Totale'**
  String get budgetSetTotal;

  /// No description provided for @budgetTitle.
  ///
  /// In it, this message translates to:
  /// **'Budget di {monthYear}'**
  String budgetTitle(String monthYear);

  /// No description provided for @budgetTrend.
  ///
  /// In it, this message translates to:
  /// **'Andamento Spesa'**
  String get budgetTrend;

  /// No description provided for @remainingBudget.
  ///
  /// In it, this message translates to:
  /// **'Residuo Budget'**
  String get remainingBudget;

  /// No description provided for @saveBudget.
  ///
  /// In it, this message translates to:
  /// **'Salva Budget'**
  String get saveBudget;

  /// No description provided for @setBudget.
  ///
  /// In it, this message translates to:
  /// **'Imposta Budget'**
  String get setBudget;

  /// No description provided for @dark.
  ///
  /// In it, this message translates to:
  /// **'Scuro'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @light.
  ///
  /// In it, this message translates to:
  /// **'Chiaro'**
  String get light;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In it, this message translates to:
  /// **'La tua privacy è importante...\n[INSERIRE QUI IL TESTO COMPLETO DELLA PRIVACY POLICY]\n\nDati Raccolti: L\'app salva i dati degli acquisti esclusivamente sul tuo dispositivo. Se scegli di utilizzare la funzione di backup cloud (funzionalità Pro), i tuoi dati verranno criptati e salvati sui server sicuri di Google Firebase.\n\nCondivisione Dati: Nessun dato personale o di acquisto viene condiviso con terze parti.\n...'**
  String get privacyPolicyBody;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In it, this message translates to:
  /// **'Informativa Privacy'**
  String get privacyPolicyTitle;

  /// No description provided for @settingsAccountAndBackup.
  ///
  /// In it, this message translates to:
  /// **'Account e Backup (Pro)'**
  String get settingsAccountAndBackup;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In it, this message translates to:
  /// **'Sistema'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLoginForBackup.
  ///
  /// In it, this message translates to:
  /// **'Accedi con Google per abilitare il backup'**
  String get settingsLoginForBackup;

  /// No description provided for @settingsLoginFailed.
  ///
  /// In it, this message translates to:
  /// **'Login fallito. Riprova.'**
  String get settingsLoginFailed;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In it, this message translates to:
  /// **'Informativa Privacy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @system.
  ///
  /// In it, this message translates to:
  /// **'Sistema'**
  String get system;

  /// No description provided for @theme.
  ///
  /// In it, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @proRequiredForHistory.
  ///
  /// In it, this message translates to:
  /// **'Passa a Pro per vedere la cronologia prezzi!'**
  String get proRequiredForHistory;

  /// No description provided for @unlockPro.
  ///
  /// In it, this message translates to:
  /// **'SCOPRI'**
  String get unlockPro;

  /// No description provided for @upsellAction.
  ///
  /// In it, this message translates to:
  /// **'Abbonati Ora (Prezzo Annuo)'**
  String get upsellAction;

  /// No description provided for @upsellFeature1.
  ///
  /// In it, this message translates to:
  /// **'Backup e Sync Multi-dispositivo'**
  String get upsellFeature1;

  /// No description provided for @upsellFeature2.
  ///
  /// In it, this message translates to:
  /// **'Esportazioni illimitate in CSV'**
  String get upsellFeature2;

  /// No description provided for @upsellFeature3.
  ///
  /// In it, this message translates to:
  /// **'Esperienza senza pubblicità'**
  String get upsellFeature3;

  /// No description provided for @upsellFeature4.
  ///
  /// In it, this message translates to:
  /// **'Supporto Prioritario'**
  String get upsellFeature4;

  /// No description provided for @upsellHeadline.
  ///
  /// In it, this message translates to:
  /// **'Sblocca il Pieno Potenziale!'**
  String get upsellHeadline;

  /// No description provided for @upsellRestore.
  ///
  /// In it, this message translates to:
  /// **'Ripristina Acquisti'**
  String get upsellRestore;

  /// No description provided for @upsellTitle.
  ///
  /// In it, this message translates to:
  /// **'Passa a Glufri Pro'**
  String get upsellTitle;

  /// No description provided for @backupError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante il backup.'**
  String get backupError;

  /// No description provided for @backupInProgress.
  ///
  /// In it, this message translates to:
  /// **'Backup in corso...'**
  String get backupInProgress;

  /// No description provided for @backupSuccess.
  ///
  /// In it, this message translates to:
  /// **'Backup completato con successo!'**
  String get backupSuccess;

  /// No description provided for @migrationDeleted.
  ///
  /// In it, this message translates to:
  /// **'Dati locali eliminati con successo.'**
  String get migrationDeleted;

  /// No description provided for @migrationDialogActionDelete.
  ///
  /// In it, this message translates to:
  /// **'ELIMINA'**
  String get migrationDialogActionDelete;

  /// No description provided for @migrationDialogActionIgnore.
  ///
  /// In it, this message translates to:
  /// **'NO, LASCIA'**
  String get migrationDialogActionIgnore;

  /// No description provided for @migrationDialogActionMerge.
  ///
  /// In it, this message translates to:
  /// **'SÌ, UNISCI'**
  String get migrationDialogActionMerge;

  /// No description provided for @migrationDialogBody.
  ///
  /// In it, this message translates to:
  /// **'Hai {count} acquisti salvati su questo dispositivo. Cosa vuoi fare?'**
  String migrationDialogBody(int count);

  /// No description provided for @migrationDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Acquisti Locali Rilevati'**
  String get migrationDialogTitle;

  /// No description provided for @migrationSuccess.
  ///
  /// In it, this message translates to:
  /// **'Acquisti locali uniti al tuo account!'**
  String get migrationSuccess;

  /// No description provided for @restoreConfirmationBody.
  ///
  /// In it, this message translates to:
  /// **'Questo sovrascriverà tutti i dati locali con quelli salvati nel cloud. Continuare?'**
  String get restoreConfirmationBody;

  /// No description provided for @restoreConfirmationTitle.
  ///
  /// In it, this message translates to:
  /// **'Conferma Ripristino'**
  String get restoreConfirmationTitle;

  /// No description provided for @restoreError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante il ripristino.'**
  String get restoreError;

  /// No description provided for @restoreInProgress.
  ///
  /// In it, this message translates to:
  /// **'Ripristino in corso...'**
  String get restoreInProgress;

  /// No description provided for @restoreSuccess.
  ///
  /// In it, this message translates to:
  /// **'Dati ripristinati con successo!'**
  String get restoreSuccess;

  /// No description provided for @settingsAuthError.
  ///
  /// In it, this message translates to:
  /// **'Errore di autenticazione'**
  String get settingsAuthError;

  /// No description provided for @settingsBackupNow.
  ///
  /// In it, this message translates to:
  /// **'Esegui Backup'**
  String get settingsBackupNow;

  /// No description provided for @settingsLogout.
  ///
  /// In it, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @settingsRestoreFromCloud.
  ///
  /// In it, this message translates to:
  /// **'Ripristina da Cloud'**
  String get settingsRestoreFromCloud;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare questo acquisto? L\'azione è irreversibile.'**
  String get deleteConfirmationMessage;

  /// No description provided for @deleteConfirmationTitle.
  ///
  /// In it, this message translates to:
  /// **'Conferma Eliminazione'**
  String get deleteConfirmationTitle;

  /// No description provided for @exportError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante l\'esportazione.'**
  String get exportError;

  /// No description provided for @genericError.
  ///
  /// In it, this message translates to:
  /// **'Si è verificato un errore:\n{error}'**
  String genericError(Object error);

  /// No description provided for @invalidValue.
  ///
  /// In it, this message translates to:
  /// **'Valore non valido'**
  String get invalidValue;

  /// No description provided for @listNotFound.
  ///
  /// In it, this message translates to:
  /// **'Lista non trovata o eliminata.'**
  String get listNotFound;

  /// No description provided for @optionalDetails.
  ///
  /// In it, this message translates to:
  /// **'Dettagli opzionali'**
  String get optionalDetails;

  /// No description provided for @pdfCreationError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante la creazione del PDF.'**
  String get pdfCreationError;

  /// No description provided for @purchaseDeletedSuccess.
  ///
  /// In it, this message translates to:
  /// **'Acquisto eliminato con successo.'**
  String get purchaseDeletedSuccess;

  /// No description provided for @requiredField.
  ///
  /// In it, this message translates to:
  /// **'Campo obbligatorio'**
  String get requiredField;

  /// No description provided for @shareError.
  ///
  /// In it, this message translates to:
  /// **'Errore durante la condivisione.'**
  String get shareError;

  /// No description provided for @shoppingListError.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle liste.'**
  String get shoppingListError;

  /// No description provided for @syncError.
  ///
  /// In it, this message translates to:
  /// **'Errore di sincronizzazione.'**
  String get syncError;

  /// No description provided for @upsellSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Prendi il controllo totale della tua spesa senza glutine.'**
  String get upsellSubtitle;

  /// No description provided for @proFeatureTitleBackup.
  ///
  /// In it, this message translates to:
  /// **'Backup & Sync Multi-dispositivo'**
  String get proFeatureTitleBackup;

  /// No description provided for @proFeatureBodyBackup.
  ///
  /// In it, this message translates to:
  /// **'I tuoi dati sono preziosi. Salva ogni acquisto in modo sicuro nel cloud. Cambia telefono o usa un tablet? Ritrova tutti i tuoi dati, liste e preferiti sincronizzati istantaneamente. Massima sicurezza, zero pensieri.'**
  String get proFeatureBodyBackup;

  /// No description provided for @proFeatureTitleLists.
  ///
  /// In it, this message translates to:
  /// **'Liste della Spesa Intelligenti'**
  String get proFeatureTitleLists;

  /// No description provided for @proFeatureBodyLists.
  ///
  /// In it, this message translates to:
  /// **'La pianificazione è tutto. Crea liste della spesa illimitate, aggiungi prodotti dai tuoi preferiti con un tocco e, una volta al supermercato, trasforma la lista in un nuovo acquisto con un solo pulsante. Mai più foglietti di carta o app separate.'**
  String get proFeatureBodyLists;

  /// No description provided for @proFeatureTitleFavorites.
  ///
  /// In it, this message translates to:
  /// **'Prodotti Preferiti Illimitati'**
  String get proFeatureTitleFavorites;

  /// No description provided for @proFeatureBodyFavorites.
  ///
  /// In it, this message translates to:
  /// **'Risparmia tempo ad ogni spesa. Salva i prodotti che acquisti più spesso come preferiti, imposta un prezzo di default e aggiungili alle tue liste o ai tuoi acquisti futuri in un lampo. Il tuo supermercato personale, sempre in tasca.'**
  String get proFeatureBodyFavorites;

  /// No description provided for @proFeatureTitleBudget.
  ///
  /// In it, this message translates to:
  /// **'Controllo del Budget Mensile'**
  String get proFeatureTitleBudget;

  /// No description provided for @proFeatureBodyBudget.
  ///
  /// In it, this message translates to:
  /// **'Quanto spendi realmente per il senza glutine? Imposta budget mensili totali e specifici per il gluten-free. Tieni traccia delle tue uscite in tempo reale e guarda il tuo budget rimanente mentre aggiungi prodotti al carrello. Niente più sorprese a fine mese.'**
  String get proFeatureBodyBudget;

  /// No description provided for @proFeatureTitleDetails.
  ///
  /// In it, this message translates to:
  /// **'Dettagli Prodotto Approfonditi (con OFF)'**
  String get proFeatureTitleDetails;

  /// No description provided for @proFeatureBodyDetails.
  ///
  /// In it, this message translates to:
  /// **'Fai scelte più consapevoli. Scansiona un codice a barre e scopri subito ingredienti, allergeni, il Nutri-Score e il grado di processazione (NOVA). Glufri diventa il tuo assistente per una spesa non solo senza glutine, ma anche più sana.'**
  String get proFeatureBodyDetails;

  /// No description provided for @proFeatureTitleHistory.
  ///
  /// In it, this message translates to:
  /// **'Cronologia Prezzi'**
  String get proFeatureTitleHistory;

  /// No description provided for @proFeatureBodyHistory.
  ///
  /// In it, this message translates to:
  /// **'Stai pagando il prezzo giusto? Quando scansioni un prodotto che hai già acquistato, Glufri Pro ti mostra istantaneamente l\'ultimo prezzo pagato e ti avverte se stai spendendo di più. Fai la spesa come un professionista.'**
  String get proFeatureBodyHistory;

  /// No description provided for @proFeatureTitleExport.
  ///
  /// In it, this message translates to:
  /// **'Esportazioni Illimitate (PDF & CSV)'**
  String get proFeatureTitleExport;

  /// No description provided for @proFeatureBodyExport.
  ///
  /// In it, this message translates to:
  /// **'I tuoi dati, le tue regole. Genera report mensili o annuali in PDF, perfetti per analisi personali o per detrazioni fiscali. Esporta i singoli acquisti in formato CSV per un\'analisi approfondita con fogli di calcolo. Pieno controllo sui tuoi dati di spesa.'**
  String get proFeatureBodyExport;

  /// No description provided for @proFeatureTitleNoAds.
  ///
  /// In it, this message translates to:
  /// **'Esperienza Senza Interruzioni'**
  String get proFeatureTitleNoAds;

  /// No description provided for @proFeatureBodyNoAds.
  ///
  /// In it, this message translates to:
  /// **'Concentrati solo sulla tua spesa. La versione Pro rimuove ogni pubblicità, offrendoti un\'esperienza più pulita, veloce e senza distrazioni.'**
  String get proFeatureBodyNoAds;

  /// No description provided for @comparisonTitle.
  ///
  /// In it, this message translates to:
  /// **'Confronta i Piani'**
  String get comparisonTitle;

  /// No description provided for @featureHeader.
  ///
  /// In it, this message translates to:
  /// **'Funzionalità'**
  String get featureHeader;

  /// No description provided for @freeHeader.
  ///
  /// In it, this message translates to:
  /// **'Free'**
  String get freeHeader;

  /// No description provided for @proHeader.
  ///
  /// In it, this message translates to:
  /// **'PRO'**
  String get proHeader;
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
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
