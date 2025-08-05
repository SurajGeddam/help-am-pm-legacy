import 'dart:ui';

import 'package:helpampm/utils/app_strings.dart';

import '../../../utils/app_colors.dart';
import '../../login/model/login_model/auth_token_model.dart';

abstract class UserDtoState {}

class UserDtoInitialState extends UserDtoState {}

class UserDtoLoadingState extends UserDtoState {}

class UserDtoLoadedState extends UserDtoState {
  final UserDetailsDto userDetailsDto;
  final String message;
  final Color bgColor;

  UserDtoLoadedState(this.userDetailsDto,
      {this.message = AppStrings.emptyString, this.bgColor = AppColors.green});
}

class UserDtoErrorState extends UserDtoState {
  final String errorMessage;
  final Color bgColor;

  UserDtoErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
