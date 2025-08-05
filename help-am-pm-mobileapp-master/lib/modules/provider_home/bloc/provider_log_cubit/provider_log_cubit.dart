import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../model/provider_log_model/provider_log_model.dart';
import 'provider_log_state.dart';

class ProviderLogCubit extends Cubit<ProviderLogState> with ChangeNotifier {
  ProviderLogCubit() : super(ProviderLogInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchProviderLog() async {
    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<ProviderLogModel> response =
        await appRepositoryValidation.getProviderLog(id: uniqueId);
    if (response.status == ApiResponseStatus.completed) {
      ProviderLogModel? providerLogModel = response.data;
      if (providerLogModel != null) {
        emit(ProviderLogLoadedState(providerLogModel));
      } else {
        emit(
            ProviderLogErrorState(response.messageKey, bgColor: AppColors.red));
      }
      notifyListeners();
    } else {
      emit(ProviderLogErrorState(response.messageKey));
    }
  }
}
