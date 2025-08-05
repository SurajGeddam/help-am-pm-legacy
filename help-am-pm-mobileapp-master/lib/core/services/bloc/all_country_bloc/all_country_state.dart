import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../model/country_code_model.dart';

abstract class GetAllCountryCodeState {}

class GetAllCountryCodeInitialState extends GetAllCountryCodeState {}

class GetAllCountryCodeLoadingState extends GetAllCountryCodeState {}

class GetAllCountryCodeLoadedState extends GetAllCountryCodeState {
  final List<CountryCodeModel> list;

  GetAllCountryCodeLoadedState({required this.list});
}

class GetAllCountryCodeErrorState extends GetAllCountryCodeState {
  final String errorMessage;
  final Color bgColor;

  GetAllCountryCodeErrorState(this.errorMessage,
      {this.bgColor = AppColors.black});
}
