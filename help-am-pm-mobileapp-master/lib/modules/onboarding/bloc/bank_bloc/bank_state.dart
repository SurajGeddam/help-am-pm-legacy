import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class BankState {}

class BankInitialState extends BankState {}

class BankLoadingState extends BankState {}

class BankValidState extends BankState {}

class BankCompleteState extends BankState {
  final String message;
  final Color bgColor;

  BankCompleteState(this.message, {this.bgColor = AppColors.green});
}

class BankErrorState extends BankState {
  final String errorMessage;
  final Color bgColor;

  BankErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
