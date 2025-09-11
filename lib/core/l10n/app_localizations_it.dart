// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Glufri';

  @override
  String get cancel => 'Annulla';

  @override
  String get close => 'Chiudi';

  @override
  String get continueAction => 'CONTINUA';

  @override
  String get delete => 'Elimina';

  @override
  String get duplicate => 'Duplica';

  @override
  String get edit => 'Modifica';

  @override
  String get or => 'oppure';

  @override
  String get price => 'Prezzo';

  @override
  String get productName => 'Nome Prodotto';

  @override
  String get quantity => 'Quantità';

  @override
  String get save => 'Salva';

  @override
  String get skip => 'Salta';

  @override
  String get start => 'Inizia';

  @override
  String get store => 'Negozio';

  @override
  String get total => 'Totale';

  @override
  String get undoAction => 'ANNULLA';

  @override
  String get update => 'Aggiorna';

  @override
  String get favoriteProducts => 'Prodotti Preferiti';

  @override
  String get forgotPasswordScreenTitle => 'Recupera Password';

  @override
  String get monthlyBudget => 'Budget Mensile';

  @override
  String get purchaseHistory => 'Cronologia Acquisti';

  @override
  String get scanBarcodeTitle => 'Scansiona EAN-13';

  @override
  String get settings => 'Impostazioni';

  @override
  String get shoppingLists => 'Liste della Spesa';

  @override
  String get shoppingListsScreenTitle => 'Liste della Spesa';

  @override
  String get onboardingScanBody =>
      'Usa la fotocamera per scansionare il codice a barre dei prodotti e aggiungerli al tuo carrello.';

  @override
  String get onboardingScanTitle => 'Scansiona e Aggiungi';

  @override
  String get onboardingTrackBody =>
      'Salva i tuoi acquisti e consulta la cronologia per analizzare le tue spese.';

  @override
  String get onboardingTrackTitle => 'Tieni Tutto Sotto Controllo';

  @override
  String get onboardingWelcomeBody =>
      'La tua app per tracciare gli acquisti senza glutine in modo semplice e veloce.';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto in Glufri!';

  @override
  String get account => 'Account';

  @override
  String get alreadyHaveAccount => 'Hai già un account? Accedi';

  @override
  String get alreadyHaveAccountPrompt => 'Hai già un account?';

  @override
  String get backToLogin => 'Torna al Login';

  @override
  String get confirmPassword => 'Conferma Password';

  @override
  String get email => 'Email';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get forgotPasswordInstruction =>
      'Inserisci l\'email associata al tuo account. Ti invieremo un link per reimpostare la tua password.';

  @override
  String get forgotPasswordScreenSubtitle =>
      'Nessun problema! Inserisci la tua email e ti aiuteremo.';

  @override
  String get forgotPasswordTitle => 'Password Dimenticata?';

  @override
  String get invalidEmailError => 'Inserisci un\'email valida.';

  @override
  String loggedInAs(String email) {
    return 'Loggato come $email';
  }

  @override
  String get login => 'Accedi';

  @override
  String get loginAction => 'ACCEDI';

  @override
  String get loginError => 'Email o password errati. Riprova.';

  @override
  String get loginInToSaveData => 'Accedi per salvare i tuoi dati';

  @override
  String get loginSubtitle => 'Accedi al tuo account per continuare.';

  @override
  String get loginSuccess => 'Benvenuto/a!';

  @override
  String get loginWelcome => 'Bentornato!';

  @override
  String get loginWithGoogle => 'Accedi con Google';

  @override
  String get logoutSuccess => 'Logout effettuato con successo.';

  @override
  String get noAccount => 'Non hai un account? Registrati';

  @override
  String get noAccountPrompt => 'Non hai un account?';

  @override
  String get password => 'Password';

  @override
  String get passwordLengthError =>
      'La password deve essere di almeno 6 caratteri.';

  @override
  String get passwordsDoNotMatchError => 'Le password non coincidono.';

  @override
  String get sendResetEmail => 'INVIA EMAIL DI RECUPERO';

  @override
  String get signup => 'Registrati';

  @override
  String get signupAction => 'REGISTRATI';

  @override
  String get signupError =>
      'Errore durante la registrazione. Riprova. (es. l\'email potrebbe essere già in uso)';

  @override
  String get signupSubtitle => 'Crea un account per salvare i tuoi dati';

  @override
  String get signupTitle => 'Crea il tuo account';

  @override
  String get user => 'Utente';

  @override
  String get userGuest => 'Utente Ospite';

  @override
  String get addProductToStart => 'Aggiungi un prodotto per iniziare.';

  @override
  String get addItem => 'Aggiungi Prodotto';

  @override
  String andMoreProducts(int count) {
    return '... e altri $count prodotti.';
  }

  @override
  String get atStore => 'presso';

  @override
  String get barcodeOptional => 'Codice a Barre (Opzionale)';

  @override
  String get editProduct => 'Modifica Prodotto';

  @override
  String get editPurchase => 'Modifica Acquisto';

  @override
  String get exportCsvPro => 'Esporta CSV (Pro)';

  @override
  String get exportPdfAnnualReport => 'Esporta Report Annuale';

  @override
  String get exportPdfCompleteReport => 'Report Completo';

  @override
  String get exportPdfMonthlyReport => 'Esporta Report Mensile';

  @override
  String get exportPdfReportTooltip => 'Esporta Report';

  @override
  String get filterByDateTooltip => 'Filtra per data';

  @override
  String get foundProducts => 'Prodotti trovati:';

  @override
  String get genericPurchase => 'Acquisto generico';

  @override
  String get glutenFree => 'Senza Glutine';

  @override
  String get glutenFreeProduct => 'Prodotto Senza Glutine';

  @override
  String get lastPrice => 'Ultimo prezzo:';

  @override
  String get mainProducts => 'Prodotti principali:';

  @override
  String get mustBeGreaterThanZero => 'Deve essere > 0';

  @override
  String get newPurchase => 'Nuovo Acquisto';

  @override
  String noProductsFoundFor(String query) {
    return 'Nessun prodotto trovato per \"$query\"';
  }

  @override
  String get noPurchases =>
      'Nessun acquisto registrato.\nPremi \"+\" per iniziare!';

  @override
  String get noStoreSpecified => 'Nessun negozio specificato';

  @override
  String get other => 'Altro';

  @override
  String priceRange(Object max, Object min) {
    return 'Prezzi: da $min€ a $max€';
  }

  @override
  String get productHistoryTitle => 'Prodotto già acquistato!';

  @override
  String get productNameCannotBeEmpty => 'Il nome non può essere vuoto';

  @override
  String get productNotFoundOrNetworkError =>
      'Prodotto non trovato o errore di rete.';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prodotti',
      one: '1 prodotto',
      zero: 'Nessun prodotto',
    );
    return '$_temp0';
  }

  @override
  String get purchaseDetail => 'Dettaglio Acquisto';

  @override
  String purchaseExport(String store) {
    return 'Esportazione Acquisto Glufri - $store';
  }

  @override
  String get purchaseMarkedForDeletion => 'Acquisto eliminato.';

  @override
  String get purchaseSavedSuccess => 'Acquisto salvato con successo!';

  @override
  String purchasedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Acquistato $count volte',
      one: 'Acquistato 1 volta',
      zero: 'Mai acquistato',
    );
    return '$_temp0';
  }

  @override
  String get removeDateFilterTooltip => 'Rimuovi filtro data';

  @override
  String get savePurchase => 'Salva Acquisto';

  @override
  String get scanBarcode => 'Scansiona Codice';

  @override
  String get searchPlaceholder => 'Cerca per negozio o prodotto...';

  @override
  String get shareSummary => 'Condividi Riepilogo';

  @override
  String get shareText =>
      'Ecco il mio ultimo acquisto senza glutine tracciato con l\'app Glufri! 🛒';

  @override
  String get storeHint => 'Es. Supermercato Rossi';

  @override
  String get times => 'volte';

  @override
  String get totalGlutenFree => 'Totale Senza Glutine';

  @override
  String get totalOther => 'Totale Altro';

  @override
  String get totalOverall => 'Totale Complessivo';

  @override
  String get trackedWith => 'Tracciato con Glufri App';

  @override
  String get addFromFavorites => 'Aggiungi da Preferiti';

  @override
  String get addItemToShoppingList => 'Aggiungi Prodotto';

  @override
  String get addManual => 'Aggiungi manualmente';

  @override
  String checkedItems(Object checked, Object total) {
    return '$checked/$total completati';
  }

  @override
  String get create => 'Crea';

  @override
  String get createListDialogTitle => 'Crea Nuova Lista';

  @override
  String deleteListConfirmationBody(Object listName) {
    return 'Sei sicuro di voler eliminare la lista \'$listName\'?';
  }

  @override
  String get deleteListConfirmationTitle => 'Conferma Eliminazione';

  @override
  String get emptyShoppingList =>
      'Nessuna lista della spesa.\nPremi \'+\' per crearne una.';

  @override
  String get listName => 'Nome della lista';

  @override
  String get listNameEmptyError => 'Il nome non può essere vuoto.';

  @override
  String get noItemsInShoppingList =>
      'Aggiungi o de-seleziona almeno un item per iniziare.';

  @override
  String get startPurchaseFromList => 'Inizia Acquisto dalla Lista';

  @override
  String get addEditFavoriteDialogAdd => 'Aggiungi Preferito';

  @override
  String get addEditFavoriteDialogEdit => 'Modifica Preferito';

  @override
  String get addFavoriteProduct => 'Aggiungi Preferito';

  @override
  String get addFromFavoritesTooltip => 'Aggiungi da Preferiti';

  @override
  String get addToFavorites => 'Aggiungi ai prodotti preferiti';

  @override
  String get defaultPrice => 'Prezzo di Default (Opzionale)';

  @override
  String deleteFavoriteConfirmationBody(String productName) {
    return 'Sei sicuro di voler eliminare \'$productName\' dai preferiti?';
  }

  @override
  String favoriteProductRemoved(Object productName) {
    return '\'$productName\' rimosso dai preferiti.';
  }

  @override
  String get noFavoriteProducts =>
      'Non hai ancora prodotti preferiti.\nSalvali da un acquisto per trovarli qui.';

  @override
  String get noFavoritesAvailable => 'Non hai prodotti preferiti.';

  @override
  String get selectFavorite => 'Seleziona un Preferito';

  @override
  String get settingsFavProducts => 'Prodotti Preferiti';

  @override
  String get budgetSetGlutenFree => 'Budget Senza Glutine';

  @override
  String get budgetSetTotal => 'Budget Totale';

  @override
  String budgetTitle(Object monthYear) {
    return 'Budget di $monthYear';
  }

  @override
  String get budgetTrend => 'Andamento Spesa';

  @override
  String get remainingBudget => 'Residuo Budget';

  @override
  String get saveBudget => 'Salva Budget';

  @override
  String get setBudget => 'Imposta Budget';

  @override
  String get dark => 'Scuro';

  @override
  String get language => 'Lingua';

  @override
  String get light => 'Chiaro';

  @override
  String get privacyPolicyBody =>
      'La tua privacy è importante...\n[INSERIRE QUI IL TESTO COMPLETO DELLA PRIVACY POLICY]\n\nDati Raccolti: L\'app salva i dati degli acquisti esclusivamente sul tuo dispositivo. Se scegli di utilizzare la funzione di backup cloud (funzionalità Pro), i tuoi dati verranno criptati e salvati sui server sicuri di Google Firebase.\n\nCondivisione Dati: Nessun dato personale o di acquisto viene condiviso con terze parti.\n...';

  @override
  String get privacyPolicyTitle => 'Informativa Privacy';

  @override
  String get settingsAccountAndBackup => 'Account e Backup (Pro)';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsLoginForBackup =>
      'Accedi con Google per abilitare il backup';

  @override
  String get settingsLoginFailed => 'Login fallito. Riprova.';

  @override
  String get settingsPrivacyPolicy => 'Informativa Privacy';

  @override
  String get system => 'Sistema';

  @override
  String get theme => 'Tema';

  @override
  String get proRequiredForHistory =>
      'Passa a Pro per vedere la cronologia prezzi!';

  @override
  String get unlockPro => 'SCOPRI';

  @override
  String get upsellAction => 'Abbonati Ora (Prezzo Annuo)';

  @override
  String get upsellFeature1 => 'Backup e Sync Multi-dispositivo';

  @override
  String get upsellFeature2 => 'Esportazioni illimitate in CSV';

  @override
  String get upsellFeature3 => 'Esperienza senza pubblicità';

  @override
  String get upsellFeature4 => 'Supporto Prioritario';

  @override
  String get upsellHeadline => 'Sblocca Funzionalità Potenti!';

  @override
  String get upsellRestore => 'Ripristina Acquisti';

  @override
  String get upsellTitle => 'Passa a Glufri Pro';

  @override
  String get backupError => 'Errore durante il backup.';

  @override
  String get backupInProgress => 'Backup in corso...';

  @override
  String get backupSuccess => 'Backup completato con successo!';

  @override
  String get migrationDeleted => 'Dati locali eliminati con successo.';

  @override
  String get migrationDialogActionDelete => 'ELIMINA';

  @override
  String get migrationDialogActionIgnore => 'NO, LASCIA';

  @override
  String get migrationDialogActionMerge => 'SÌ, UNISCI';

  @override
  String migrationDialogBody(int count) {
    return 'Hai $count acquisti salvati su questo dispositivo. Cosa vuoi fare?';
  }

  @override
  String get migrationDialogTitle => 'Acquisti Locali Rilevati';

  @override
  String get migrationSuccess => 'Acquisti locali uniti al tuo account!';

  @override
  String get resetEmailError =>
      'Errore durante l\'invio dell\'email. L\'indirizzo potrebbe non essere valido.';

  @override
  String get resetEmailSuccess =>
      'Email di recupero inviata con successo! Controlla la tua casella di posta.';

  @override
  String get restoreConfirmationBody =>
      'Questo sovrascriverà tutti i dati locali con quelli salvati nel cloud. Continuare?';

  @override
  String get restoreConfirmationTitle => 'Conferma Ripristino';

  @override
  String get restoreError => 'Errore durante il ripristino.';

  @override
  String get restoreInProgress => 'Ripristino in corso...';

  @override
  String get restoreSuccess => 'Dati ripristinati con successo!';

  @override
  String get settingsAuthError => 'Errore di autenticazione';

  @override
  String get settingsBackupNow => 'Esegui Backup';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get settingsRestoreFromCloud => 'Ripristina da Cloud';

  @override
  String get budgetSaved => 'Budget salvato!';

  @override
  String get deleteConfirmationMessage =>
      'Sei sicuro di voler eliminare questo acquisto? L\'azione è irreversibile.';

  @override
  String get deleteConfirmationTitle => 'Conferma Eliminazione';

  @override
  String get exportError => 'Errore durante l\'esportazione.';

  @override
  String get pdfCreationError => 'Errore durante la creazione del PDF.';

  @override
  String genericError(Object error) {
    return 'Si è verificato un errore:\n$error';
  }

  @override
  String get invalidValue => 'Valore non valido';

  @override
  String get purchaseDeletedSuccess => 'Acquisto eliminato con successo.';

  @override
  String get requiredField => 'Campo obbligatorio';

  @override
  String get shareError => 'Errore durante la condivisione.';

  @override
  String get syncError => 'Errore di sincronizzazione.';
}
