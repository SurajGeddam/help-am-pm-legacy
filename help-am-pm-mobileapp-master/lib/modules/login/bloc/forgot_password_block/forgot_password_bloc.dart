import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  AppRepository appRepository = getIt<AppRepository>();

  ForgotPasswordBloc() : super(ForgotPasswordInitialState()) {
    on<ForgotPasswordValidationEvent>((event, emit) {
      if (event.emailValue.isEmpty) {
        emit(ForgotPasswordErrorState("Please enter the email Id"));
      } else if (EmailValidator.validate(event.emailValue) == false) {
        emit(ForgotPasswordErrorState("Please enter a valid email address",
            bgColor: AppColors.red));
      } else {
        emit(ForgotPasswordValidState());
      }
    });

    on<ForgotPasswordSubmittedEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());

      ApiResponse<MessageStatusModel> response =
          await appRepository.forgotPasswordSendOtp(
        userName: event.emailValue.trim(),
      );

      if (response.status == ApiResponseStatus.completed) {
        MessageStatusModel? messageStatusModel = response.data;
        if (messageStatusModel != null) {
          emit(ForgotPasswordCompleteState(
              event.emailValue.trim(), messageStatusModel.message!));
        } else {
          emit(ForgotPasswordErrorState(response.messageKey,
              bgColor: AppColors.red));
        }
      } else {
        emit(ForgotPasswordErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
    });
  }
}
