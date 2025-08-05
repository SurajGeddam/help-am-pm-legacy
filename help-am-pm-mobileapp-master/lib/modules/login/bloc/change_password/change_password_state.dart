import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ChangePasswordState {}

class ChangePasswordInitialState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordValidState extends ChangePasswordState {}

class ChangePasswordCompleteState extends ChangePasswordState {}

class ChangePasswordErrorState extends ChangePasswordState {
  final String errorMessage;
  final Color bgColor;

  ChangePasswordErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
