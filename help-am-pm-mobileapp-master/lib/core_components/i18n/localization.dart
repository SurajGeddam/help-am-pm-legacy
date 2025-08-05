import 'package:flutter/cupertino.dart';

import '../../utils/app_strings.dart';
import 'en.dart';
import 'es.dart';
import 'language_codes.dart';

class Localization {
  final Locale locale;
  bool isTest;
  late Map<String, String> _localizedValues;

  Localization(this.locale, {this.isTest = false});

  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  Future<Localization> loadTest(Locale locale) async {
    return Localization(locale);
  }

  Future<void> load() async {
    if (locale.languageCode == LanguageCodes.english.code) {
      _localizedValues = i18nEn;
    } else {
      _localizedValues = i18nEs;
    }
  }

  String? translate(String? key) {
    if (isTest) return key;

    if (key == null) {
      return AppStrings.threeDots;
    }
    if (!_localizedValues.containsKey(key)) {
      return key;
    }
    return _localizedValues[key];
  }

  // static member to have simple access to the delegate from Material App
  static LocalizationsDelegate<Localization> delegate =
      _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  final bool isTest = false;

  @override
  bool isSupported(Locale locale) {
    return [
      LanguageCodes.english.code,
      LanguageCodes.spanish.code,
    ].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) async {
    Localization localizations = Localization(locale, isTest: isTest);
    if (isTest) {
      await localizations.loadTest(locale);
    } else {
      await localizations.load();
    }
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Localization> old) => false;
}
