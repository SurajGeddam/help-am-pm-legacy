import 'dart:ui';

import 'package:intl/intl.dart';

import 'app_strings.dart';

class AppHelpers {
  AppHelpers._();

  /// Get 13 March 2022
  static String convertDateInDDMMYYYY(DateTime date) {
    final DateTime now = date;
    final DateFormat formatter = DateFormat('d MMMM y');
    final String outputDate = formatter.format(now);
    return outputDate;
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor
        .toUpperCase()
        .replaceAll(AppStrings.hashSign, AppStrings.emptyString);
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }
}
