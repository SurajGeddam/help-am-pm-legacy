import 'dart:ui';
import '../../../../utils/app_colors.dart';
import '../../model/search_provider_response_model.dart';

abstract class SearchProviderState {}

class SearchProviderLoadingState extends SearchProviderState {}

class SearchProviderLoadedState extends SearchProviderState {
  final List<SearchProviderModel> list;
  SearchProviderLoadedState(this.list);
}

class SearchProviderErrorState extends SearchProviderState {
  final String errorMessage;
  final Color bgColor;

  SearchProviderErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
