import '../common/policy_type_model.dart';

class SaveVehicleReqBodyModel {
  String? manufacturer;
  String? model;
  String? vin;
  String? numberPlate;
  Insurance? insurance;
  String? providerUniqueId;

  SaveVehicleReqBodyModel(
      {this.manufacturer,
      this.model,
      this.vin,
      this.numberPlate,
      this.insurance,
      this.providerUniqueId});
}

class Insurance {
  String? insurerName;
  PolicyTypeModel? policyType;
  String? policyNumber;
  String? policyStartDate;
  String? policyExpiryDate;
  String? policyHolderName;
  bool? isActive;
  String? providerUniqueId;
  String? imagePath;

  Insurance(
      {this.insurerName,
      this.policyType,
      this.policyNumber,
      this.policyStartDate,
      this.policyExpiryDate,
      this.policyHolderName,
      this.isActive,
      this.providerUniqueId,
      this.imagePath});
}
