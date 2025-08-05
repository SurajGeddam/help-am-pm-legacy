import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../utils/app_colors.dart';
import '../../model/country_code_model.dart';
import '../../network/api_response.dart';
import '../../repositories/app_repository.dart';
import '../../service_locator.dart';
import 'all_country_state.dart';

class GetAllCountryCodeBloc extends Cubit<GetAllCountryCodeState> {
  GetAllCountryCodeBloc() : super(GetAllCountryCodeInitialState());
  AppRepository appRepository = getIt<AppRepository>();

  Future<void> getAllCountryCode() async {
    ApiResponse<List<CountryCodeModel>> response =
        await appRepository.getAllCountryCode();
    if (response.status == ApiResponseStatus.completed) {
      AppUtils.debugPrint("response => ${response.data}");
      emit(GetAllCountryCodeLoadedState(list: response.data ?? []));
    } else {
      emit(GetAllCountryCodeErrorState(response.messageKey,
          bgColor: AppColors.red));
    }
  }
}
