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
import '../../model/vehicle_model/save_vehicle_req_body_model.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  VehicleBloc() : super(VehicleInitialState()) {
    on<VehicleGetDataEvent>((event, emit) async {
      emit(VehicleDataLoadingState());

      ApiResponse<List<PolicyTypeModel>> response =
          await appRepositoryValidation.getInsuranceType();
      if (response.status == ApiResponseStatus.completed) {
        emit(VehicleDataLoadedState(response.data ?? []));
      } else {
        emit(VehicleErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });

    on<VehicleValidationEvent>((event, emit) {
      if (event.vehicleMake.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else if (event.vehicleModel.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else if (event.vehicleVIN.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else if (event.vehicleLicensePlate.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else if (event.vehicleInsuranceCarrier.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else if (event.vehicleInsurancePolicy.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else if (event.vehicleInsuranceExpirationDate.isEmpty) {
        emit(VehicleErrorState(AppStrings.pleaseEnterTheMandatoryField));
      } else {
        emit(VehicleValidState());
      }
    });

    on<VehicleSubmittedEvent>((event, emit) async {
      emit(VehicleLoadingState());

      String providerId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      SaveVehicleReqBodyModel sendObj = SaveVehicleReqBodyModel(
        manufacturer: event.vehicleMake,
        model: event.vehicleModel,
        vin: event.vehicleVIN,
        numberPlate: event.vehicleLicensePlate,
        providerUniqueId: providerId,
        insurance: Insurance(
          insurerName: event.vehicleInsuranceCarrier,
          policyExpiryDate: event.vehicleInsuranceExpirationDate,
          providerUniqueId: providerId,
          isActive: true,
          policyType: event.policyType,
          policyHolderName: event.vehicleInsurancePolicyAccountHolder,
          policyNumber: event.vehicleInsurancePolicy,
          imagePath: event.imagePath,
        ),
      );

      ApiResponse<MessageStatusModel> response = await appRepositoryValidation
          .saveVehicle(obj: sendObj, id: providerId);
      if (response.status == ApiResponseStatus.completed) {
        emit(VehicleCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(VehicleErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
