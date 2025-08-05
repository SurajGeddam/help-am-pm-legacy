import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class CreatePasswordState {}

class CreatePasswordInitialState extends CreatePasswordState {}

class CreatePasswordLoadingState extends CreatePasswordState {}

class CreatePasswordValidState extends CreatePasswordState {}

class CreatePasswordCompleteState extends CreatePasswordState {}

class CreatePasswordErrorState extends CreatePasswordState {
  final String errorMessage;
  final Color bgColor;

  CreatePasswordErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
