import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../model/common/policy_type_model.dart';

abstract class LicenseState {}

class LicenseInitialState extends LicenseState {}

class LicenseLoadingState extends LicenseState {}

class LicenseValidState extends LicenseState {}

class LicenseCompleteState extends LicenseState {
  final String message;
  final Color bgColor;

  LicenseCompleteState(this.message, {this.bgColor = AppColors.green});
}

class LicenseErrorState extends LicenseState {
  final String errorMessage;
  final Color bgColor;

  LicenseErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}

class LicenseDataLoadingState extends LicenseState {}

class LicenseDataLoadedState extends LicenseState {
  final List<PolicyTypeModel> list;

  LicenseDataLoadedState(this.list);
}
