import 'package:helpampm/utils/app_constant.dart';

enum LanguageCodes { english, spanish }

extension LanguageCodeExtension on LanguageCodes {
  String get code {
    switch (this) {
      case LanguageCodes.english:
        return _en;
      case LanguageCodes.spanish:
        return _es;
    }
  }

  String get countryCode {
    switch (this) {
      case LanguageCodes.english:
        return _enCountryCode;
      case LanguageCodes.spanish:
        return _esCountryCode;
    }
  }
}

const String _en = AppConstants.enLangCode;
const String _enCountryCode = AppConstants.usCountryCode;

const String _es = AppConstants.esLangCode;
const String _esCountryCode = AppConstants.esCountryCode;
