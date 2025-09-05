// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Glufri';

  @override
  String get newPurchase => 'Nueva Compra';

  @override
  String get purchaseHistory => 'Historial de Compras';

  @override
  String get settings => 'Ajustes';

  @override
  String get addItem => 'Añadir Artículo';

  @override
  String get scanBarcode => 'Escanear Código';

  @override
  String get savePurchase => 'Guardar Compra';

  @override
  String get store => 'Tienda';

  @override
  String get productName => 'Nombre del Producto';

  @override
  String get price => 'Precio';

  @override
  String get quantity => 'Cantidad';

  @override
  String get total => 'Total';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get loginAction => 'INICIAR SESIÓN';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Contraseña olvidada?';

  @override
  String get forgotPasswordScreenTitle => 'Recuperar Contraseña';

  @override
  String get forgotPasswordTitle => '¿Has olvidado la contraseña?';

  @override
  String get forgotPasswordInstruction =>
      'Introduce el correo electrónico asociado a tu cuenta. Te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get sendResetEmail => 'ENVIAR CORREO DE RESTABLECIMIENTO';

  @override
  String get resetEmailSuccess =>
      '¡Correo de restablecimiento enviado con éxito! Revisa tu bandeja de entrada.';

  @override
  String get resetEmailError =>
      'Error al enviar el correo. La dirección podría no ser válida.';

  @override
  String get noAccount => '¿No tienes una cuenta? Regístrate';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get or => 'o';

  @override
  String get loginWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signup => 'Registrarse';

  @override
  String get signupAction => 'REGISTRARSE';

  @override
  String get signupTitle => 'Crea tu cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get invalidEmailError =>
      'Por favor, introduce un correo electrónico válido.';

  @override
  String get passwordLengthError =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordsDoNotMatchError => 'Las contraseñas no coinciden.';

  @override
  String get signupError =>
      'Error durante el registro. Por favor, inténtalo de nuevo (ej. el correo ya podría estar en uso).';

  @override
  String get account => 'Cuenta';

  @override
  String loggedInAs(String email) {
    return 'Sesión iniciada como $email';
  }

  @override
  String get searchPlaceholder => 'Buscar por tienda o producto...';

  @override
  String noProductsFoundFor(String query) {
    return 'No se encontraron productos para \"$query\"';
  }

  @override
  String get noPurchases =>
      'No hay compras registradas.\nPulsa \"+\" para empezar.';

  @override
  String get purchaseDetail => 'Detalle de la Compra';

  @override
  String get shareSummary => 'Compartir Resumen';

  @override
  String get edit => 'Editar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get exportCsvPro => 'Exportar a CSV (Pro)';

  @override
  String get delete => 'Eliminar';

  @override
  String get noStoreSpecified => 'Ninguna tienda especificada';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count productos',
      one: '1 producto',
      zero: 'Ningún producto',
    );
    return '$_temp0';
  }

  @override
  String get exportError => 'Error durante la exportación.';

  @override
  String get shareError => 'Error al compartir.';

  @override
  String get deleteConfirmationTitle => 'Confirmar Eliminación';

  @override
  String get deleteConfirmationMessage =>
      '¿Estás seguro de que quieres eliminar esta compra? Esta acción es irreversible.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get purchaseDeletedSuccess => 'Compra eliminada con éxito.';

  @override
  String get editPurchase => 'Editar Compra';

  @override
  String get purchaseSavedSuccess => '¡Compra guardada con éxito!';

  @override
  String get addProductToStart => 'Añade un producto para empezar.';

  @override
  String get productNotFoundOrNetworkError =>
      'Producto no encontrado o error de red.';

  @override
  String get editProduct => 'Editar Producto';

  @override
  String get productNameCannotBeEmpty => 'El nombre no puede estar vacío.';

  @override
  String get requiredField => 'Obligatorio';

  @override
  String get invalidValue => 'Valor no válido';

  @override
  String get mustBeGreaterThanZero => 'Debe ser > 0';

  @override
  String get barcodeOptional => 'Código de Barras (Opcional)';

  @override
  String get update => 'Actualizar';

  @override
  String get glutenFreeProduct => 'Producto Sin Gluten';

  @override
  String get totalGlutenFree => 'Total Sin Gluten';

  @override
  String get totalOther => 'Total Otros';

  @override
  String get totalOverall => 'Total General';

  @override
  String get foundProducts => 'Productos encontrados:';

  @override
  String get glutenFree => 'Sin Gluten';

  @override
  String get other => 'Otro';

  @override
  String get scanBarcodeTitle => 'Escanear EAN-13';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a Glufri!';

  @override
  String get onboardingWelcomeBody =>
      'Tu aplicación para registrar compras sin gluten de forma rápida y sencilla.';

  @override
  String get onboardingScanTitle => 'Escanea y Añade';

  @override
  String get onboardingScanBody =>
      'Usa tu cámara para escanear códigos de barras de productos y añadirlos a tu carrito.';

  @override
  String get onboardingTrackTitle => 'Mantén Todo Bajo Control';

  @override
  String get onboardingTrackBody =>
      'Guarda tus compras y consulta tu historial para analizar tus gastos.';

  @override
  String get skip => 'Saltar';

  @override
  String get start => 'Empezar';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAccountAndBackup => 'Cuenta y Copia de Seguridad (Pro)';

  @override
  String get settingsLoginForBackup =>
      'Inicia sesión con Google para activar la copia de seguridad';

  @override
  String get settingsLoginFailed =>
      'Fallo al iniciar sesión. Inténtalo de nuevo.';

  @override
  String get user => 'Usuario';

  @override
  String get settingsBackupNow => 'Hacer Copia Ahora';

  @override
  String get settingsRestoreFromCloud => 'Restaurar desde la Nube';

  @override
  String get settingsLogout => 'Cerrar Sesión';

  @override
  String get settingsAuthError => 'Error de autenticación';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidad';

  @override
  String get upsellTitle => 'Pásate a Glufri Pro';

  @override
  String get upsellHeadline => '¡Desbloquea Funciones Potentes!';

  @override
  String get upsellFeature1 =>
      'Copia de seguridad y Sincronización multi-dispositivo';

  @override
  String get upsellFeature2 => 'Exportaciones ilimitadas a CSV';

  @override
  String get upsellFeature3 => 'Experiencia sin anuncios';

  @override
  String get upsellFeature4 => 'Soporte Prioritario';

  @override
  String get upsellAction => 'Suscríbete Ahora (Precio Anual)';

  @override
  String get upsellRestore => 'Restaurar Compras';

  @override
  String get migrationDialogTitle => 'Compras Locales Detectadas';

  @override
  String migrationDialogBody(int count) {
    return 'Tienes $count compras guardadas en este dispositivo. ¿Qué quieres hacer?';
  }

  @override
  String get migrationDialogActionDelete => 'ELIMINAR';

  @override
  String get migrationDialogActionIgnore => 'NO, DEJAR';

  @override
  String get migrationDialogActionMerge => 'SÍ, UNIR';

  @override
  String get migrationSuccess => '¡Compras locales unidas a tu cuenta!';

  @override
  String get migrationDeleted => 'Datos locales eliminados con éxito.';

  @override
  String get privacyPolicyTitle => 'Política de Privacidad';

  @override
  String get privacyPolicyBody =>
      'Tu privacidad es importante...\n[INSERTAR TEXTO COMPLETO DE LA POLÍTICA DE PRIVACIDAD AQUÍ]\n\nDatos Recopilados: La app guarda los datos de las compras exclusivamente en tu dispositivo. Si eliges usar la copia de seguridad en la nube (función Pro), tus datos serán cifrados y guardados en los servidores seguros de Google Firebase.\n\nCompartir Datos: No se comparte ningún dato personal o de compra con terceros.\n...';

  @override
  String get genericPurchase => 'Compra genérica';

  @override
  String get mainProducts => 'Productos principales:';

  @override
  String andMoreProducts(int count) {
    return '... y $count productos más.';
  }

  @override
  String get trackedWith => 'Registrado con Glufri App';

  @override
  String get shareText =>
      '¡Aquí está mi última compra sin gluten registrada con la app Glufri! 🛒';

  @override
  String genericError(Object error) {
    return 'Ha ocurrido un error:\n$error';
  }

  @override
  String purchaseExport(String store) {
    return 'Exportación de Compra Glufri - $store';
  }

  @override
  String get storeHint => 'Ej. Supermercado Rossi';

  @override
  String get loginSuccess => '¡Bienvenido/a!';

  @override
  String get logoutSuccess => 'Cierre de sesión exitoso.';
}
