import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class EnterOtpState {}

class EnterOtpInitialState extends EnterOtpState {}

class EnterOtpLoadingState extends EnterOtpState {}

class EnterOtpValidState extends EnterOtpState {}

class EnterOtpCompleteState extends EnterOtpState {}

class ResendOtpCompleteState extends EnterOtpState {
  final String systemOtp;
  ResendOtpCompleteState(this.systemOtp);
}

class EnterOtpErrorState extends EnterOtpState {
  final String errorMessage;
  final Color bgColor;

  EnterOtpErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
