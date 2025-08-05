import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../model/common/policy_type_model.dart';

abstract class InsuranceState {}

class InsuranceInitialState extends InsuranceState {}

class InsuranceLoadingState extends InsuranceState {}

class InsuranceValidState extends InsuranceState {}

class InsuranceCompleteState extends InsuranceState {
  final String message;
  final Color bgColor;

  InsuranceCompleteState(this.message, {this.bgColor = AppColors.green});
}

class InsuranceErrorState extends InsuranceState {
  final String errorMessage;
  final Color bgColor;

  InsuranceErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}

class InsuranceDataLoadingState extends InsuranceState {}

class InsuranceDataLoadedState extends InsuranceState {
  final List<PolicyTypeModel> list;

  InsuranceDataLoadedState(this.list);
}
