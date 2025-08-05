import '../../../core/services/model/user_model.dart';

abstract class CustomerHomeState {}

class CustomerHomeLoadingState extends CustomerHomeState {}

class CustomerHomeLoadedState extends CustomerHomeState {
  final List<UserModel> posts;
  CustomerHomeLoadedState(this.posts);
}

class CustomerHomeErrorState extends CustomerHomeState {
  final String error;
  CustomerHomeErrorState(this.error);
}
