import 'package:align_pdf_ai/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
