import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../model/company_details_model/save_company_detail_req_body_model.dart';
import 'individual_event.dart';
import 'individual_state.dart';

class IndividualBloc extends Bloc<IndividualEvent, IndividualState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  IndividualBloc() : super(IndividualInitialState()) {
    on<IndividualValidationEvent>((event, emit) {
      if (event.companyEmailEditingController.isEmpty) {
        emit(IndividualErrorState("Please enter the company email address"));
      } else if (event.companyNameEditingController.isEmpty) {
        emit(IndividualErrorState("Please enter the company name"));
      } else if (event.companyPhoneEditingController.isEmpty) {
        emit(IndividualErrorState("Please enter the company phone number"));
      } else if (event.flatNoController.isEmpty) {
        emit(IndividualErrorState("Please enter the address line 1"));
      } else if (event.cityController.isEmpty) {
        emit(IndividualErrorState("Please enter the city"));
      } else if (event.stateController.isEmpty) {
        emit(IndividualErrorState("Please enter the state"));
      } else if (event.countryController.isEmpty) {
        emit(IndividualErrorState("Please enter the country"));
      } else if (event.pinCodeController.isEmpty) {
        emit(IndividualErrorState("Please enter the Zip code"));
      } else if (EmailValidator.validate(event.companyEmailEditingController) ==
          false) {
        emit(IndividualErrorState("Please enter a valid email address",
            bgColor: AppColors.red));
      } else {
        emit(IndividualValidState());
      }
    });

    on<IndividualSubmittedEvent>((event, emit) async {
      emit(IndividualLoadingState());

      SaveCompanyDetailReqBodyModel sendObj = SaveCompanyDetailReqBodyModel(
        companyName: event.companyNameEditingController,
        companyPhone: event.companyPhoneEditingController,
        companyEmail: event.companyEmailEditingController,
        companyWebsite: event.companyWebsiteEditingController,
        address: Address(
          building: event.flatNoController,
          street: event.areaController,
          county: event.stateController,
          district: event.cityController,
          country: event.countryController,
          zipcode: event.pinCodeController,
          latitude: event.latitude,
          longitude: event.longitude,
          altitude: event.altitude,
        ),
      );
      String providerId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      ApiResponse<MessageStatusModel> response = await appRepositoryValidation
          .saveIndividual(obj: sendObj, id: providerId);
      if (response.status == ApiResponseStatus.completed) {
        emit(IndividualCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(IndividualErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
