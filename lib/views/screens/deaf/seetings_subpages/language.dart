import 'dart:ui';

import 'package:flutter/material.dart';

class LanguageManager {
  static final Map<String, Locale> _supportedLanguages = {
    'English': Locale('en', 'US'),
    'Spanish': Locale('es', 'ES'),
    'French': Locale('fr', 'FR'),
    'German': Locale('de', 'DE'),
    'Chinese': Locale('zh', 'CN'),
    'Arabic': Locale('ar', 'SA'),
  };

  static void changeLanguage(BuildContext context, String languageCode) {
    final locale = _supportedLanguages[languageCode];
    if (locale != null) {
      // Use a localization delegate to update app language
      // This would typically involve using flutter_localizations package
      // AppLocalizations.delegate.load(locale)
    }
  }
}