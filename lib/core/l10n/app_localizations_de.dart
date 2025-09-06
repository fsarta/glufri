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
  String get newPurchase => 'Neuer Einkauf';

  @override
  String get purchaseHistory => 'Einkaufsverlauf';

  @override
  String get settings => 'Einstellungen';

  @override
  String get addItem => 'Produkt hinzufügen';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get savePurchase => 'Einkauf speichern';

  @override
  String get store => 'Geschäft';

  @override
  String get productName => 'Produktname';

  @override
  String get price => 'Preis';

  @override
  String get quantity => 'Menge';

  @override
  String get total => 'Gesamt';

  @override
  String get theme => 'Thema';

  @override
  String get language => 'Sprache';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get login => 'Anmelden';

  @override
  String get loginAction => 'ANMELDEN';

  @override
  String get password => 'Passwort';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get forgotPasswordScreenTitle => 'Passwort wiederherstellen';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen?';

  @override
  String get forgotPasswordInstruction =>
      'Gib die mit deinem Konto verknüpfte E-Mail-Adresse ein. Wir senden dir einen Link zum Zurücksetzen deines Passworts.';

  @override
  String get sendResetEmail => 'WIEDERHERSTELLUNGS-E-MAIL SENDEN';

  @override
  String get resetEmailSuccess =>
      'Wiederherstellungs-E-Mail erfolgreich gesendet! Überprüfe deinen Posteingang.';

  @override
  String get resetEmailError =>
      'Fehler beim Senden der E-Mail. Die Adresse ist möglicherweise ungültig.';

  @override
  String get noAccount => 'Du hast kein Konto? Registrieren';

  @override
  String get alreadyHaveAccount => 'Du hast bereits ein Konto? Anmelden';

  @override
  String get or => 'oder';

  @override
  String get loginWithGoogle => 'Mit Google anmelden';

  @override
  String get signup => 'Registrieren';

  @override
  String get signupAction => 'REGISTRIEREN';

  @override
  String get signupTitle => 'Erstelle dein Konto';

  @override
  String get email => 'E-Mail';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get invalidEmailError => 'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String get passwordLengthError =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get passwordsDoNotMatchError =>
      'Die Passwörter stimmen nicht überein.';

  @override
  String get signupError =>
      'Fehler bei der Registrierung. Bitte versuche es erneut. (z. B. die E-Mail-Adresse wird bereits verwendet)';

  @override
  String get account => 'Konto';

  @override
  String loggedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get searchPlaceholder => 'Nach Geschäft oder Produkt suchen...';

  @override
  String noProductsFoundFor(String query) {
    return 'Keine Produkte für \"$query\" gefunden';
  }

  @override
  String get noPurchases =>
      'Keine Einkäufe aufgezeichnet.\nDrücke \"+\", um zu beginnen!';

  @override
  String get purchaseDetail => 'Einkaufsdetails';

  @override
  String get shareSummary => 'Zusammenfassung teilen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get duplicate => 'Duplizieren';

  @override
  String get exportCsvPro => 'CSV exportieren (Pro)';

  @override
  String get delete => 'Löschen';

  @override
  String get noStoreSpecified => 'Kein Geschäft angegeben';

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
  String get exportError => 'Exportfehler.';

  @override
  String get shareError => 'Fehler beim Teilen.';

  @override
  String get deleteConfirmationTitle => 'Löschbestätigung';

  @override
  String get deleteConfirmationMessage =>
      'Möchtest du diesen Einkauf wirklich löschen? Die Aktion ist irreversibel.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get purchaseDeletedSuccess => 'Einkauf erfolgreich gelöscht.';

  @override
  String get editPurchase => 'Einkauf bearbeiten';

  @override
  String get purchaseSavedSuccess => 'Einkauf erfolgreich gespeichert!';

  @override
  String get addProductToStart => 'Füge ein Produkt hinzu, um zu beginnen.';

  @override
  String get productNotFoundOrNetworkError =>
      'Produkt nicht gefunden oder Netzwerkfehler.';

  @override
  String get editProduct => 'Produkt bearbeiten';

  @override
  String get productNameCannotBeEmpty => 'Der Name darf nicht leer sein';

  @override
  String get requiredField => 'Erforderlich';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get mustBeGreaterThanZero => 'Muss > 0 sein';

  @override
  String get barcodeOptional => 'Barcode (Optional)';

  @override
  String get update => 'Aktualisieren';

  @override
  String get glutenFreeProduct => 'Glutenfreies Produkt';

  @override
  String get totalGlutenFree => 'Glutenfreies Gesamt';

  @override
  String get totalOther => 'Anderes Gesamt';

  @override
  String get totalOverall => 'Gesamtsumme';

  @override
  String get foundProducts => 'Gefundene Produkte:';

  @override
  String get glutenFree => 'Glutenfrei';

  @override
  String get other => 'Anderes';

  @override
  String get scanBarcodeTitle => 'EAN-13 scannen';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Glufri!';

  @override
  String get onboardingWelcomeBody =>
      'Deine App, um glutenfreie Einkäufe einfach und schnell zu verfolgen.';

  @override
  String get onboardingScanTitle => 'Scannen und Hinzufügen';

  @override
  String get onboardingScanBody =>
      'Verwende die Kamera, um Produkt-Barcodes zu scannen und sie deinem Einkaufswagen hinzuzufügen.';

  @override
  String get onboardingTrackTitle => 'Behalte alles unter Kontrolle';

  @override
  String get onboardingTrackBody =>
      'Speichere deine Einkäufe und sieh dir den Verlauf an, um deine Ausgaben zu analysieren.';

  @override
  String get skip => 'Überspringen';

  @override
  String get start => 'Starten';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageItalian => 'Italienisch';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsAccountAndBackup => 'Konto und Backup (Pro)';

  @override
  String get settingsLoginForBackup =>
      'Mit Google anmelden, um das Backup zu aktivieren';

  @override
  String get settingsLoginFailed =>
      'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get user => 'Benutzer';

  @override
  String get settingsBackupNow => 'Jetzt sichern';

  @override
  String get settingsRestoreFromCloud => 'Aus der Cloud wiederherstellen';

  @override
  String get settingsLogout => 'Abmelden';

  @override
  String get settingsAuthError => 'Authentifizierungsfehler';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get upsellTitle => 'Wechsle zu Glufri Pro';

  @override
  String get upsellHeadline => 'Schalte leistungsstarke Funktionen frei!';

  @override
  String get upsellFeature1 => 'Multi-Geräte-Backup und -Synchronisation';

  @override
  String get upsellFeature2 => 'Unbegrenzte CSV-Exporte';

  @override
  String get upsellFeature3 => 'Werbefreie Erfahrung';

  @override
  String get upsellFeature4 => 'Priorisierter Support';

  @override
  String get upsellAction => 'Jetzt abonnieren (Jahrespreis)';

  @override
  String get upsellRestore => 'Einkäufe wiederherstellen';

  @override
  String get migrationDialogTitle => 'Lokale Einkäufe erkannt';

  @override
  String migrationDialogBody(int count) {
    return 'Du hast $count Einkäufe auf diesem Gerät gespeichert. Was möchtest du tun?';
  }

  @override
  String get migrationDialogActionDelete => 'LÖSCHEN';

  @override
  String get migrationDialogActionIgnore => 'NEIN, BEHALTEN';

  @override
  String get migrationDialogActionMerge => 'JA, ZUSAMMENFÜHREN';

  @override
  String get migrationSuccess =>
      'Lokale Einkäufe erfolgreich mit deinem Konto zusammengeführt!';

  @override
  String get migrationDeleted => 'Lokale Daten erfolgreich gelöscht.';

  @override
  String get privacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get privacyPolicyBody =>
      'Deine Privatsphäre ist uns wichtig...\n[VOLLSTÄNDIGER TEXT DER DATENSCHUTZERKLÄRUNG HIER EINFÜGEN]\n\nGesammelte Daten: Die App speichert Einkaufsdaten ausschließlich auf deinem Gerät. Wenn du die Cloud-Backup-Funktion (Pro-Funktion) nutzt, werden deine Daten verschlüsselt und auf den sicheren Servern von Google Firebase gespeichert.\n\nDatenweitergabe: Es werden keine persönlichen oder Einkaufsdaten an Dritte weitergegeben.\n...';

  @override
  String get genericPurchase => 'Generischer Einkauf';

  @override
  String get mainProducts => 'Hauptprodukte:';

  @override
  String andMoreProducts(int count) {
    return '... und $count weitere Produkte.';
  }

  @override
  String get trackedWith => 'Verfolgt mit Glufri App';

  @override
  String get shareText =>
      'Hier ist mein letzter glutenfreier Einkauf, verfolgt mit der Glufri App! 🛒';

  @override
  String genericError(Object error) {
    return 'Es ist ein Fehler aufgetreten:\n$error';
  }

  @override
  String purchaseExport(String store) {
    return 'Glufri Einkaufsexport - $store';
  }

  @override
  String get storeHint => 'z.B. Supermarkt Rossi';

  @override
  String get loginSuccess => 'Willkommen!';

  @override
  String get logoutSuccess => 'Erfolgreich abgemeldet.';

  @override
  String get undoAction => 'RÜCKGÄNGIG';

  @override
  String get purchaseMarkedForDeletion => 'Einkauf gelöscht.';

  @override
  String get backupInProgress => 'Sicherung läuft...';

  @override
  String get backupSuccess => 'Sicherung erfolgreich abgeschlossen!';

  @override
  String get backupError => 'Fehler bei der Sicherung.';

  @override
  String get restoreConfirmationTitle => 'Wiederherstellung bestätigen';

  @override
  String get restoreConfirmationBody =>
      'Dies wird alle lokalen Daten mit den in der Cloud gespeicherten Daten überschreiben. Fortfahren?';

  @override
  String get restoreInProgress => 'Wiederherstellung läuft...';

  @override
  String get restoreSuccess => 'Daten erfolgreich wiederhergestellt!';

  @override
  String get restoreError => 'Fehler bei der Wiederherstellung.';
}
