// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Glufri';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get continueAction => 'WEITER';

  @override
  String get delete => 'Löschen';

  @override
  String get duplicate => 'Duplizieren';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get or => 'oder';

  @override
  String get price => 'Preis';

  @override
  String get productName => 'Produktname';

  @override
  String get quantity => 'Menge';

  @override
  String get save => 'Speichern';

  @override
  String get skip => 'Überspringen';

  @override
  String get start => 'Starten';

  @override
  String get store => 'Geschäft';

  @override
  String get total => 'Gesamt';

  @override
  String get undoAction => 'RÜCKGÄNGIG';

  @override
  String get update => 'Aktualisieren';

  @override
  String get favoriteProducts => 'Lieblingsprodukte';

  @override
  String get forgotPasswordScreenTitle => 'Passwort wiederherstellen';

  @override
  String get monthlyBudget => 'Monatliches Budget';

  @override
  String get purchaseHistory => 'Einkaufsverlauf';

  @override
  String get scanBarcodeTitle => 'EAN-13 scannen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get shoppingLists => 'Einkaufslisten';

  @override
  String get shoppingListsScreenTitle => 'Einkaufslisten';

  @override
  String get onboardingScanBody =>
      'Verwende die Kamera, um Produkt-Barcodes zu scannen und sie deinem Einkaufswagen hinzuzufügen.';

  @override
  String get onboardingScanTitle => 'Scannen und Hinzufügen';

  @override
  String get onboardingTrackBody =>
      'Speichere deine Einkäufe und sieh dir den Verlauf an, um deine Ausgaben zu analysieren.';

  @override
  String get onboardingTrackTitle => 'Behalte alles unter Kontrolle';

  @override
  String get onboardingWelcomeBody =>
      'Deine App, um glutenfreie Einkäufe einfach und schnell zu verfolgen.';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Glufri!';

  @override
  String get account => 'Konto';

  @override
  String get alreadyHaveAccount => 'Du hast bereits ein Konto? Anmelden';

  @override
  String get alreadyHaveAccountPrompt => 'Du hast bereits ein Konto?';

  @override
  String get backToLogin => 'Zurück zur Anmeldung';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get email => 'E-Mail';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get forgotPasswordInstruction =>
      'Gib die mit deinem Konto verknüpfte E-Mail-Adresse ein. Wir senden dir einen Link zum Zurücksetzen deines Passworts.';

  @override
  String get forgotPasswordScreenSubtitle =>
      'Kein Problem! Gib deine E-Mail-Adresse ein und wir helfen dir weiter.';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen?';

  @override
  String get invalidEmailError => 'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String loggedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get login => 'Anmelden';

  @override
  String get loginAction => 'ANMELDEN';

  @override
  String get loginError =>
      'Ungültige E-Mail oder ungültiges Passwort. Bitte versuche es erneut.';

  @override
  String get loginInToSaveData => 'Melde dich an, um deine Daten zu speichern';

  @override
  String get loginSubtitle =>
      'Melde dich bei deinem Konto an, um fortzufahren.';

  @override
  String get loginSuccess => 'Willkommen!';

  @override
  String get loginWelcome => 'Willkommen zurück!';

  @override
  String get loginWithGoogle => 'Mit Google anmelden';

  @override
  String get logoutSuccess => 'Erfolgreich abgemeldet.';

  @override
  String get noAccount => 'Du hast kein Konto? Registrieren';

  @override
  String get noAccountPrompt => 'Du hast kein Konto?';

  @override
  String get password => 'Passwort';

  @override
  String get passwordLengthError =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get passwordsDoNotMatchError =>
      'Die Passwörter stimmen nicht überein.';

  @override
  String get sendResetEmail => 'WIEDERHERSTELLUNGS-E-MAIL SENDEN';

  @override
  String get signup => 'Registrieren';

  @override
  String get signupAction => 'REGISTRIEREN';

  @override
  String get signupError =>
      'Fehler bei der Registrierung. Bitte versuche es erneut. (z. B. die E-Mail-Adresse wird bereits verwendet)';

  @override
  String get signupSubtitle =>
      'Erstelle ein Konto, um deine Daten zu speichern';

  @override
  String get signupTitle => 'Erstelle dein Konto';

  @override
  String get user => 'Benutzer';

  @override
  String get userGuest => 'Gast-Benutzer';

  @override
  String get addProductToStart => 'Füge ein Produkt hinzu, um zu beginnen.';

  @override
  String get addItem => 'Produkt hinzufügen';

  @override
  String andMoreProducts(int count) {
    return '... und $count weitere Produkte.';
  }

  @override
  String get atStore => 'bei';

  @override
  String get barcodeOptional => 'Barcode (Optional)';

  @override
  String get editProduct => 'Produkt bearbeiten';

  @override
  String get editPurchase => 'Einkauf bearbeiten';

  @override
  String get exportCsvPro => 'CSV exportieren (Pro)';

  @override
  String get exportPdfAnnualReport => 'Jahresbericht exportieren';

  @override
  String get exportPdfCompleteReport => 'Vollständiger Bericht';

  @override
  String get exportPdfMonthlyReport => 'Monatsbericht exportieren';

  @override
  String get exportPdfReportTooltip => 'Bericht exportieren';

  @override
  String get filterByDateTooltip => 'Nach Datum filtern';

  @override
  String get foundProducts => 'Gefundene Produkte:';

  @override
  String get genericPurchase => 'Generischer Einkauf';

  @override
  String get glutenFree => 'Glutenfrei';

  @override
  String get glutenFreeProduct => 'Glutenfreies Produkt';

  @override
  String get lastPrice => 'Letzter Preis:';

  @override
  String get mainProducts => 'Hauptprodukte:';

  @override
  String get mustBeGreaterThanZero => 'Muss > 0 sein';

  @override
  String get newPurchase => 'Neuer Einkauf';

  @override
  String noProductsFoundFor(String query) {
    return 'Keine Produkte für \"$query\" gefunden';
  }

  @override
  String get noPurchases =>
      'Keine Einkäufe aufgezeichnet.\nDrücke \"+\", um zu beginnen!';

  @override
  String get noStoreSpecified => 'Kein Geschäft angegeben';

  @override
  String get other => 'Anderes';

  @override
  String priceRange(Object max, Object min) {
    return 'Preise: von $min€ bis $max€';
  }

  @override
  String get productHistoryTitle => 'Produkt bereits gekauft!';

  @override
  String get productNameCannotBeEmpty => 'Der Name darf nicht leer sein';

  @override
  String get productNotFoundOrNetworkError =>
      'Produkt nicht gefunden oder Netzwerkfehler.';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Produkte',
      one: '1 Produkt',
      zero: 'Keine Produkte',
    );
    return '$_temp0';
  }

  @override
  String get purchaseDetail => 'Einkaufsdetails';

  @override
  String purchaseExport(String store) {
    return 'Glufri Einkaufsexport - $store';
  }

  @override
  String get purchaseMarkedForDeletion => 'Einkauf gelöscht.';

  @override
  String get purchaseSavedSuccess => 'Einkauf erfolgreich gespeichert!';

  @override
  String purchasedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mal gekauft',
      one: '1 Mal gekauft',
      zero: 'Nie gekauft',
    );
    return '$_temp0';
  }

  @override
  String get removeDateFilterTooltip => 'Datumsfilter entfernen';

  @override
  String get savePurchase => 'Einkauf speichern';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get searchPlaceholder => 'Nach Geschäft oder Produkt suchen...';

  @override
  String get shareSummary => 'Zusammenfassung teilen';

  @override
  String get shareText =>
      'Hier ist mein letzter glutenfreier Einkauf, verfolgt mit der Glufri App! 🛒';

  @override
  String get storeHint => 'z.B. Supermarkt Rossi';

  @override
  String get times => 'Mal';

  @override
  String get totalGlutenFree => 'Glutenfreies Gesamt';

  @override
  String get totalOther => 'Anderes Gesamt';

  @override
  String get totalOverall => 'Gesamtsumme';

  @override
  String get trackedWith => 'Verfolgt mit Glufri App';

  @override
  String get addFromFavorites => 'Aus Favoriten hinzufügen';

  @override
  String get addItemToShoppingList => 'Artikel hinzufügen';

  @override
  String get addManual => 'Manuell hinzufügen';

  @override
  String checkedItems(Object checked, Object total) {
    return '$checked/$total erledigt';
  }

  @override
  String get create => 'Erstellen';

  @override
  String get createListDialogTitle => 'Neue Liste erstellen';

  @override
  String deleteListConfirmationBody(Object listName) {
    return 'Möchtest du die Liste \'$listName\' wirklich löschen?';
  }

  @override
  String get deleteListConfirmationTitle => 'Löschbestätigung';

  @override
  String get emptyShoppingList =>
      'Keine Einkaufslisten gefunden.\nDrücke \'+\' um eine zu erstellen.';

  @override
  String get listName => 'Listenname';

  @override
  String get listNameEmptyError => 'Der Name darf nicht leer sein.';

  @override
  String get noItemsInShoppingList =>
      'Füge oder entferne mindestens einen Artikel, um zu beginnen.';

  @override
  String get startPurchaseFromList => 'Einkauf aus Liste starten';

  @override
  String get addEditFavoriteDialogAdd => 'Favorit hinzufügen';

  @override
  String get addEditFavoriteDialogEdit => 'Favorit bearbeiten';

  @override
  String get addFavoriteProduct => 'Favorit hinzufügen';

  @override
  String get addFromFavoritesTooltip => 'Aus Favoriten hinzufügen';

  @override
  String get addToFavorites => 'Zu Lieblingsprodukten hinzufügen';

  @override
  String get defaultPrice => 'Standardpreis (Optional)';

  @override
  String deleteFavoriteConfirmationBody(String productName) {
    return 'Möchtest du \'$productName\' wirklich aus deinen Favoriten entfernen?';
  }

  @override
  String favoriteProductRemoved(Object productName) {
    return '\'$productName\' aus Favoriten entfernt.';
  }

  @override
  String get noFavoriteProducts =>
      'Du hast noch keine Lieblingsprodukte.\nSpeichere sie von einem Einkauf, um sie hier zu finden.';

  @override
  String get noFavoritesAvailable => 'Du hast keine Lieblingsprodukte.';

  @override
  String get selectFavorite => 'Wähle einen Favoriten';

  @override
  String get settingsFavProducts => 'Lieblingsprodukte';

  @override
  String get budgetSetGlutenFree => 'Budget für Glutenfreies';

  @override
  String get budgetSetTotal => 'Gesamtbudget';

  @override
  String budgetTitle(Object monthYear) {
    return 'Budget für $monthYear';
  }

  @override
  String get budgetTrend => 'Ausgabentrend';

  @override
  String get remainingBudget => 'Verbleibendes Budget';

  @override
  String get saveBudget => 'Budget speichern';

  @override
  String get setBudget => 'Budgets festlegen';

  @override
  String get dark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get light => 'Hell';

  @override
  String get privacyPolicyBody =>
      'Deine Privatsphäre ist uns wichtig...\n[VOLLSTÄNDIGER TEXT DER DATENSCHUTZERKLÄRUNG HIER EINFÜGEN]\n\nGesammelte Daten: Die App speichert Einkaufsdaten ausschließlich auf deinem Gerät. Wenn du die Cloud-Backup-Funktion (Pro-Funktion) nutzt, werden deine Daten verschlüsselt und auf den sicheren Servern von Google Firebase gespeichert.\n\nDatenweitergabe: Es werden keine persönlichen oder Einkaufsdaten an Dritte weitergegeben.\n...';

  @override
  String get privacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get settingsAccountAndBackup => 'Konto und Backup (Pro)';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageItalian => 'Italienisch';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLoginForBackup =>
      'Mit Google anmelden, um das Backup zu aktivieren';

  @override
  String get settingsLoginFailed =>
      'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get system => 'System';

  @override
  String get theme => 'Thema';

  @override
  String get proRequiredForHistory =>
      'Wechsle zu Pro, um den Preisverlauf zu sehen!';

  @override
  String get unlockPro => 'FREISCHALTEN';

  @override
  String get upsellAction => 'Jetzt abonnieren (Jahrespreis)';

  @override
  String get upsellFeature1 => 'Multi-Geräte-Backup und -Synchronisation';

  @override
  String get upsellFeature2 => 'Unbegrenzte CSV-Exporte';

  @override
  String get upsellFeature3 => 'Werbefreie Erfahrung';

  @override
  String get upsellFeature4 => 'Priorisierter Support';

  @override
  String get upsellHeadline => 'Schalte leistungsstarke Funktionen frei!';

  @override
  String get upsellRestore => 'Einkäufe wiederherstellen';

  @override
  String get upsellTitle => 'Wechsle zu Glufri Pro';

  @override
  String get backupError => 'Fehler bei der Sicherung.';

  @override
  String get backupInProgress => 'Sicherung läuft...';

  @override
  String get backupSuccess => 'Sicherung erfolgreich abgeschlossen!';

  @override
  String get migrationDeleted => 'Lokale Daten erfolgreich gelöscht.';

  @override
  String get migrationDialogActionDelete => 'LÖSCHEN';

  @override
  String get migrationDialogActionIgnore => 'NEIN, BEHALTEN';

  @override
  String get migrationDialogActionMerge => 'JA, ZUSAMMENFÜHREN';

  @override
  String migrationDialogBody(int count) {
    return 'Du hast $count Einkäufe auf diesem Gerät gespeichert. Was möchtest du tun?';
  }

  @override
  String get migrationDialogTitle => 'Lokale Einkäufe erkannt';

  @override
  String get migrationSuccess =>
      'Lokale Einkäufe erfolgreich mit deinem Konto zusammengeführt!';

  @override
  String get resetEmailError =>
      'Fehler beim Senden der E-Mail. Die Adresse ist möglicherweise ungültig.';

  @override
  String get resetEmailSuccess =>
      'Wiederherstellungs-E-Mail erfolgreich gesendet! Überprüfe deinen Posteingang.';

  @override
  String get restoreConfirmationBody =>
      'Dies wird alle lokalen Daten mit den in der Cloud gespeicherten Daten überschreiben. Fortfahren?';

  @override
  String get restoreConfirmationTitle => 'Wiederherstellung bestätigen';

  @override
  String get restoreError => 'Fehler bei der Wiederherstellung.';

  @override
  String get restoreInProgress => 'Wiederherstellung läuft...';

  @override
  String get restoreSuccess => 'Daten erfolgreich wiederhergestellt!';

  @override
  String get settingsAuthError => 'Authentifizierungsfehler';

  @override
  String get settingsBackupNow => 'Jetzt sichern';

  @override
  String get settingsLogout => 'Abmelden';

  @override
  String get settingsRestoreFromCloud => 'Aus der Cloud wiederherstellen';

  @override
  String get budgetSaved => 'Budget gespeichert!';

  @override
  String get deleteConfirmationMessage =>
      'Möchtest du diesen Einkauf wirklich löschen? Die Aktion ist irreversibel.';

  @override
  String get deleteConfirmationTitle => 'Löschbestätigung';

  @override
  String get exportError => 'Exportfehler.';

  @override
  String get pdfCreationError => 'Fehler beim Erstellen der PDF-Datei.';

  @override
  String genericError(Object error) {
    return 'Es ist ein Fehler aufgetreten:\n$error';
  }

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get purchaseDeletedSuccess => 'Einkauf erfolgreich gelöscht.';

  @override
  String get requiredField => 'Pflichtfeld';

  @override
  String get shareError => 'Fehler beim Teilen.';

  @override
  String get syncError => 'Synchronisierungsfehler.';
}
