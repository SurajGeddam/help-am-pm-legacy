import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/repositories/app_repository.dart';
import '../../../core/services/service_locator.dart';
import 'customer_home_state.dart';

class CustomerHomeCubit extends Cubit<CustomerHomeState> {
  CustomerHomeCubit() : super(CustomerHomeLoadingState()) {
    fetchPosts();
  }

  AppRepository appRepository = getIt<AppRepository>();

  void fetchPosts() async {
    // try {
    //   ApiResponse<List<UserModel>> list =
    //       await appRepository.getUsersRequested();
    //   if (list.status == ApiResponseStatus.completed) {
    //     emit(CustomerHomeLoadedState(list.data ?? []));
    //   } else {}
    // } on DioError catch (ex) {
    //   if (ex.type == DioErrorType.other) {
    //     emit(CustomerHomeErrorState(
    //         "Can't fetch posts, please check your internet connection!"));
    //   } else {
    //     emit(CustomerHomeErrorState(ex.type.toString()));
    //   }
    // }
  }
}
