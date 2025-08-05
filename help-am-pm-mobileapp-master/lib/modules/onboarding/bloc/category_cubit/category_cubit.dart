import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/repositories/app_repository.dart';
import '../../../../core/services/service_locator.dart';
import '../../model/category_model/api/category_model.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitialState());

  AppRepository appRepository = getIt<AppRepository>();

  void fetchCategory() async {
    emit(CategoryLoadingState());
    ApiResponse<List<CategoryModel>> response =
        await appRepository.getCategory();
    if (response.status == ApiResponseStatus.completed) {
      List<CategoryModel>? list = response.data;
      if (list != null) {
        emit(CategoryLoadedState(list));
      } else {
        emit(CategoryErrorState(response.messageKey));
      }
    } else {
      emit(CategoryErrorState(response.messageKey));
    }
  }
}
