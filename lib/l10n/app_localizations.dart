import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeAppLanguage;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readOurPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readOurPrivacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @readOurTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get readOurTermsOfService;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @getHelpWithAlignPdfAi.
  ///
  /// In en, this message translates to:
  /// **'Get help with Align PDF AI'**
  String get getHelpWithAlignPdfAi;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback'**
  String get shareYourFeedback;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL.'**
  String get invalidUrl;

  /// No description provided for @unableToOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this link.'**
  String get unableToOpenLink;

  /// No description provided for @renamePdf.
  ///
  /// In en, this message translates to:
  /// **'Rename PDF'**
  String get renamePdf;

  /// No description provided for @pdfName.
  ///
  /// In en, this message translates to:
  /// **'PDF name'**
  String get pdfName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deletePdf.
  ///
  /// In en, this message translates to:
  /// **'Delete PDF'**
  String get deletePdf;

  /// No description provided for @areYouSureDeletePdf.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this PDF?'**
  String get areYouSureDeletePdf;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @openPdf.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get openPdf;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @noRecentDocuments.
  ///
  /// In en, this message translates to:
  /// **'No recent documents'**
  String get noRecentDocuments;

  /// No description provided for @createFirstPdfToSeeItHere.
  ///
  /// In en, this message translates to:
  /// **'Create your first PDF to see it here'**
  String get createFirstPdfToSeeItHere;

  /// No description provided for @recentDocuments.
  ///
  /// In en, this message translates to:
  /// **'Recent Documents'**
  String get recentDocuments;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// No description provided for @captureDocumentWithAi.
  ///
  /// In en, this message translates to:
  /// **'Capture a document with AI'**
  String get captureDocumentWithAi;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File Not Found'**
  String get fileNotFound;

  /// No description provided for @thisPdfIsNoLongerAvailable.
  ///
  /// In en, this message translates to:
  /// **'This PDF is no longer available.'**
  String get thisPdfIsNoLongerAvailable;

  /// No description provided for @unableToOpen.
  ///
  /// In en, this message translates to:
  /// **'Unable to Open'**
  String get unableToOpen;

  /// No description provided for @placeDocumentWithinFrame.
  ///
  /// In en, this message translates to:
  /// **'Place your document within the frame'**
  String get placeDocumentWithinFrame;

  /// No description provided for @flash.
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get flash;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @documentDetected.
  ///
  /// In en, this message translates to:
  /// **'Document detected'**
  String get documentDetected;

  /// No description provided for @keepSteadyAvoidShadows.
  ///
  /// In en, this message translates to:
  /// **'Keep steady and avoid shadows'**
  String get keepSteadyAvoidShadows;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @multiPage.
  ///
  /// In en, this message translates to:
  /// **'Multi-Page'**
  String get multiPage;

  /// No description provided for @processingDocument.
  ///
  /// In en, this message translates to:
  /// **'Processing document...'**
  String get processingDocument;

  /// No description provided for @extractingTextWithAi.
  ///
  /// In en, this message translates to:
  /// **'Extracting text with AI'**
  String get extractingTextWithAi;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera Error'**
  String get cameraError;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera was found on this device.'**
  String get noCameraFound;

  /// No description provided for @unableToInitializeCamera.
  ///
  /// In en, this message translates to:
  /// **'Unable to initialize camera.'**
  String get unableToInitializeCamera;

  /// No description provided for @noTextFound.
  ///
  /// In en, this message translates to:
  /// **'No Text Found'**
  String get noTextFound;

  /// No description provided for @couldntFindText.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any text in this document. Please scan again.'**
  String get couldntFindText;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan Error'**
  String get scanError;

  /// No description provided for @somethingWentWrongScanning.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while scanning the document.'**
  String get somethingWentWrongScanning;

  /// No description provided for @noDocumentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Documents Found'**
  String get noDocumentsFound;

  /// No description provided for @noneSelectedImagesReadable.
  ///
  /// In en, this message translates to:
  /// **'None of the selected images contained readable text.'**
  String get noneSelectedImagesReadable;

  /// No description provided for @galleryError.
  ///
  /// In en, this message translates to:
  /// **'Gallery Error'**
  String get galleryError;

  /// No description provided for @unableToSelectProcessImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to select or process the image.'**
  String get unableToSelectProcessImage;

  /// No description provided for @textRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Text Recognition Error'**
  String get textRecognitionError;

  /// No description provided for @unableToReadText.
  ///
  /// In en, this message translates to:
  /// **'Unable to read text from this document.'**
  String get unableToReadText;

  /// No description provided for @noDocument.
  ///
  /// In en, this message translates to:
  /// **'No Document'**
  String get noDocument;

  /// No description provided for @pleaseScanAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please scan at least one document first.'**
  String get pleaseScanAtLeastOne;

  /// No description provided for @pdfError.
  ///
  /// In en, this message translates to:
  /// **'PDF Error'**
  String get pdfError;

  /// No description provided for @noValidDocumentImages.
  ///
  /// In en, this message translates to:
  /// **'No valid document images were found.'**
  String get noValidDocumentImages;

  /// No description provided for @unableToGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate PDF.'**
  String get unableToGeneratePdf;

  /// No description provided for @scanPreview.
  ///
  /// In en, this message translates to:
  /// **'Scan Preview'**
  String get scanPreview;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// No description provided for @enhance.
  ///
  /// In en, this message translates to:
  /// **'Enhance'**
  String get enhance;

  /// No description provided for @ocr.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get ocr;

  /// No description provided for @tapPageToPreview.
  ///
  /// In en, this message translates to:
  /// **'Tap a page to preview'**
  String get tapPageToPreview;

  /// No description provided for @addPage.
  ///
  /// In en, this message translates to:
  /// **'Add Page'**
  String get addPage;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @pageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Page Deleted'**
  String get pageDeleted;

  /// No description provided for @pageRemoved.
  ///
  /// In en, this message translates to:
  /// **'Page {page} has been removed.'**
  String pageRemoved(Object page);

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'Delete Error'**
  String get deleteError;

  /// No description provided for @unableToDeletePage.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete this page.'**
  String get unableToDeletePage;

  /// No description provided for @enhanced.
  ///
  /// In en, this message translates to:
  /// **'Enhanced'**
  String get enhanced;

  /// No description provided for @documentEnhancedPreservingColors.
  ///
  /// In en, this message translates to:
  /// **'Document enhanced while preserving colors.'**
  String get documentEnhancedPreservingColors;

  /// No description provided for @enhanceError.
  ///
  /// In en, this message translates to:
  /// **'Enhance Error'**
  String get enhanceError;

  /// No description provided for @unableToEnhanceDocument.
  ///
  /// In en, this message translates to:
  /// **'Unable to enhance this document.'**
  String get unableToEnhanceDocument;

  /// No description provided for @rotated.
  ///
  /// In en, this message translates to:
  /// **'Rotated'**
  String get rotated;

  /// No description provided for @documentRotatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document rotated successfully.'**
  String get documentRotatedSuccessfully;

  /// No description provided for @rotateError.
  ///
  /// In en, this message translates to:
  /// **'Rotate Error'**
  String get rotateError;

  /// No description provided for @unableToRotateDocument.
  ///
  /// In en, this message translates to:
  /// **'Unable to rotate this document.'**
  String get unableToRotateDocument;

  /// No description provided for @cropComplete.
  ///
  /// In en, this message translates to:
  /// **'Crop Complete'**
  String get cropComplete;

  /// No description provided for @documentCroppedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document cropped successfully.'**
  String get documentCroppedSuccessfully;

  /// No description provided for @cropError.
  ///
  /// In en, this message translates to:
  /// **'Crop Error'**
  String get cropError;

  /// No description provided for @unableToCropDocument.
  ///
  /// In en, this message translates to:
  /// **'Unable to crop this document.'**
  String get unableToCropDocument;

  /// No description provided for @couldNotFindReadableText.
  ///
  /// In en, this message translates to:
  /// **'We could not find readable text in this document.'**
  String get couldNotFindReadableText;

  /// No description provided for @unableToExtractText.
  ///
  /// In en, this message translates to:
  /// **'Unable to extract text from this document.'**
  String get unableToExtractText;

  /// No description provided for @ocrError.
  ///
  /// In en, this message translates to:
  /// **'OCR Error'**
  String get ocrError;

  /// No description provided for @documentImageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Document image could not be found.'**
  String get documentImageNotFound;

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pageNumber(Object page);

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @noPages.
  ///
  /// In en, this message translates to:
  /// **'No Pages'**
  String get noPages;

  /// No description provided for @scanDocumentToSeeItHere.
  ///
  /// In en, this message translates to:
  /// **'Scan a document to see it here.'**
  String get scanDocumentToSeeItHere;

  /// No description provided for @cannotDelete.
  ///
  /// In en, this message translates to:
  /// **'Cannot Delete'**
  String get cannotDelete;

  /// No description provided for @atLeastOnePageRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one page is required.'**
  String get atLeastOnePageRequired;

  /// No description provided for @deletePageQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Page?'**
  String get deletePageQuestion;

  /// No description provided for @areYouSureRemovePage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this page?'**
  String get areYouSureRemovePage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'he': return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
