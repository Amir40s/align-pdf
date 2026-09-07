// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get setting => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get changeAppLanguage => 'Cambiar el idioma de la aplicación';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get readOurPrivacyPolicy => 'Lee nuestra política de privacidad';

  @override
  String get termsOfService => 'Términos del servicio';

  @override
  String get readOurTermsOfService => 'Lee nuestros términos del servicio';

  @override
  String get helpSupport => 'Ayuda y soporte';

  @override
  String get getHelpWithAlignPdfAi => 'Obtén ayuda con Align PDF AI';

  @override
  String get rateApp => 'Calificar aplicación';

  @override
  String get shareYourFeedback => 'Comparte tus comentarios';

  @override
  String get error => 'Error';

  @override
  String get invalidUrl => 'URL no válida.';

  @override
  String get unableToOpenLink => 'No se puede abrir este enlace.';

  @override
  String get renamePdf => 'Cambiar nombre del PDF';

  @override
  String get pdfName => 'Nombre del PDF';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get deletePdf => 'Eliminar PDF';

  @override
  String get areYouSureDeletePdf => '¿Estás seguro de que quieres eliminar este PDF?';

  @override
  String get delete => 'Eliminar';

  @override
  String get openPdf => 'Abrir PDF';

  @override
  String get share => 'Compartir';

  @override
  String get rename => 'Cambiar nombre';

  @override
  String get noRecentDocuments => 'No hay documentos recientes';

  @override
  String get createFirstPdfToSeeItHere => 'Crea tu primer PDF para verlo aquí';

  @override
  String get recentDocuments => 'Documentos recientes';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get scanDocument => 'Escanear documento';

  @override
  String get captureDocumentWithAi => 'Capturar un documento con IA';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get fileNotFound => 'Archivo no encontrado';

  @override
  String get thisPdfIsNoLongerAvailable => 'Este PDF ya no está disponible.';

  @override
  String get unableToOpen => 'No se puede abrir';

  @override
  String get placeDocumentWithinFrame => 'Coloca el documento dentro del marco';

  @override
  String get flash => 'Flash';

  @override
  String get on => 'Activado';

  @override
  String get off => 'Desactivado';

  @override
  String get documentDetected => 'Documento detectado';

  @override
  String get keepSteadyAvoidShadows => 'Mantén el dispositivo estable y evita las sombras';

  @override
  String get gallery => 'Galería';

  @override
  String get multiPage => 'Varias páginas';

  @override
  String get processingDocument => 'Procesando documento...';

  @override
  String get extractingTextWithAi => 'Extrayendo texto con IA';

  @override
  String get cameraError => 'Error de cámara';

  @override
  String get noCameraFound => 'No se encontró ninguna cámara en este dispositivo.';

  @override
  String get unableToInitializeCamera => 'No se pudo inicializar la cámara.';

  @override
  String get noTextFound => 'No se encontró texto';

  @override
  String get couldntFindText => 'No pudimos encontrar texto en este documento. Intenta escanearlo de nuevo.';

  @override
  String get scanError => 'Error de escaneo';

  @override
  String get somethingWentWrongScanning => 'Algo salió mal al escanear el documento.';

  @override
  String get noDocumentsFound => 'No se encontraron documentos';

  @override
  String get noneSelectedImagesReadable => 'Ninguna de las imágenes seleccionadas contenía texto legible.';

  @override
  String get galleryError => 'Error de galería';

  @override
  String get unableToSelectProcessImage => 'No se pudo seleccionar o procesar la imagen.';

  @override
  String get textRecognitionError => 'Error de reconocimiento de texto';

  @override
  String get unableToReadText => 'No se pudo leer el texto de este documento.';

  @override
  String get noDocument => 'No hay documento';

  @override
  String get pleaseScanAtLeastOne => 'Escanea al menos un documento primero.';

  @override
  String get pdfError => 'Error de PDF';

  @override
  String get noValidDocumentImages => 'No se encontraron imágenes de documentos válidas.';

  @override
  String get unableToGeneratePdf => 'No se pudo generar el PDF.';

  @override
  String get scanPreview => 'Vista previa del escaneo';

  @override
  String get pages => 'Páginas';

  @override
  String get crop => 'Recortar';

  @override
  String get rotate => 'Girar';

  @override
  String get enhance => 'Mejorar';

  @override
  String get ocr => 'OCR';

  @override
  String get tapPageToPreview => 'Toca una página para verla';

  @override
  String get addPage => 'Añadir página';

  @override
  String get done => 'Listo';

  @override
  String get pageDeleted => 'Página eliminada';

  @override
  String pageRemoved(Object page) {
    return 'Se ha eliminado la página $page.';
  }

  @override
  String get deleteError => 'Error al eliminar';

  @override
  String get unableToDeletePage => 'No se pudo eliminar esta página.';

  @override
  String get enhanced => 'Mejorado';

  @override
  String get documentEnhancedPreservingColors => 'El documento se mejoró conservando sus colores.';

  @override
  String get enhanceError => 'Error al mejorar';

  @override
  String get unableToEnhanceDocument => 'No se pudo mejorar este documento.';

  @override
  String get rotated => 'Girado';

  @override
  String get documentRotatedSuccessfully => 'El documento se giró correctamente.';

  @override
  String get rotateError => 'Error al girar';

  @override
  String get unableToRotateDocument => 'No se pudo girar este documento.';

  @override
  String get cropComplete => 'Recorte completado';

  @override
  String get documentCroppedSuccessfully => 'El documento se recortó correctamente.';

  @override
  String get cropError => 'Error al recortar';

  @override
  String get unableToCropDocument => 'No se pudo recortar este documento.';

  @override
  String get couldNotFindReadableText => 'No pudimos encontrar texto legible en este documento.';

  @override
  String get unableToExtractText => 'No se pudo extraer el texto de este documento.';

  @override
  String get ocrError => 'Error de OCR';

  @override
  String get documentImageNotFound => 'No se pudo encontrar la imagen del documento.';

  @override
  String pageNumber(Object page) {
    return 'Página $page';
  }

  @override
  String get processing => 'Procesando...';

  @override
  String get noPages => 'No hay páginas';

  @override
  String get scanDocumentToSeeItHere => 'Escanea un documento para verlo aquí.';

  @override
  String get cannotDelete => 'No se puede eliminar';

  @override
  String get atLeastOnePageRequired => 'Se requiere al menos una página.';

  @override
  String get deletePageQuestion => '¿Eliminar página?';

  @override
  String get areYouSureRemovePage => '¿Estás seguro de que quieres eliminar esta página?';

  @override
  String get yourPdfIsReady => 'Tu PDF está listo.';

  @override
  String get documentSuccessfullyDigitized => 'Tu documento se ha digitalizado y optimizado\ncorrectamente.';

  @override
  String get opening => 'Abriendo...';

  @override
  String get sharePdf => 'Compartir PDF';

  @override
  String get saveToDevice => 'Guardar en el dispositivo';

  @override
  String get scanAnotherDocument => 'Escanear otro documento';

  @override
  String get pdfFileCouldNotBeFound => 'No se pudo encontrar el archivo PDF.';

  @override
  String get noPdfViewerAvailable => 'No hay ningún visor de PDF disponible en este dispositivo.';

  @override
  String get unableToOpenPdf => 'No se pudo abrir el PDF.';

  @override
  String get shareError => 'Error al compartir';

  @override
  String get unableToSharePdf => 'No se pudo compartir el PDF.';

  @override
  String get pdfCreatedWithAlignPdfAi => 'PDF creado con Align PDF AI';

  @override
  String get savePdf => 'Guardar PDF';

  @override
  String get pdfSaved => 'PDF guardado';

  @override
  String fileSavedSuccessfully(Object fileName) {
    return '$fileName se ha guardado correctamente.';
  }

  @override
  String get unableToSavePdf => 'No se pudo guardar el PDF.';

  @override
  String get scanAlignSimplify => 'Escanea. Alinea. Simplifica.';

  @override
  String get makingDocumentsSmarter => 'Hacemos tus documentos más inteligentes';

  @override
  String get noHistoryYet => 'Aún no hay historial';

  @override
  String get createdPdfsWillAppearHere => 'Los PDF que crees aparecerán aquí.';
}
