import '../../model/common/policy_type_model.dart';

abstract class VehicleEvent {}

class VehicleGetDataEvent extends VehicleEvent {}

class VehicleValidationEvent extends VehicleEvent {
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleVIN;

  final String vehicleLicensePlate;
  final String vehicleInsuranceCarrier;
  final String vehicleInsurancePolicy;
  final String vehicleInsuranceExpirationDate;
  final String vehicleInsurancePolicyAccountHolder;

  VehicleValidationEvent({
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleVIN,
    required this.vehicleLicensePlate,
    required this.vehicleInsuranceCarrier,
    required this.vehicleInsurancePolicy,
    required this.vehicleInsuranceExpirationDate,
    required this.vehicleInsurancePolicyAccountHolder,
  });
}

class VehicleSubmittedEvent extends VehicleEvent {
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleVIN;

  final String vehicleLicensePlate;
  final String vehicleInsuranceCarrier;
  final String vehicleInsurancePolicy;
  final String vehicleInsuranceExpirationDate;
  final String vehicleInsurancePolicyAccountHolder;
  final PolicyTypeModel? policyType;
  final String imagePath;

  VehicleSubmittedEvent({
    required this.policyType,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleVIN,
    required this.vehicleLicensePlate,
    required this.vehicleInsuranceCarrier,
    required this.vehicleInsurancePolicy,
    required this.vehicleInsuranceExpirationDate,
    required this.vehicleInsurancePolicyAccountHolder,
    required this.imagePath,
  });
}
