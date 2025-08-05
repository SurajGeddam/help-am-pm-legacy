import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class SaveAddressState {}

class SaveAddressInitialState extends SaveAddressState {}

class SaveAddressLoadingState extends SaveAddressState {}

class SaveAddressValidState extends SaveAddressState {}

class SaveAddressCompleteState extends SaveAddressState {
  final String message;
  final Color bgColor;

  SaveAddressCompleteState(this.message, {this.bgColor = AppColors.green});
}

class SaveAddressErrorState extends SaveAddressState {
  final String errorMessage;
  final Color bgColor;

  SaveAddressErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
