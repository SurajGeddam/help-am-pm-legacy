import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/profile/bloc/provider_profile_cubit/provider_profile_state.dart';
import 'package:helpampm/modules/profile/model/provider_profile_model.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_utils.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchProfile() async {
    emit(ProfileLoadingState());
    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<ProfileModel> response;
    if (AppUtils.getIsRoleCustomer()) {
      response = await appRepositoryValidation.getCustomerProfile(
          customerUniqueId: uniqueId);
    } else {
      response = await appRepositoryValidation.getProviderProfile(
          providerUniqueId: uniqueId);
    }
    if (response.status == ApiResponseStatus.completed) {
      ProfileModel? providerProfile = response.data;
      if (providerProfile != null) {
        emit(ProfileLoadedState(providerProfile));
      } else {
        emit(ProfileErrorState(response.messageKey, bgColor: AppColors.red));
      }
    } else {
      emit(ProfileErrorState(response.messageKey));
    }
  }

  /*void fetchProviderProfile() async {
    emit(ProfileLoadingState());
    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<ProfileModel> response = await appRepositoryValidation
        .getProviderProfile(providerUniqueId: uniqueId);
    if (response.status == ApiResponseStatus.completed) {
      ProfileModel? providerProfile = response.data;
      if (providerProfile != null) {
        emit(ProfileLoadedState(providerProfile));
      } else {
        emit(ProfileErrorState(response.messageKey, bgColor: AppColors.red));
      }
    } else {
      emit(ProfileErrorState(response.messageKey));
    }
  }

  void fetchCustomerProfile() async {
    emit(ProfileLoadingState());
    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);
    ApiResponse<ProfileModel> response = await appRepositoryValidation
        .getCustomerProfile(customerUniqueId: uniqueId);
    if (response.status == ApiResponseStatus.completed) {
      ProfileModel? customerProfile = response.data;
      if (customerProfile != null) {
        emit(ProfileLoadedState(customerProfile));
      } else {
        emit(ProfileErrorState(response.messageKey, bgColor: AppColors.red));
      }
    } else {
      emit(ProfileErrorState(response.messageKey));
    }
  }*/
}
