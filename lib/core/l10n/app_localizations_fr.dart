// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Glufri';

  @override
  String get newPurchase => 'Nouvel Achat';

  @override
  String get purchaseHistory => 'Historique des Achats';

  @override
  String get settings => 'Paramètres';

  @override
  String get addItem => 'Ajouter Article';

  @override
  String get scanBarcode => 'Scanner le Code';

  @override
  String get savePurchase => 'Enregistrer l\'Achat';

  @override
  String get store => 'Magasin';

  @override
  String get productName => 'Nom du Produit';

  @override
  String get price => 'Prix';

  @override
  String get quantity => 'Quantité';

  @override
  String get total => 'Total';

  @override
  String get theme => 'Thème';

  @override
  String get language => 'Langue';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get login => 'Connexion';

  @override
  String get loginAction => 'CONNEXION';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordScreenTitle => 'Récupérer le Mot de Passe';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordInstruction =>
      'Saisissez l\'e-mail associé à votre compte. Nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get sendResetEmail => 'ENVOYER L\'E-MAIL DE RÉINITIALISATION';

  @override
  String get resetEmailSuccess =>
      'E-mail de réinitialisation envoyé avec succès ! Vérifiez votre boîte de réception.';

  @override
  String get resetEmailError =>
      'Erreur lors de l\'envoi de l\'e-mail. L\'adresse pourrait ne pas être valide.';

  @override
  String get noAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get or => 'ou';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get signupAction => 'S\'INSCRIRE';

  @override
  String get signupTitle => 'Créez votre compte';

  @override
  String get email => 'E-mail';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get invalidEmailError => 'Veuillez saisir une adresse e-mail valide.';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get passwordsDoNotMatchError =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get signupError =>
      'Erreur lors de l\'inscription. Veuillez réessayer (par exemple, l\'e-mail pourrait déjà être utilisé).';

  @override
  String get account => 'Compte';

  @override
  String loggedInAs(String email) {
    return 'Connecté en tant que $email';
  }

  @override
  String get searchPlaceholder => 'Rechercher par magasin ou produit...';

  @override
  String noProductsFoundFor(String query) {
    return 'Aucun produit trouvé pour \"$query\"';
  }

  @override
  String get noPurchases =>
      'Aucun achat enregistré.\nAppuyez sur \"+\" pour commencer !';

  @override
  String get purchaseDetail => 'Détail de l\'Achat';

  @override
  String get shareSummary => 'Partager le Résumé';

  @override
  String get edit => 'Modifier';

  @override
  String get duplicate => 'Dupliquer';

  @override
  String get exportCsvPro => 'Exporter en CSV (Pro)';

  @override
  String get delete => 'Supprimer';

  @override
  String get noStoreSpecified => 'Aucun magasin spécifié';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits',
      one: '1 produit',
      zero: 'Aucun produit',
    );
    return '$_temp0';
  }

  @override
  String get exportError => 'Erreur lors de l\'exportation.';

  @override
  String get shareError => 'Erreur lors du partage.';

  @override
  String get deleteConfirmationTitle => 'Confirmer la Suppression';

  @override
  String get deleteConfirmationMessage =>
      'Êtes-vous sûr de vouloir supprimer cet achat ? Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get purchaseDeletedSuccess => 'Achat supprimé avec succès.';

  @override
  String get editPurchase => 'Modifier l\'Achat';

  @override
  String get purchaseSavedSuccess => 'Achat enregistré avec succès !';

  @override
  String get addProductToStart => 'Ajoutez un produit pour commencer.';

  @override
  String get productNotFoundOrNetworkError =>
      'Produit non trouvé ou erreur réseau.';

  @override
  String get editProduct => 'Modifier le Produit';

  @override
  String get productNameCannotBeEmpty => 'Le nom ne peut pas être vide.';

  @override
  String get requiredField => 'Obligatoire';

  @override
  String get invalidValue => 'Valeur non valide';

  @override
  String get mustBeGreaterThanZero => 'Doit être > 0';

  @override
  String get barcodeOptional => 'Code-barres (Optionnel)';

  @override
  String get update => 'Mettre à jour';

  @override
  String get glutenFreeProduct => 'Produit Sans Gluten';

  @override
  String get totalGlutenFree => 'Total Sans Gluten';

  @override
  String get totalOther => 'Total Autre';

  @override
  String get totalOverall => 'Total Général';

  @override
  String get foundProducts => 'Produits trouvés :';

  @override
  String get glutenFree => 'Sans Gluten';

  @override
  String get other => 'Autre';

  @override
  String get scanBarcodeTitle => 'Scanner EAN-13';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Glufri !';

  @override
  String get onboardingWelcomeBody =>
      'Votre application pour suivre les achats sans gluten rapidement et facilement.';

  @override
  String get onboardingScanTitle => 'Scannez et Ajoutez';

  @override
  String get onboardingScanBody =>
      'Utilisez votre appareil photo pour scanner les codes-barres des produits et les ajouter à votre panier.';

  @override
  String get onboardingTrackTitle => 'Gardez Tout Sous Contrôle';

  @override
  String get onboardingTrackBody =>
      'Enregistrez vos achats et consultez votre historique pour analyser vos dépenses.';

  @override
  String get skip => 'Passer';

  @override
  String get start => 'Commencer';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAccountAndBackup => 'Compte et Sauvegarde (Pro)';

  @override
  String get settingsLoginForBackup =>
      'Connectez-vous avec Google pour activer la sauvegarde';

  @override
  String get settingsLoginFailed =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get user => 'Utilisateur';

  @override
  String get settingsBackupNow => 'Sauvegarder Maintenant';

  @override
  String get settingsRestoreFromCloud => 'Restaurer depuis le Cloud';

  @override
  String get settingsLogout => 'Déconnexion';

  @override
  String get settingsAuthError => 'Erreur d\'authentification';

  @override
  String get settingsPrivacyPolicy => 'Politique de Confidentialité';

  @override
  String get upsellTitle => 'Passer à Glufri Pro';

  @override
  String get upsellHeadline => 'Débloquez des Fonctionnalités Puissantes !';

  @override
  String get upsellFeature1 => 'Sauvegarde Cloud et Synchro multi-appareils';

  @override
  String get upsellFeature2 => 'Exportations CSV illimitées';

  @override
  String get upsellFeature3 => 'Expérience sans publicité';

  @override
  String get upsellFeature4 => 'Support Prioritaire';

  @override
  String get upsellAction => 'Abonnez-vous Maintenant (Prix Annuel)';

  @override
  String get upsellRestore => 'Restaurer les Achats';

  @override
  String get migrationDialogTitle => 'Achats Locaux Détectés';

  @override
  String migrationDialogBody(int count) {
    return 'Vous avez $count achats enregistrés sur cet appareil. Que souhaitez-vous faire ?';
  }

  @override
  String get migrationDialogActionDelete => 'SUPPRIMER';

  @override
  String get migrationDialogActionIgnore => 'NON, LAISSER';

  @override
  String get migrationDialogActionMerge => 'OUI, FUSIONNER';

  @override
  String get migrationSuccess => 'Achats locaux fusionnés avec votre compte !';

  @override
  String get migrationDeleted => 'Données locales supprimées avec succès.';

  @override
  String get privacyPolicyTitle => 'Politique de Confidentialité';

  @override
  String get privacyPolicyBody =>
      'Votre vie privée est importante...\n[INSÉRER LE TEXTE COMPLET DE LA POLITIQUE DE CONFIDENTIALITÉ ICI]\n\nDonnées Collectées : L\'application enregistre les données d\'achat exclusivement sur votre appareil. Si vous choisissez d\'utiliser la fonction de sauvegarde cloud (fonctionnalité Pro), vos données seront cryptées et enregistrées sur les serveurs sécurisés de Google Firebase.\n\nPartage de Données : Aucune donnée personnelle ou d\'achat n\'est partagée avec des tiers.\n...';

  @override
  String get genericPurchase => 'Achat générique';

  @override
  String get mainProducts => 'Produits principaux :';

  @override
  String andMoreProducts(int count) {
    return '... et $count autres produits.';
  }

  @override
  String get trackedWith => 'Suivi avec l\'App Glufri';

  @override
  String get shareText =>
      'Voici mon dernier achat sans gluten suivi avec l\'app Glufri ! 🛒';

  @override
  String genericError(Object error) {
    return 'Une erreur est survenue :\n$error';
  }

  @override
  String purchaseExport(String store) {
    return 'Exportation d\'Achat Glufri - $store';
  }

  @override
  String get storeHint => 'Ex. Supermarché Rossi';

  @override
  String get loginSuccess => 'Bienvenue !';

  @override
  String get logoutSuccess => 'Déconnexion réussie.';

  @override
  String get undoAction => 'ANNULER';

  @override
  String get purchaseMarkedForDeletion => 'Achat supprimé.';
}
