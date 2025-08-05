import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordValidState extends ForgotPasswordState {}

class ForgotPasswordCompleteState extends ForgotPasswordState {
  final String userId;
  final String systemOtp;
  ForgotPasswordCompleteState(this.userId, this.systemOtp);
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String errorMessage;
  final Color bgColor;

  ForgotPasswordErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
