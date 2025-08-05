import 'package:helpampm/utils/app_constant.dart';

import '../../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../onboarding/model/category_model/api/category_model.dart';

class ServiceChargeModel {
  late double displayPrice;
  late String currencySymbol;
  late Timeslots? selectedTimeSlot;
  final CategoryModel? categoryModel;
  final SaveAddressReqBodyModel? addressModel;

  ServiceChargeModel({
    this.displayPrice = 0.0,
    this.currencySymbol = AppConstants.dollorSign,
    this.selectedTimeSlot,
    this.categoryModel,
    this.addressModel,
  });
}
