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
  String get addItem => 'Ajouter un Produit';

  @override
  String get scanBarcode => 'Scanner le Code-barres';

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
  String get login => 'Se connecter';

  @override
  String get loginAction => 'SE CONNECTER';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordScreenTitle => 'Récupérer le Mot de Passe';

  @override
  String get forgotPasswordTitle => 'Mot de Passe Oublié ?';

  @override
  String get forgotPasswordInstruction =>
      'Entrez l\'e-mail associé à votre compte. Nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get sendResetEmail => 'ENVOYER L\'E-MAIL DE RÉINITIALISATION';

  @override
  String get resetEmailSuccess =>
      'E-mail de récupération envoyé avec succès ! Vérifiez votre boîte de réception.';

  @override
  String get resetEmailError =>
      'Erreur lors de l\'envoi de l\'e-mail. L\'adresse pourrait ne pas être valide.';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? Se connecter';

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
  String get confirmPassword => 'Confirmer le Mot de passe';

  @override
  String get invalidEmailError => 'Veuillez entrer une adresse e-mail valide.';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get passwordsDoNotMatchError =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get signupError =>
      'Erreur lors de l\'inscription. Veuillez réessayer. (ex. l\'e-mail pourrait déjà être utilisé)';

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
  String get exportError => 'Erreur d\'exportation.';

  @override
  String get shareError => 'Erreur de partage.';

  @override
  String get deleteConfirmationTitle => 'Confirmation de Suppression';

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
      'Produit non trouvé ou erreur de réseau.';

  @override
  String get editProduct => 'Modifier le Produit';

  @override
  String get productNameCannotBeEmpty => 'Le nom ne peut pas être vide';

  @override
  String get requiredField => 'Obligatoire';

  @override
  String get invalidValue => 'Valeur non valide';

  @override
  String get mustBeGreaterThanZero => 'Doit être > 0';

  @override
  String get barcodeOptional => 'Code-barres (Facultatif)';

  @override
  String get update => 'Mettre à jour';

  @override
  String get glutenFreeProduct => 'Produit Sans Gluten';

  @override
  String get totalGlutenFree => 'Total Sans Gluten';

  @override
  String get totalOther => 'Total Autre';

  @override
  String get totalOverall => 'Total Global';

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
      'Votre application pour suivre les achats sans gluten de manière simple et rapide.';

  @override
  String get onboardingScanTitle => 'Scanner et Ajouter';

  @override
  String get onboardingScanBody =>
      'Utilisez la caméra pour scanner le code-barres des produits et les ajouter à votre panier.';

  @override
  String get onboardingTrackTitle => 'Gardez Tout sous Contrôle';

  @override
  String get onboardingTrackBody =>
      'Enregistrez vos achats et consultez l\'historique pour analyser vos dépenses.';

  @override
  String get skip => 'Passer';

  @override
  String get start => 'Commencer';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsLanguageItalian => 'Italien';

  @override
  String get settingsLanguageEnglish => 'Anglais';

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
  String get upsellTitle => 'Passez à Glufri Pro';

  @override
  String get upsellHeadline => 'Débloquez des Fonctionnalités Puissantes !';

  @override
  String get upsellFeature1 => 'Sauvegarde et Sync Multi-appareils';

  @override
  String get upsellFeature2 => 'Exportations CSV illimitées';

  @override
  String get upsellFeature3 => 'Expérience sans publicité';

  @override
  String get upsellFeature4 => 'Support Prioritaire';

  @override
  String get upsellAction => 'S\'abonner Maintenant (Prix Annuel)';

  @override
  String get upsellRestore => 'Restaurer les Achats';

  @override
  String get migrationDialogTitle => 'Achats Locaux Détectés';

  @override
  String migrationDialogBody(int count) {
    return 'Vous avez $count achats sauvegardés sur cet appareil. Que voulez-vous faire ?';
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
      'Votre vie privée est importante...\n[INSÉRER ICI LE TEXTE COMPLET DE LA POLITIQUE DE CONFIDENTIALITÉ]\n\nDonnées Collectées : L\'application sauvegarde les données d\'achat exclusivement sur votre appareil. Si vous choisissez d\'utiliser la fonction de sauvegarde cloud (fonctionnalité Pro), vos données seront cryptées et sauvegardées sur les serveurs sécurisés de Google Firebase.\n\nPartage de Données : Aucune donnée personnelle ou d\'achat n\'est partagée avec des tiers.\n...';

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
    return 'Exportation Achat Glufri - $store';
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

  @override
  String get backupInProgress => 'Sauvegarde en cours...';

  @override
  String get backupSuccess => 'Sauvegarde terminée avec succès !';

  @override
  String get backupError => 'Erreur lors de la sauvegarde.';

  @override
  String get restoreConfirmationTitle => 'Confirmation de Restauration';

  @override
  String get restoreConfirmationBody =>
      'Cela écrasera toutes les données locales avec les données sauvegardées dans le cloud. Continuer ?';

  @override
  String get restoreInProgress => 'Restauration en cours...';

  @override
  String get restoreSuccess => 'Données restaurées avec succès !';

  @override
  String get restoreError => 'Erreur lors de la restauration.';

  @override
  String get productHistoryTitle => 'Produit déjà acheté !';

  @override
  String get lastPrice => 'Dernier prix :';

  @override
  String get atStore => 'chez';

  @override
  String get times => 'fois';

  @override
  String priceRange(Object max, Object min) {
    return 'Prix : de $min€ à $max€';
  }

  @override
  String get continueAction => 'CONTINUER';

  @override
  String purchasedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Acheté $count fois',
      one: 'Acheté 1 fois',
      zero: 'Jamais acheté',
    );
    return '$_temp0';
  }

  @override
  String get settingsFavProducts => 'Produits Favoris';

  @override
  String get noFavoriteProducts =>
      'Vous n\'avez pas encore de produits favoris.\nEnregistrez-les depuis un achat pour les retrouver ici.';

  @override
  String deleteFavoriteConfirmationBody(String productName) {
    return 'Êtes-vous sûr de vouloir supprimer \'$productName\' de vos favoris ?';
  }

  @override
  String get loginWelcome => 'Content de vous revoir !';

  @override
  String get loginSubtitle => 'Connectez-vous à votre compte pour continuer.';

  @override
  String get loginError =>
      'Email ou mot de passe invalide. Veuillez réessayer.';

  @override
  String get noAccountPrompt => 'Pas de compte ?';

  @override
  String get signupSubtitle => 'Créez un compte pour sauvegarder vos données';

  @override
  String get alreadyHaveAccountPrompt => 'Déjà un compte ?';

  @override
  String get forgotPasswordSubtitle =>
      'Aucun problème ! Saisissez votre e-mail et nous vous aiderons.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get userGuest => 'Utilisateur Invité';

  @override
  String get loginToSaveData => 'Connectez-vous pour sauvegarder vos données';

  @override
  String get shoppingLists => 'Listes de Courses';

  @override
  String get monthlyBudget => 'Budget Mensuel';

  @override
  String get favoriteProducts => 'Produits Favoris';
}
