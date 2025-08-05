import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_models/message_status_model.dart';
import '../network/api_response.dart';
import '../repositories/app_repository_validation.dart';
import '../service_locator.dart';
import '../shared_preferences/shared_preference_constants.dart';
import '../shared_preferences/shared_preference_helper.dart';

enum DeviceTokenState { initial, loaded, error }

class DeviceTokenBloc extends Cubit<DeviceTokenState> {
  DeviceTokenBloc() : super(DeviceTokenState.initial);
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<void> updateFCMDeviceToken(String deviceToken) async {
    String userName = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.userName);

    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.updateFCMDeviceToken(
      deviceId: deviceToken,
      username: userName,
      deviceType: AppConstants.platform,
    );
    if (response.status == ApiResponseStatus.completed) {
      AppUtils.debugPrint("response => ${response.data}");
      emit(DeviceTokenState.loaded);
    } else {
      emit(DeviceTokenState.error);
    }
  }
}
