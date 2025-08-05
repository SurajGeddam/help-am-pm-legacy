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
import '../../model/insurance_model/save_insurance_req_body_model.dart';
import 'insurance_event.dart';
import 'insurance_state.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  InsuranceBloc() : super(InsuranceInitialState()) {
    on<InsuranceGetDataEvent>((event, emit) async {
      emit(InsuranceDataLoadingState());

      ApiResponse<List<PolicyTypeModel>> response =
          await appRepositoryValidation.getInsuranceType();
      if (response.status == ApiResponseStatus.completed) {
        emit(InsuranceDataLoadedState(response.data ?? []));
      } else {
        emit(InsuranceErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });

    on<InsuranceValidationEvent>((event, emit) {
      if (event.companyGeneralLiabilityInsCarrier.isEmpty) {
        emit(InsuranceErrorState("Please enter the mandatory field"));
      } else if (event.companyPolicyNumber.isEmpty) {
        emit(InsuranceErrorState(
            "Please enter the mandatory field policy number "));
      } else if (event.policyHolderName.isEmpty) {
        emit(InsuranceErrorState(
            "Please enter the mandatory field Policy holder name"));
      } else {
        emit(InsuranceValidState());
      }
    });

    on<InsuranceSubmittedEvent>((event, emit) async {
      emit(InsuranceLoadingState());

      SaveInsuranceReqBodyModel sendObj = SaveInsuranceReqBodyModel(
        insurerName: event.companyGeneralLiabilityInsCarrier,
        policyType: event.policyType,
        policyNumber: event.companyPolicyNumber,
        policyExpiryDate: event.companyGLPolicyExpirationDate,
        policyHolderName: event.policyHolderName,
        isActive: true,
      );
      String providerId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      ApiResponse<MessageStatusModel> response = await appRepositoryValidation
          .saveInsurance(obj: sendObj, id: providerId);
      if (response.status == ApiResponseStatus.completed) {
        emit(InsuranceCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(InsuranceErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
