import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../../../utils/app_colors.dart';
import '../../network/api_response.dart';
import '../../repositories/app_repository_validation.dart';
import '../../service_locator.dart';
import 'quotes_state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  QuotesCubit() : super(QuotesInitialState());
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  void quoteDetails({
    required String quoteUniqueId,
  }) async {
    emit(QuotesLoadingState());
    ApiResponse<Quotes> response = await appRepositoryValidation.quoteDetails(
        quoteUniqueId: quoteUniqueId);
    if (response.status == ApiResponseStatus.completed) {
      emit(QuotesLoadedState(quotes: response.data!));
    } else {
      emit(QuotesErrorState(response.messageKey, bgColor: AppColors.red));
    }
  }
}
