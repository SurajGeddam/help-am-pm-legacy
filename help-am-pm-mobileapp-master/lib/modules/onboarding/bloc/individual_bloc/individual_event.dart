abstract class IndividualEvent {}

class IndividualValidationEvent extends IndividualEvent {
  final String companyNameEditingController;
  final String companyPhoneEditingController;
  final String companyEmailEditingController;

  final String flatNoController;
  final String cityController;
  final String stateController;
  final String countryController;
  final String pinCodeController;

  IndividualValidationEvent({
    required this.companyNameEditingController,
    required this.companyPhoneEditingController,
    required this.companyEmailEditingController,
    required this.flatNoController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.pinCodeController,
  });
}

class IndividualSubmittedEvent extends IndividualEvent {
  final String companyNameEditingController;
  final String companyPhoneEditingController;
  final String companyEmailEditingController;
  final String companyWebsiteEditingController;

  final String flatNoController;
  final String areaController;
  final String cityController;
  final String stateController;
  final String countryController;
  final String pinCodeController;

  final double latitude;
  final double longitude;
  final int altitude;

  IndividualSubmittedEvent({
    required this.companyNameEditingController,
    required this.companyPhoneEditingController,
    required this.companyEmailEditingController,
    required this.companyWebsiteEditingController,
    required this.flatNoController,
    required this.areaController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.pinCodeController,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.altitude = 0,
  });
}
