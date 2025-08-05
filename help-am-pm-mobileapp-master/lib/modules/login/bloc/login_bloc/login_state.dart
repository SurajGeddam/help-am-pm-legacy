import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginValidState extends LoginState {}

class LoginCompleteState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMessage;
  final Color bgColor;

  LoginErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
