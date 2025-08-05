import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/profile/bloc/save_profile_bloc/save_profile_event.dart';
import 'package:helpampm/modules/profile/bloc/save_profile_bloc/save_profile_state.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../model/provider_profile_model.dart';

class SaveProfileBloc extends Bloc<SaveProfileEvent, SaveProfileState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  SaveProfileBloc() : super(SaveProfileInitialState()) {
    on<SaveCustomerProfileValidationEvent>((event, emit) {
      if (event.firstNameController.isEmpty) {
        emit(SaveProfileErrorState("Please enter first name"));
      } else if (event.lastNameController.isEmpty) {
        emit(SaveProfileErrorState("Please enter last name"));
      } else if (event.mobileNumberController.isEmpty) {
        emit(SaveProfileErrorState("Please enter the mobile number"));
      } else {
        emit(SaveProfileValidState());
      }
    });

    on<SaveProviderProfileValidationEvent>((event, emit) {
      if (event.nameController.isEmpty) {
        emit(SaveProfileErrorState("Please enter name"));
      } else if (event.mobileNumberController.isEmpty) {
        emit(SaveProfileErrorState("Please enter the mobile number"));
      } else {
        emit(SaveProfileValidState());
      }
    });

    on<SaveCustomerProfileSubmittedEvent>((event, emit) async {
      emit(SaveProfileLoadingState());
      String uniqueId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      ProfileModel profileModel = ProfileModel(
        profilePicture: event.profilePicturePath,
        firstName: event.firstNameController,
        lastName: event.lastNameController,
        email: event.emailController,
        mobileNumber: event.mobileNumberController,
      );

      ApiResponse<MessageStatusModel> response =
          await appRepositoryValidation.updateCustomerProfile(
        customerUniqueId: uniqueId,
        profileModel: profileModel,
      );

      if (response.status == ApiResponseStatus.completed) {
        emit(SaveProfileCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(
            SaveProfileErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
    on<SaveProviderProfileSubmittedEvent>((event, emit) async {
      emit(SaveProfileLoadingState());
      String uniqueId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      ProfileModel profileModel = ProfileModel(
        profilePicture: event.profilePicturePath,
        name: event.nameController,
        email: event.emailController,
        mobileNumber: event.mobileNumberController,
      );

      ApiResponse<MessageStatusModel> response =
          await appRepositoryValidation.updateProviderProfile(
        providerUniqueId: uniqueId,
        profileModel: profileModel,
      );

      if (response.status == ApiResponseStatus.completed) {
        emit(SaveProfileCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(
            SaveProfileErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
