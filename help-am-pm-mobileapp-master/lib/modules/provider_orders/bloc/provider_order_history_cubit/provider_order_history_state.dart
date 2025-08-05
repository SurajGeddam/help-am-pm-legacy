import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

abstract class ProviderOrderHistoryState {}

class ProviderOrderHistoryInitialState extends ProviderOrderHistoryState {}

class ProviderOrderHistoryLoadingState extends ProviderOrderHistoryState {}

class ProviderOrderHistoryLoadedState extends ProviderOrderHistoryState {
  final List<Quotes> list;
  ProviderOrderHistoryLoadedState(this.list);
}

class ProviderOrderHistoryErrorState extends ProviderOrderHistoryState {
  final String errorMessage;
  final Color bgColor;

  ProviderOrderHistoryErrorState(this.errorMessage,
      {this.bgColor = AppColors.black});
}
