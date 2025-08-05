import '../../model/common/policy_type_model.dart';

abstract class LicenseEvent {}

class LicenseGetDataEvent extends LicenseEvent {}

class LicenseValidationEvent extends LicenseEvent {
  final String companyLicenseRegisteredState;
  final String companyLicenseNumber;
  final String companyLicenseStartDate;
  final String companyLicenseExpiration;
  final String companyLicenseHolderName;
  final String issueAuthority;
  final String imagePath;

  LicenseValidationEvent({
    required this.companyLicenseRegisteredState,
    required this.companyLicenseNumber,
    required this.companyLicenseStartDate,
    required this.companyLicenseExpiration,
    required this.companyLicenseHolderName,
    required this.issueAuthority,
    required this.imagePath,
  });
}

class LicenseSubmittedEvent extends LicenseEvent {
  final PolicyTypeModel? licenseType;
  final String companyLicenseRegisteredState;
  final String companyLicenseNumber;
  final String companyLicenseStartDate;
  final String companyLicenseExpiration;
  final String companyLicenseHolderName;
  final String issueAuthority;
  final String imagePath;

  LicenseSubmittedEvent({
    required this.licenseType,
    required this.companyLicenseRegisteredState,
    required this.companyLicenseNumber,
    required this.companyLicenseStartDate,
    required this.companyLicenseExpiration,
    required this.companyLicenseHolderName,
    required this.issueAuthority,
    required this.imagePath,
  });
}
