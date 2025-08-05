import 'package:helpampm/utils/app_strings.dart';

import '../common/policy_type_model.dart';

class SaveLicenseReqBodyModel {
  String issuedBy;
  String registeredState;
  PolicyTypeModel? licenseType;
  String licenseNumber;
  String licenseStartDate;
  String licenseExpiryDate;
  String licenseHolderName;
  bool isActive;
  String providerUniqueId;
  String imagePath;

  SaveLicenseReqBodyModel({
    this.issuedBy = AppStrings.emptyString,
    this.registeredState = AppStrings.emptyString,
    this.licenseType,
    this.licenseNumber = AppStrings.emptyString,
    this.licenseStartDate = AppStrings.emptyString,
    this.licenseExpiryDate = AppStrings.emptyString,
    this.licenseHolderName = AppStrings.emptyString,
    this.isActive = false,
    this.providerUniqueId = AppStrings.emptyString,
    this.imagePath = AppStrings.emptyString,
  });
}
