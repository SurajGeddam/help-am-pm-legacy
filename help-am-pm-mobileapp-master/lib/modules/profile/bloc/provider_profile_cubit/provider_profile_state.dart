import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../model/provider_profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileModel providerProfile;
  ProfileLoadedState(this.providerProfile);
}

class ProfileErrorState extends ProfileState {
  final String errorMessage;
  final Color bgColor;

  ProfileErrorState(this.errorMessage, {this.bgColor = AppColors.red});
}
