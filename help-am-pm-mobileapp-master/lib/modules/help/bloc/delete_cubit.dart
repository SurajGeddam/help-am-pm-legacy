import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network/api_response.dart';
import '../../../core/services/repositories/app_repository_validation.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_models/message_status_model.dart';

enum DeleteAccountState { initial, loading, loaded }

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountState.initial);

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<void> deleteAccountAPI() async {
    emit(DeleteAccountState.loading);
    String userName = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.userName);

    ApiResponse<MessageStatusModel> response =
        await appRepositoryValidation.deleteAccount(username: userName);

    if (response.status == ApiResponseStatus.completed) {
      emit(DeleteAccountState.loaded);
    }
    return;
  }
}
