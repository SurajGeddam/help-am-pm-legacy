import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterValidState extends RegisterState {}

class RegisterCompleteState extends RegisterState {
  final String message;
  final Color bgColor;

  RegisterCompleteState(this.message, {this.bgColor = AppColors.green});
}

class RegisterErrorState extends RegisterState {
  final String errorMessage;
  final Color bgColor;

  RegisterErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
