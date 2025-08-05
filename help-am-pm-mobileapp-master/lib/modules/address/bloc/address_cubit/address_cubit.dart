import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../model/save_address_model/request_body/save_address_req_body_model.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitialState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchAddress() async {
    emit(AddressLoadingState());

    String uniqueId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    ApiResponse<List<SaveAddressReqBodyModel>> response =
        await appRepositoryValidation.getAddress(id: uniqueId);
    if (response.status == ApiResponseStatus.completed) {
      List<SaveAddressReqBodyModel>? list = response.data;
      if (list != null) {
        SharedPreferenceHelper().setBoolValue(
            SharedPreferenceConstants.isCustomerAddressEmpty, list.isEmpty);
        emit(AddressLoadedState(list));
      } else {
        emit(AddressErrorState(response.messageKey));
      }
    } else {
      emit(AddressErrorState(response.messageKey));
    }
  }
}
