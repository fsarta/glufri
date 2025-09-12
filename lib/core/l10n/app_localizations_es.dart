// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get add => 'Añadir';

  @override
  String get appName => 'Glufri';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get continueAction => 'CONTINUAR';

  @override
  String get create => 'Crear';

  @override
  String get delete => 'Eliminar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get edit => 'Editar';

  @override
  String get loading => 'Cargando...';

  @override
  String get or => 'o';

  @override
  String get price => 'Precio';

  @override
  String get productName => 'Nombre del Producto';

  @override
  String get quantity => 'Cantidad';

  @override
  String get save => 'Guardar';

  @override
  String get skip => 'Omitir';

  @override
  String get start => 'Empezar';

  @override
  String get store => 'Tienda';

  @override
  String get total => 'Total';

  @override
  String get unit => 'Unidad';

  @override
  String get undoAction => 'DESHACER';

  @override
  String get update => 'Actualizar';

  @override
  String get favoriteProducts => 'Productos Favoritos';

  @override
  String get forgotPasswordScreenTitle => 'Recuperar Contraseña';

  @override
  String get monthlyBudget => 'Presupuesto Mensual';

  @override
  String get purchaseHistory => 'Historial de Compras';

  @override
  String get scanBarcodeTitle => 'Escanear EAN-13';

  @override
  String get settings => 'Ajustes';

  @override
  String get shoppingLists => 'Listas de Compra';

  @override
  String get shoppingListsScreenTitle => 'Listas de Compra';

  @override
  String get onboardingScanBody =>
      'Usa la cámara para escanear el código de barras de los productos y añadirlos a tu carrito.';

  @override
  String get onboardingScanTitle => 'Escanear y Añadir';

  @override
  String get onboardingTrackBody =>
      'Guarda tus compras y consulta el historial para analizar tus gastos.';

  @override
  String get onboardingTrackTitle => 'Mantén Todo Bajo Control';

  @override
  String get onboardingWelcomeBody =>
      'Tu app para registrar compras sin gluten de forma rápida y sencilla.';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a Glufri!';

  @override
  String get account => 'Cuenta';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get alreadyHaveAccountPrompt => '¿Ya tienes una cuenta?';

  @override
  String get backToLogin => 'Volver al Inicio de Sesión';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get email => 'Correo electrónico';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordInstruction =>
      'Introduce el correo electrónico asociado a tu cuenta. Te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get forgotPasswordSubtitle =>
      '¡No hay problema! Introduce tu correo electrónico y te ayudaremos.';

  @override
  String get forgotPasswordTitle => '¿Contraseña Olvidada?';

  @override
  String get googleLoginFailed =>
      'Error al iniciar sesión con Google. Inténtalo de nuevo.';

  @override
  String get invalidEmailError => 'Introduce un correo electrónico válido.';

  @override
  String loggedInAs(String email) {
    return 'Sesión iniciada como $email';
  }

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginAction => 'INICIAR SESIÓN';

  @override
  String get loginError =>
      'Correo electrónico o contraseña no válidos. Inténtalo de nuevo.';

  @override
  String get loginToSaveData => 'Inicia sesión para guardar tus datos';

  @override
  String get loginSubtitle => 'Inicia sesión en tu cuenta para continuar.';

  @override
  String get loginSuccess => '¡Bienvenido/a!';

  @override
  String get loginWelcome => '¡Bienvenido de Nuevo!';

  @override
  String get loginWithGoogle => 'Iniciar sesión con Google';

  @override
  String get logoutSuccess => 'Sesión cerrada con éxito.';

  @override
  String get noAccount => '¿No tienes una cuenta? Regístrate';

  @override
  String get noAccountPrompt => '¿No tienes una cuenta?';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordLengthError =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordsDoNotMatchError => 'Las contraseñas no coinciden.';

  @override
  String get resetEmailError =>
      'Error al enviar el correo. La dirección podría no ser válida.';

  @override
  String get resetEmailSuccess =>
      'Correo de recuperación enviado con éxito. Revisa tu bandeja de entrada.';

  @override
  String get sendResetEmail => 'ENVIAR CORREO DE RECUPERACIÓN';

  @override
  String get signup => 'Registrarse';

  @override
  String get signupAction => 'REGISTRARSE';

  @override
  String get signupError =>
      'Error durante el registro. Inténtalo de nuevo. (ej. el correo electrónico ya podría estar en uso)';

  @override
  String get signupSubtitle => 'Crea una cuenta para guardar tus datos';

  @override
  String get signupTitle => 'Crea tu cuenta';

  @override
  String get user => 'Usuario';

  @override
  String get userGuest => 'Usuario Invitado';

  @override
  String get addItem => 'Añadir Producto';

  @override
  String get addProductToStart => 'Añade un producto para empezar.';

  @override
  String andMoreProducts(int count) {
    return '... y $count productos más.';
  }

  @override
  String get atStore => 'en';

  @override
  String get barcodeOptional => 'Código de Barras (Opcional)';

  @override
  String get editProduct => 'Editar Producto';

  @override
  String get editPurchase => 'Editar Compra';

  @override
  String get exportCsvPro => 'Exportar CSV (Pro)';

  @override
  String get exportPdfAnnualReport => 'Exportar Informe Anual';

  @override
  String get exportPdfCompleteReport => 'Informe Completo';

  @override
  String get exportPdfMonthlyReport => 'Exportar Informe Mensual';

  @override
  String get exportPdfReportTooltip => 'Exportar Informe';

  @override
  String get filterByDateTooltip => 'Filtrar por fecha';

  @override
  String get foundProducts => 'Productos encontrados:';

  @override
  String get genericPurchase => 'Compra genérica';

  @override
  String get glutenFree => 'Sin Gluten';

  @override
  String get glutenFreeProduct => 'Producto Sin Gluten';

  @override
  String get lastPrice => 'Último precio:';

  @override
  String get mainProducts => 'Productos principales:';

  @override
  String get mustBeGreaterThanZero => 'Debe ser > 0';

  @override
  String get newPurchase => 'Nueva Compra';

  @override
  String noProductsFoundFor(String query) {
    return 'No se encontraron productos para \"$query\"';
  }

  @override
  String get noPurchases =>
      'No se registraron compras.\n¡Pulsa \"+\" para empezar!';

  @override
  String get noStoreSpecified => 'No se especificó la tienda';

  @override
  String get other => 'Otros';

  @override
  String pdfReportTitleAnnual(String year) {
    return 'Informe de Gastos - $year';
  }

  @override
  String get pdfReportTitleComplete => 'Informe de Gastos Completo';

  @override
  String pdfReportTitleMonthly(String date) {
    return 'Informe de Gastos - $date';
  }

  @override
  String priceRange(Object max, Object min) {
    return 'Precios: de $min€ a $max€';
  }

  @override
  String get productHistoryTitle => '¡Producto ya comprado!';

  @override
  String get productNameCannotBeEmpty => 'El nombre no puede estar vacío';

  @override
  String get productNotFoundOrNetworkError =>
      'Producto no encontrado o error de red.';

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
  String get purchaseDetail => 'Detalle de Compra';

  @override
  String purchaseExport(String store) {
    return 'Exportación de Compra Glufri - $store';
  }

  @override
  String get purchaseMarkedForDeletion => 'Compra eliminada.';

  @override
  String get purchaseSavedSuccess => '¡Compra guardada con éxito!';

  @override
  String purchasedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Comprado $count veces',
      one: 'Comprado 1 vez',
      zero: 'Nunca comprado',
    );
    return '$_temp0';
  }

  @override
  String get removeDateFilterTooltip => 'Quitar filtro de fecha';

  @override
  String get savePurchase => 'Guardar Compra';

  @override
  String get scanBarcode => 'Escanear Código';

  @override
  String get searchPlaceholder => 'Buscar por tienda o producto...';

  @override
  String selectMonthOfYear(String year) {
    return 'Selecciona un Mes de $year';
  }

  @override
  String get shareSummary => 'Compartir Resumen';

  @override
  String get shareText =>
      '¡Aquí está mi última compra sin gluten registrada con la app Glufri! 🛒';

  @override
  String get storeHint => 'Ej. Supermercado Rossi';

  @override
  String get times => 'veces';

  @override
  String get totalGlutenFree => 'Total Sin Gluten';

  @override
  String get totalOther => 'Total Otros';

  @override
  String get totalOverall => 'Total General';

  @override
  String get trackedWith => 'Seguimiento con la App Glufri';

  @override
  String get weightVolumePieces => 'Peso / Volumen / Piezas';

  @override
  String get addFromFavorites => 'Añadir de Favoritos';

  @override
  String get addItemToShoppingList => 'Añadir Producto';

  @override
  String get addItemTooltip => 'Añadir elemento';

  @override
  String get addManual => 'Añadir manualmente';

  @override
  String checkedItems(String checked, String total) {
    return '$checked/$total completados';
  }

  @override
  String get createNewListTooltip => 'Nueva Lista';

  @override
  String get createListDialogTitle => 'Crear Nueva Lista';

  @override
  String deleteListConfirmationBody(String listName) {
    return '¿Estás seguro de que quieres eliminar la lista \'$listName\'?';
  }

  @override
  String get deleteListConfirmationTitle => 'Confirmar Eliminación';

  @override
  String get emptyShoppingList =>
      'No se encontraron listas de compra.\nPulsa \'+\' para crear una.';

  @override
  String itemAddedToList(String itemName) {
    return 'Se ha añadido \'$itemName\' a la lista.';
  }

  @override
  String get listName => 'Nombre de la lista';

  @override
  String get listNameEmptyError => 'El nombre no puede estar vacío.';

  @override
  String get noItemsInShoppingList =>
      'Añade o desmarca al menos un producto para empezar.';

  @override
  String get startPurchaseFromList => 'Empezar Compra desde la Lista';

  @override
  String get addEditFavoriteDialogAdd => 'Añadir Favorito';

  @override
  String get addEditFavoriteDialogEdit => 'Editar Favorito';

  @override
  String get addFavoriteProduct => 'Añadir Favorito';

  @override
  String get addFromFavoritesTooltip => 'Añadir de Favoritos';

  @override
  String get addToFavorites => 'Añadir a productos favoritos';

  @override
  String get defaultPrice => 'Precio Predeterminado (Opcional)';

  @override
  String deleteFavoriteConfirmationBody(String productName) {
    return '¿Estás seguro de que quieres eliminar \'$productName\' de tus favoritos?';
  }

  @override
  String favoriteProductRemoved(Object productName) {
    return '\'$productName\' eliminado de favoritos.';
  }

  @override
  String get noFavoriteProducts =>
      'Todavía no tienes productos favoritos.\nGuárdalos de una compra para encontrarlos aquí.';

  @override
  String get noFavoritesAvailable => 'No tienes ningún producto favorito.';

  @override
  String get selectFavorite => 'Selecciona un Favorito';

  @override
  String get settingsFavProducts => 'Productos Favoritos';

  @override
  String get budgetSaved => '¡Presupuesto guardado!';

  @override
  String get budgetSetGlutenFree => 'Presupuesto Sin Gluten';

  @override
  String get budgetSetTotal => 'Presupuesto Total';

  @override
  String budgetTitle(String monthYear) {
    return 'Presupuesto para $monthYear';
  }

  @override
  String get budgetTrend => 'Tendencia de Gasto';

  @override
  String get remainingBudget => 'Presupuesto Restante';

  @override
  String get saveBudget => 'Guardar Presupuesto';

  @override
  String get setBudget => 'Establecer Presupuestos';

  @override
  String get dark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get light => 'Claro';

  @override
  String get privacyPolicyBody =>
      'Tu privacidad es importante...\n[INSERTAR AQUÍ EL TEXTO COMPLETO DE LA POLÍTICA DE PRIVACIDAD]\n\nDatos Recopilados: La app guarda los datos de las compras exclusivamente en tu dispositivo. Si eliges usar la función de copia de seguridad en la nube (funcionalidad Pro), tus datos se encriptarán y se guardarán en los servidores seguros de Google Firebase.\n\nCompartición de Datos: No se comparten datos personales o de compra con terceros.\n...';

  @override
  String get privacyPolicyTitle => 'Política de Privacidad';

  @override
  String get settingsAccountAndBackup => 'Cuenta y Copia de Seguridad (Pro)';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsLoginForBackup =>
      'Inicia sesión con Google para habilitar la copia de seguridad';

  @override
  String get settingsLoginFailed =>
      'Error al iniciar sesión. Inténtalo de nuevo.';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidad';

  @override
  String get system => 'Sistema';

  @override
  String get theme => 'Tema';

  @override
  String get proRequiredForHistory =>
      '¡Hazte Pro para ver el historial de precios!';

  @override
  String get unlockPro => 'DESBLOQUEAR';

  @override
  String get upsellAction => 'Suscríbete Ahora (Precio Anual)';

  @override
  String get upsellFeature1 =>
      'Copia de seguridad y sincronización Multi-dispositivo';

  @override
  String get upsellFeature2 => 'Exportaciones ilimitadas a CSV';

  @override
  String get upsellFeature3 => 'Experiencia sin publicidad';

  @override
  String get upsellFeature4 => 'Soporte Prioritario';

  @override
  String get upsellHeadline => '¡Desbloquea el Potencial Completo!';

  @override
  String get upsellRestore => 'Restaurar Compras';

  @override
  String get upsellTitle => 'Actualiza a Glufri Pro';

  @override
  String get backupError => 'Error durante la copia de seguridad.';

  @override
  String get backupInProgress => 'Copia de seguridad en curso...';

  @override
  String get backupSuccess => '¡Copia de seguridad completada con éxito!';

  @override
  String get migrationDeleted => 'Datos locales eliminados con éxito.';

  @override
  String get migrationDialogActionDelete => 'ELIMINAR';

  @override
  String get migrationDialogActionIgnore => 'NO, DEJARLOS';

  @override
  String get migrationDialogActionMerge => 'SÍ, FUSIONAR';

  @override
  String migrationDialogBody(int count) {
    return 'Tienes $count compras guardadas en este dispositivo. ¿Qué quieres hacer?';
  }

  @override
  String get migrationDialogTitle => 'Compras Locales Detectadas';

  @override
  String get migrationSuccess => '¡Compras locales fusionadas con tu cuenta!';

  @override
  String get restoreConfirmationBody =>
      'Esto sobrescribirá todos los datos locales con los datos guardados en la nube. ¿Continuar?';

  @override
  String get restoreConfirmationTitle => 'Confirmar Restauración';

  @override
  String get restoreError => 'Error durante la restauración.';

  @override
  String get restoreInProgress => 'Restauración en curso...';

  @override
  String get restoreSuccess => '¡Datos restaurados con éxito!';

  @override
  String get settingsAuthError => 'Error de autenticación';

  @override
  String get settingsBackupNow => 'Hacer Copia de Seguridad Ahora';

  @override
  String get settingsLogout => 'Cerrar sesión';

  @override
  String get settingsRestoreFromCloud => 'Restaurar desde la Nube';

  @override
  String get deleteConfirmationMessage =>
      '¿Estás seguro de que quieres eliminar esta compra? La acción es irreversible.';

  @override
  String get deleteConfirmationTitle => 'Confirmar Eliminación';

  @override
  String get exportError => 'Error de exportación.';

  @override
  String genericError(Object error) {
    return 'Ocurrió un error:\n$error';
  }

  @override
  String get invalidValue => 'Valor no válido';

  @override
  String get listNotFound => 'Lista no encontrada o eliminada.';

  @override
  String get optionalDetails => 'Detalles opcionales';

  @override
  String get pdfCreationError => 'Error al crear el PDF.';

  @override
  String get purchaseDeletedSuccess => 'Compra eliminada con éxito.';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get shareError => 'Error al compartir.';

  @override
  String get shoppingListError => 'Error al cargar las listas.';

  @override
  String get syncError => 'Error de sincronización.';

  @override
  String get upsellSubtitle =>
      'Toma el control total de tus gastos sin gluten.';

  @override
  String get proFeatureTitleBackup =>
      'Copia de Seguridad y Sincronización Multi-dispositivo';

  @override
  String get proFeatureBodyBackup =>
      'Tus datos son valiosos. Guarda cada compra de forma segura en la nube. ¿Cambias de teléfono o usas una tableta? Encuentra al instante todos tus datos, listas y favoritos sincronizados. Máxima seguridad, cero preocupaciones.';

  @override
  String get proFeatureTitleLists => 'Listas de Compras Inteligentes';

  @override
  String get proFeatureBodyLists =>
      'La planificación es todo. Crea listas de compras ilimitadas, agrega productos de tus favoritos con un toque y, una vez en el supermercado, convierte la lista en una nueva compra con un solo botón. Nunca más notas de papel o aplicaciones separadas.';

  @override
  String get proFeatureTitleFavorites => 'Productos Favoritos Ilimitados';

  @override
  String get proFeatureBodyFavorites =>
      'Ahorra tiempo en cada compra. Guarda los productos que compras más a menudo como favoritos, establece un precio predeterminado y agrégalos a tus listas o futuras compras en un instante. Tu supermercado personal, siempre en tu bolsillo.';

  @override
  String get proFeatureTitleBudget => 'Control de Presupuesto Mensual';

  @override
  String get proFeatureBodyBudget =>
      '¿Cuánto gastas realmente en productos sin gluten? Establece presupuestos mensuales totales y específicos para el gluten-free. Rastrea tus gastos en tiempo real y ve tu presupuesto restante mientras añades productos al carrito. No más sorpresas a fin de mes.';

  @override
  String get proFeatureTitleDetails =>
      'Detalles de Producto Profundos (con OFF)';

  @override
  String get proFeatureBodyDetails =>
      'Toma decisiones más conscientes. Escanea un código de barras y descubre al instante ingredientes, alérgenos, el Nutri-Score y el grado de procesamiento (NOVA). Glufri se convierte en tu asistente para una compra no solo sin gluten, sino también más saludable.';

  @override
  String get proFeatureTitleHistory => 'Historial de Precios';

  @override
  String get proFeatureBodyHistory =>
      '¿Estás pagando el precio correcto? Cuando escaneas un producto que ya has comprado, Glufri Pro te muestra al instante el último precio pagado y te avisa si estás gastando más. Compra como un profesional.';

  @override
  String get proFeatureTitleExport => 'Exportaciones Ilimitadas (PDF y CSV)';

  @override
  String get proFeatureBodyExport =>
      'Tus datos, tus reglas. Genera informes mensuales o anuales en PDF, perfectos para análisis personales o deducciones fiscales. Exporta las compras individuales en formato CSV para un análisis profundo con hojas de cálculo. Control total sobre tus datos de gasto.';

  @override
  String get proFeatureTitleNoAds => 'Experiencia Sin Interrupciones';

  @override
  String get proFeatureBodyNoAds =>
      'Concéntrate solo en tu compra. La versión Pro elimina toda la publicidad, ofreciéndote una experiencia más limpia, rápida y sin distracciones.';

  @override
  String get comparisonTitle => 'Compara Planes';

  @override
  String get featureHeader => 'Funcionalidad';

  @override
  String get freeHeader => 'Free';

  @override
  String get proHeader => 'PRO';
}
