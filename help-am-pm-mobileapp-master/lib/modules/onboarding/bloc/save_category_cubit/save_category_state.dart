import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class SaveCategoryState {}

class SaveCategoryLoadingState extends SaveCategoryState {}

class SaveCategoryLoadedState extends SaveCategoryState {
  final String message;
  final Color bgColor;

  SaveCategoryLoadedState(this.message, {this.bgColor = AppColors.green});
}

class SaveCategoryErrorState extends SaveCategoryState {
  final String errorMessage;
  SaveCategoryErrorState(this.errorMessage);
}
