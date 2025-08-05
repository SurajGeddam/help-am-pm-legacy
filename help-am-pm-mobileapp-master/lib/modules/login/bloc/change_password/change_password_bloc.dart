import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_utils.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();

  ChangePasswordBloc() : super(ChangePasswordInitialState()) {
    on<ChangePasswordValidationEvent>((event, emit) {
      if (event.oldPassword.isEmpty) {
        emit(ChangePasswordErrorState("Please enter current password"));
      } else if (event.password.isEmpty) {
        emit(ChangePasswordErrorState("Please enter password"));
      } else if (!AppUtils.validateStructure(event.password.trim())) {
        emit(ChangePasswordErrorState(
            "Password should contain at least one upper case, one lower case, one digit, one special character and must be at least 8 characters in length"));
      } else if (event.reEnterpassword.isEmpty) {
        emit(ChangePasswordErrorState("Please re-enter password"));
      } else if (event.password != event.reEnterpassword) {
        emit(ChangePasswordErrorState(
            "Password and re-enter password does not matched",
            bgColor: AppColors.red));
      } else {
        emit(ChangePasswordValidState());
      }
    });

    on<ChangePasswordSubmittedEvent>((event, emit) async {
      emit(ChangePasswordLoadingState());

      ApiResponse<MessageStatusModel> response =
          await appRepositoryValidation.changePassword(
        userId: event.userId,
        oldPassword: event.oldPassword,
        password: event.password,
      );

      if (response.status == ApiResponseStatus.completed) {
        MessageStatusModel? messageStatusModel = response.data;
        if (messageStatusModel != null) {
          emit(ChangePasswordCompleteState());
        } else {
          emit(ChangePasswordErrorState(response.messageKey,
              bgColor: AppColors.red));
        }
      } else {
        emit(ChangePasswordErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
    });
  }
}
