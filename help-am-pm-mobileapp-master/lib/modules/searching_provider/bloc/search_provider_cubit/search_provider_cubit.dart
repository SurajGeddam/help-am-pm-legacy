import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../model/search_provider_req_body_model.dart';
import '../../model/search_provider_response_model.dart';
import 'search_provider_state.dart';

class SearchProviderCubit extends Cubit<SearchProviderState> {
  SearchProviderCubit() : super(SearchProviderLoadingState());

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void fetchSearchProvider({
    required SearchProviderReqBodyModel obj,
  }) async {
    ApiResponse<List<SearchProviderModel>> response =
        await appRepositoryValidation.getSearchProvider(obj: obj);
    if (response.status == ApiResponseStatus.completed) {
      List<SearchProviderModel>? list = response.data;
      if (list != null) {
        emit(SearchProviderLoadedState(list));
      } else {
        emit(SearchProviderErrorState(response.messageKey));
      }
    } else {
      emit(SearchProviderErrorState(response.messageKey));
    }
  }
}
