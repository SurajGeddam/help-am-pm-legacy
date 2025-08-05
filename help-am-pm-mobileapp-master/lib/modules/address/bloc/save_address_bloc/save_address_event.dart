import 'package:helpampm/utils/app_strings.dart';

abstract class SaveAddressEvent {}

class SaveAddressValidationEvent extends SaveAddressEvent {
  final String nameController;
  // final String phoneController;
  final String pinCodeController;
  final String cityController;
  final String stateController;
  final String countryController;
  final String flatNoController;
  final String areaController;

  SaveAddressValidationEvent(
      {required this.nameController,
      // required this.phoneController,
      required this.pinCodeController,
      required this.cityController,
      required this.stateController,
      required this.countryController,
      required this.flatNoController,
      required this.areaController});
}

class SaveAddressSubmittedEvent extends SaveAddressEvent {
  final String nameController;
  final String pinCodeController;
  final String cityController;
  final String stateController;
  final String countryController;
  final String flatNoController;
  final String areaController;
  final double latitude;
  final double longitude;
  final double altitude;
  final String addressType;
  final bool isDefault;
  final String customerUniqueId;
  final int? id;

  SaveAddressSubmittedEvent({
    required this.nameController,
    required this.pinCodeController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.flatNoController,
    required this.areaController,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.altitude = 0.0,
    required this.addressType,
    this.isDefault = false,
    this.customerUniqueId = AppStrings.emptyString,
    this.id,
  });
}
