import 'dart:ui';
import '../../../../utils/app_colors.dart';
import '../../model/save_address_model/request_body/save_address_req_body_model.dart';

abstract class AddressState {}

class AddressInitialState extends AddressState {}

class AddressLoadingState extends AddressState {}

class AddressLoadedState extends AddressState {
  final List<SaveAddressReqBodyModel> list;
  AddressLoadedState(this.list);
}

class AddressErrorState extends AddressState {
  final String errorMessage;
  final Color bgColor;

  AddressErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
