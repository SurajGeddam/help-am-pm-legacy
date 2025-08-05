import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_utils.dart';
import 'app_strings.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get defaultTextStyle {
    return TextStyle(
      fontFamily: AppStrings.roboto,
      fontSize: 14.fs,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
      letterSpacing: 0.75.fs,
    );
  }
}
