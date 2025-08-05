import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../model/save_address_model/request_body/save_address_req_body_model.dart';
import 'save_address_event.dart';
import 'save_address_state.dart';

class SaveAddressBloc extends Bloc<SaveAddressEvent, SaveAddressState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  SaveAddressBloc() : super(SaveAddressInitialState()) {
    on<SaveAddressValidationEvent>((event, emit) {
      if (event.nameController.isEmpty) {
        emit(SaveAddressErrorState("Please enter the name"));
      } else if (event.pinCodeController.isEmpty) {
        emit(SaveAddressErrorState("Please enter the Zip code"));
      } else if (event.cityController.isEmpty) {
        emit(SaveAddressErrorState("Please enter the city"));
      } else if (event.stateController.isEmpty) {
        emit(SaveAddressErrorState("Please enter the state"));
      } else if (event.countryController.isEmpty) {
        emit(SaveAddressErrorState("Please enter the country"));
      } else if (event.flatNoController.isEmpty) {
        emit(SaveAddressErrorState("Please enter the address line 1"));
      } else {
        emit(SaveAddressValidState());
      }
    });

    on<SaveAddressSubmittedEvent>((event, emit) async {
      emit(SaveAddressLoadingState());

      String uniqueId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      SaveAddressReqBodyModel reqBodyModel = SaveAddressReqBodyModel(
        name: event.nameController,
        house: AppStrings.emptyString,
        building: event.flatNoController,
        street: event.areaController,
        district: event.cityController,
        county: event.stateController,
        country: event.countryController,
        zipcode: event.pinCodeController,
        latitude: event.latitude,
        longitude: event.longitude,
        addressType: event.addressType,
        isDefault: event.isDefault,
        id: event.id,
      );

      ApiResponse<MessageStatusModel> response;
      if (event.customerUniqueId.isNotEmpty) {
        response = await appRepositoryValidation.updateAddress(
          id: uniqueId,
          reqBody: reqBodyModel,
        );
      } else {
        response = await appRepositoryValidation.saveAddress(
          id: uniqueId,
          reqBody: reqBodyModel,
        );
      }

      if (response.status == ApiResponseStatus.completed) {
        emit(SaveAddressCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(
            SaveAddressErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
