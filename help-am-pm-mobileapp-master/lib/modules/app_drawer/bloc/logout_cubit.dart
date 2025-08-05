import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network/api_response.dart';
import '../../../core/services/repositories/app_repository_validation.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_models/message_status_model.dart';
import '../../../utils/app_utils.dart';

enum LogoutCubitState { initial, loading, loaded }

class LogoutCubit extends Cubit<LogoutCubitState> {
  LogoutCubit() : super(LogoutCubitState.initial);

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<void> logoutApi() async {
    emit(LogoutCubitState.loading);
    String deviceToken = AppUtils.getDeviceToken();
    String userName = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.userName);

    ApiResponse<MessageStatusModel> response = await appRepositoryValidation
        .logout(deviceId: deviceToken, username: userName);
    if (response.status == ApiResponseStatus.completed) {
      AppUtils.logout();
      emit(LogoutCubitState.loaded);
    }
    return;
  }
}
