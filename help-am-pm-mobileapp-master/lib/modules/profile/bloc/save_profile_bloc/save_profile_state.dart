import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class SaveProfileState {}

class SaveProfileInitialState extends SaveProfileState {}

class SaveProfileLoadingState extends SaveProfileState {}

class SaveProfileValidState extends SaveProfileState {}

class SaveProfileCompleteState extends SaveProfileState {
  final String message;
  final Color bgColor;

  SaveProfileCompleteState(this.message, {this.bgColor = AppColors.green});
}

class SaveProfileErrorState extends SaveProfileState {
  final String errorMessage;
  final Color bgColor;

  SaveProfileErrorState(this.errorMessage, {this.bgColor = AppColors.red});
}
