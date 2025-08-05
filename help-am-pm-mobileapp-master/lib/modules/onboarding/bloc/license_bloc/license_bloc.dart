import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../model/common/policy_type_model.dart';
import '../../model/license_model/save_license_req_boy_model.dart';
import 'license_event.dart';
import 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  LicenseBloc() : super(LicenseInitialState()) {
    on<LicenseGetDataEvent>((event, emit) async {
      emit(LicenseDataLoadingState());

      ApiResponse<List<PolicyTypeModel>> response =
          await appRepositoryValidation.getLicenseType();
      if (response.status == ApiResponseStatus.completed) {
        emit(LicenseDataLoadedState(response.data ?? []));
      } else {
        emit(LicenseErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });

    on<LicenseValidationEvent>((event, emit) {
      if (event.companyLicenseRegisteredState.isEmpty) {
        emit(LicenseErrorState("Please enter the mandatory field"));
      } else if (event.companyLicenseNumber.isEmpty) {
        emit(LicenseErrorState("Please enter the mandatory field"));
      } else if (event.companyLicenseNumber.isEmpty) {
        emit(LicenseErrorState("Please enter the mandatory field"));
      } else if (event.companyLicenseExpiration.isEmpty) {
        emit(LicenseErrorState("Please enter the mandatory field"));
      } else if (event.companyLicenseStartDate.isEmpty) {
        emit(LicenseErrorState("Please enter the mandatory field"));
      } else if (event.imagePath.isEmpty) {
        emit(LicenseErrorState("Please upload licence image"));
      } else {
        emit(LicenseValidState());
      }
    });

    on<LicenseSubmittedEvent>((event, emit) async {
      emit(LicenseLoadingState());

      String providerId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      SaveLicenseReqBodyModel sendObj = SaveLicenseReqBodyModel(
        licenseType: event.licenseType,
        registeredState: event.companyLicenseRegisteredState,
        licenseStartDate: event.companyLicenseStartDate,
        licenseExpiryDate: event.companyLicenseExpiration,
        issuedBy: event.issueAuthority,
        licenseNumber: event.companyLicenseNumber,
        licenseHolderName: event.companyLicenseHolderName,
        providerUniqueId: providerId,
        imagePath: event.imagePath,
        isActive: true,
      );

      ApiResponse<MessageStatusModel> response = await appRepositoryValidation
          .saveLicense(obj: sendObj, id: providerId);
      if (response.status == ApiResponseStatus.completed) {
        emit(LicenseCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(LicenseErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
