import 'package:flutter/material.dart';
import '../../utils/app_strings.dart';

class KeyValueModel {
  final String key;
  final String value;
  late bool isSelected;
  final String routeName;
  final String imageString;
  final Color bgColor;
  final String displayString;

  KeyValueModel({
    required this.key,
    this.value = AppStrings.emptyString,
    this.isSelected = false,
    this.routeName = AppStrings.emptyString,
    this.imageString = AppStrings.emptyString,
    this.bgColor = Colors.transparent,
    this.displayString = AppStrings.emptyString,
  });
}
