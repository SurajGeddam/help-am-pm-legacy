import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import 'enter_otp_event.dart';
import 'enter_otp_state.dart';

class EnterOtpBloc extends Bloc<EnterOtpEvent, EnterOtpState> {
  AppRepository appRepository = getIt<AppRepository>();

  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();

  EnterOtpBloc() : super(EnterOtpInitialState()) {
    on<EnterOtpValidationEvent>((event, emit) {
      if (event.otp.isEmpty) {
        emit(EnterOtpErrorState("Please enter the OTP sent"));
      } else if (event.otp != event.systemOtp) {
        emit(EnterOtpErrorState("Please enter valid OTP",
            bgColor: AppColors.red));
      } else {
        emit(EnterOtpValidState());
      }
    });
    on<ReSendOtpEvent>((event, emit) async {
      AppRepository appRepository = getIt<AppRepository>();
      ApiResponse<MessageStatusModel> response =
          await appRepository.forgotPasswordSendOtp(
        userName: event.userId.trim(),
      );

      if (response.status == ApiResponseStatus.completed) {
        MessageStatusModel? messageStatusModel = response.data;
        if (messageStatusModel != null) {
          emit(ResendOtpCompleteState(messageStatusModel.message!));
        } else {
          emit(EnterOtpErrorState(response.messageKey, bgColor: AppColors.red));
        }
      } else {
        emit(EnterOtpErrorState(response.messageKey, bgColor: AppColors.red));
      }
    });

    on<EnterOtpSubmittedEvent>((event, emit) async {
      emit(EnterOtpCompleteState());
    });
  }
}
