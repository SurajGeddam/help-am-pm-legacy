import 'package:flutter/material.dart';
import '../../utils/app_strings.dart';
import 'language_codes.dart';
import 'localization.dart';

Future<Locale> setLocale(LanguageCodes? languageCode) async {
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  // To get English as default whenever app launches
  return _locale(LanguageCodes.english);
}

Locale _locale(LanguageCodes? languageCode) {
  switch (languageCode) {
    case LanguageCodes.english:
      return Locale(
          LanguageCodes.english.code, LanguageCodes.english.countryCode);
    default:
      return Locale(
          LanguageCodes.english.code, LanguageCodes.english.countryCode);
  }
}

// Please use safeTranslate(key) from Localization.
String getTranslated(BuildContext context, String? key) {
  return Localization.of(context)?.translate(key) ?? AppStrings.emptyString;
}
