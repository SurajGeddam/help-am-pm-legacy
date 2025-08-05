import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../model/bank_model/save_bank_req_body_model.dart';
import 'bank_event.dart';
import 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  BankBloc() : super(BankInitialState()) {
    on<BankValidationEvent>((event, emit) {
      if (event.nameOfTheBank.isEmpty) {
        emit(BankErrorState("Please enter name of the bank"));
      } else if (event.nameOnTheBankAccount.isEmpty) {
        emit(BankErrorState("Please enter name on the bank account"));
      } else if (event.accountRoutingNumber.isEmpty) {
        emit(BankErrorState("Please enter the account routing number"));
      } else if (event.accountNumber.isEmpty) {
        emit(BankErrorState("Please enter the account number"));
      } else {
        emit(BankValidState());
      }
    });

    on<BankSubmittedEvent>((event, emit) async {
      emit(BankLoadingState());

      SaveBankReqBodyModel sendObj = SaveBankReqBodyModel(
        accountHolderName: event.nameOnTheBankAccount,
        accountNumber: event.accountNumber,
        bankName: event.nameOfTheBank,
        routingNumber: event.accountRoutingNumber,
        accountType: event.bankAccountType,
      );
      String providerId = SharedPreferenceHelper()
          .getStringValue(SharedPreferenceConstants.uniqueId);

      ApiResponse<MessageStatusModel> response =
          await appRepositoryValidation.saveBank(obj: sendObj, id: providerId);
      if (response.status == ApiResponseStatus.completed) {
        emit(BankCompleteState(
            response.data?.message ?? AppStrings.savedSuccessfully));
      } else {
        emit(BankErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });
  }
}
