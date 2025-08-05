import 'package:helpampm/modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import 'package:helpampm/utils/app_strings.dart';
import '../../onboarding/model/category_model/api/category_model.dart';

class NewBookingReqBodyModel {
  final String categoryName;
  final bool? residentialService;
  final bool? commercialService;
  final SaveAddressReqBodyModel address;
  final Timeslots? timeslots;
  final String serviceDate;
  final String serviceDescription;
  final String imagePath;
  final bool isScheduled;

  NewBookingReqBodyModel({
    required this.categoryName,
    this.residentialService,
    this.commercialService,
    required this.address,
    this.timeslots,
    required this.serviceDate,
    required this.serviceDescription,
    this.imagePath = AppStrings.emptyString,
    this.isScheduled = false,
  });
}
