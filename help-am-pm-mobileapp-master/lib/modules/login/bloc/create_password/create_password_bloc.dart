import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../core_components/common_models/message_status_model.dart';
import '../../../../utils/app_colors.dart';
import 'create_password_event.dart';
import 'create_password_state.dart';

class CreatePasswordBloc
    extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  AppRepository appRepository = getIt<AppRepository>();

  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();

  CreatePasswordBloc() : super(CreatePasswordInitialState()) {
    on<CreatePasswordValidationEvent>((event, emit) {
      if (event.password.isEmpty) {
        emit(CreatePasswordErrorState("Please enter the password"));
      } else if (event.reEnterpassword.isEmpty) {
        emit(CreatePasswordErrorState("Please re-enter the password"));
      } else if (event.password != event.reEnterpassword) {
        emit(CreatePasswordErrorState(
            "Password and re-enter password does not matched",
            bgColor: AppColors.red));
      } else {
        emit(CreatePasswordValidState());
      }
    });

    on<CreatePasswordSubmittedEvent>((event, emit) async {
      emit(CreatePasswordLoadingState());

      ApiResponse<MessageStatusModel> response =
          await appRepository.resetPassword(
              userId: event.userId, password: event.password, otp: event.otp);

      if (response.status == ApiResponseStatus.completed) {
        MessageStatusModel? messageStatusModel = response.data;
        if (messageStatusModel != null) {
          emit(CreatePasswordCompleteState());
        } else {
          emit(CreatePasswordErrorState(response.messageKey,
              bgColor: AppColors.red));
        }
      } else {
        emit(CreatePasswordErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
    });
  }
}
