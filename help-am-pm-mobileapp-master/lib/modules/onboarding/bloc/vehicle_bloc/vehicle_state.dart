import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../model/common/policy_type_model.dart';

abstract class VehicleState {}

class VehicleInitialState extends VehicleState {}

class VehicleLoadingState extends VehicleState {}

class VehicleValidState extends VehicleState {}

class VehicleCompleteState extends VehicleState {
  final String message;
  final Color bgColor;

  VehicleCompleteState(this.message, {this.bgColor = AppColors.green});
}

class VehicleErrorState extends VehicleState {
  final String errorMessage;
  final Color bgColor;

  VehicleErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}

class VehicleDataLoadingState extends VehicleState {}

class VehicleDataLoadedState extends VehicleState {
  final List<PolicyTypeModel> list;

  VehicleDataLoadedState(this.list);
}
