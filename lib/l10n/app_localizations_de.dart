// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get setting => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get changeAppLanguage => 'App-Sprache ändern';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get readOurPrivacyPolicy => 'Lesen Sie unsere Datenschutzerklärung';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get readOurTermsOfService => 'Lesen Sie unsere Nutzungsbedingungen';

  @override
  String get helpSupport => 'Hilfe & Support';

  @override
  String get getHelpWithAlignPdfAi => 'Hilfe für Align PDF AI erhalten';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get shareYourFeedback => 'Teilen Sie Ihr Feedback';

  @override
  String get error => 'Fehler';

  @override
  String get invalidUrl => 'Ungültige URL.';

  @override
  String get unableToOpenLink => 'Dieser Link konnte nicht geöffnet werden.';

  @override
  String get renamePdf => 'PDF umbenennen';

  @override
  String get pdfName => 'PDF-Name';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get deletePdf => 'PDF löschen';

  @override
  String get areYouSureDeletePdf => 'Möchten Sie diese PDF wirklich löschen?';

  @override
  String get delete => 'Löschen';

  @override
  String get openPdf => 'PDF öffnen';

  @override
  String get share => 'Teilen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get noRecentDocuments => 'Keine aktuellen Dokumente';

  @override
  String get createFirstPdfToSeeItHere => 'Erstellen Sie Ihr erstes PDF, damit es hier angezeigt wird';

  @override
  String get recentDocuments => 'Zuletzt verwendete Dokumente';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get scanDocument => 'Dokument scannen';

  @override
  String get captureDocumentWithAi => 'Dokument mit KI erfassen';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get fileNotFound => 'Datei nicht gefunden';

  @override
  String get thisPdfIsNoLongerAvailable => 'Dieses PDF ist nicht mehr verfügbar.';

  @override
  String get unableToOpen => 'Öffnen nicht möglich';

  @override
  String get placeDocumentWithinFrame => 'Platzieren Sie Ihr Dokument innerhalb des Rahmens';

  @override
  String get flash => 'Blitz';

  @override
  String get on => 'Ein';

  @override
  String get off => 'Aus';

  @override
  String get documentDetected => 'Dokument erkannt';

  @override
  String get keepSteadyAvoidShadows => 'Halten Sie das Gerät ruhig und vermeiden Sie Schatten';

  @override
  String get gallery => 'Galerie';

  @override
  String get multiPage => 'Mehrseitig';

  @override
  String get processingDocument => 'Dokument wird verarbeitet...';

  @override
  String get extractingTextWithAi => 'Text wird mit KI extrahiert';

  @override
  String get cameraError => 'Kamerafehler';

  @override
  String get noCameraFound => 'Auf diesem Gerät wurde keine Kamera gefunden.';

  @override
  String get unableToInitializeCamera => 'Die Kamera konnte nicht initialisiert werden.';

  @override
  String get noTextFound => 'Kein Text gefunden';

  @override
  String get couldntFindText => 'Wir konnten in diesem Dokument keinen Text finden. Bitte scannen Sie erneut.';

  @override
  String get scanError => 'Scanfehler';

  @override
  String get somethingWentWrongScanning => 'Beim Scannen des Dokuments ist ein Fehler aufgetreten.';

  @override
  String get noDocumentsFound => 'Keine Dokumente gefunden';

  @override
  String get noneSelectedImagesReadable => 'Keine der ausgewählten Bilder enthielt lesbaren Text.';

  @override
  String get galleryError => 'Galeriefehler';

  @override
  String get unableToSelectProcessImage => 'Das Bild konnte nicht ausgewählt oder verarbeitet werden.';

  @override
  String get textRecognitionError => 'Fehler bei der Texterkennung';

  @override
  String get unableToReadText => 'Der Text dieses Dokuments konnte nicht gelesen werden.';

  @override
  String get noDocument => 'Kein Dokument';

  @override
  String get pleaseScanAtLeastOne => 'Bitte scannen Sie zuerst mindestens ein Dokument.';

  @override
  String get pdfError => 'PDF-Fehler';

  @override
  String get noValidDocumentImages => 'Es wurden keine gültigen Dokumentbilder gefunden.';

  @override
  String get unableToGeneratePdf => 'Das PDF konnte nicht erstellt werden.';

  @override
  String get scanPreview => 'Scan-Vorschau';

  @override
  String get pages => 'Seiten';

  @override
  String get crop => 'Zuschneiden';

  @override
  String get rotate => 'Drehen';

  @override
  String get enhance => 'Verbessern';

  @override
  String get ocr => 'OCR';

  @override
  String get tapPageToPreview => 'Tippen Sie auf eine Seite, um sie anzuzeigen';

  @override
  String get addPage => 'Seite hinzufügen';

  @override
  String get done => 'Fertig';

  @override
  String get pageDeleted => 'Seite gelöscht';

  @override
  String pageRemoved(Object page) {
    return 'Seite $page wurde entfernt.';
  }

  @override
  String get deleteError => 'Fehler beim Löschen';

  @override
  String get unableToDeletePage => 'Diese Seite konnte nicht gelöscht werden.';

  @override
  String get enhanced => 'Verbessert';

  @override
  String get documentEnhancedPreservingColors => 'Das Dokument wurde verbessert und die Farben beibehalten.';

  @override
  String get enhanceError => 'Fehler beim Verbessern';

  @override
  String get unableToEnhanceDocument => 'Dieses Dokument konnte nicht verbessert werden.';

  @override
  String get rotated => 'Gedreht';

  @override
  String get documentRotatedSuccessfully => 'Das Dokument wurde erfolgreich gedreht.';

  @override
  String get rotateError => 'Fehler beim Drehen';

  @override
  String get unableToRotateDocument => 'Dieses Dokument konnte nicht gedreht werden.';

  @override
  String get cropComplete => 'Zuschneiden abgeschlossen';

  @override
  String get documentCroppedSuccessfully => 'Das Dokument wurde erfolgreich zugeschnitten.';

  @override
  String get cropError => 'Fehler beim Zuschneiden';

  @override
  String get unableToCropDocument => 'Dieses Dokument konnte nicht zugeschnitten werden.';

  @override
  String get couldNotFindReadableText => 'Wir konnten in diesem Dokument keinen lesbaren Text finden.';

  @override
  String get unableToExtractText => 'Der Text konnte nicht aus diesem Dokument extrahiert werden.';

  @override
  String get ocrError => 'OCR-Fehler';

  @override
  String get documentImageNotFound => 'Das Dokumentbild konnte nicht gefunden werden.';

  @override
  String pageNumber(Object page) {
    return 'Seite $page';
  }

  @override
  String get processing => 'Wird verarbeitet...';

  @override
  String get noPages => 'Keine Seiten';

  @override
  String get scanDocumentToSeeItHere => 'Scannen Sie ein Dokument, um es hier zu sehen.';

  @override
  String get cannotDelete => 'Löschen nicht möglich';

  @override
  String get atLeastOnePageRequired => 'Mindestens eine Seite ist erforderlich.';

  @override
  String get deletePageQuestion => 'Seite löschen?';

  @override
  String get areYouSureRemovePage => 'Möchten Sie diese Seite wirklich entfernen?';

  @override
  String get yourPdfIsReady => 'Ihr PDF ist bereit.';

  @override
  String get documentSuccessfullyDigitized => 'Ihr Dokument wurde erfolgreich digitalisiert\nund optimiert.';

  @override
  String get opening => 'Wird geöffnet...';

  @override
  String get sharePdf => 'PDF teilen';

  @override
  String get saveToDevice => 'Auf Gerät speichern';

  @override
  String get scanAnotherDocument => 'Weiteres Dokument scannen';

  @override
  String get pdfFileCouldNotBeFound => 'Die PDF-Datei konnte nicht gefunden werden.';

  @override
  String get noPdfViewerAvailable => 'Auf diesem Gerät ist kein PDF-Viewer verfügbar.';

  @override
  String get unableToOpenPdf => 'Das PDF konnte nicht geöffnet werden.';

  @override
  String get shareError => 'Fehler beim Teilen';

  @override
  String get unableToSharePdf => 'Das PDF konnte nicht geteilt werden.';

  @override
  String get pdfCreatedWithAlignPdfAi => 'PDF mit Align PDF AI erstellt';

  @override
  String get savePdf => 'PDF speichern';

  @override
  String get pdfSaved => 'PDF gespeichert';

  @override
  String fileSavedSuccessfully(Object fileName) {
    return '$fileName wurde erfolgreich gespeichert.';
  }

  @override
  String get unableToSavePdf => 'Das PDF konnte nicht gespeichert werden.';

  @override
  String get scanAlignSimplify => 'Scannen. Ausrichten. Vereinfachen.';

  @override
  String get makingDocumentsSmarter => 'Dokumente intelligenter machen';

  @override
  String get noHistoryYet => 'Noch kein Verlauf';

  @override
  String get createdPdfsWillAppearHere => 'Ihre erstellten PDFs werden hier angezeigt.';
}
