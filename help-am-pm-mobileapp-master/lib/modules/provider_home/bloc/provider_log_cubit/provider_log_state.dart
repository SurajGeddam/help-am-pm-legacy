import 'dart:ui';

import '../../../../utils/app_colors.dart';
import '../../model/provider_log_model/provider_log_model.dart';

abstract class ProviderLogState {}

class ProviderLogInitialState extends ProviderLogState {}

class ProviderLogLoadingState extends ProviderLogState {}

class ProviderLogLoadedState extends ProviderLogState {
  final ProviderLogModel providerLogModel;
  ProviderLogLoadedState(this.providerLogModel);
}

class ProviderLogErrorState extends ProviderLogState {
  final String errorMessage;
  final Color bgColor;

  ProviderLogErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
