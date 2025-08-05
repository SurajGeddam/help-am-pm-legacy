import '../../model/common/policy_type_model.dart';

abstract class InsuranceEvent {}

class InsuranceGetDataEvent extends InsuranceEvent {}

class InsuranceValidationEvent extends InsuranceEvent {
  final String companyGeneralLiabilityInsCarrier;
  final String companyPolicyNumber;
  final String policyHolderName;
  final String companyGLPolicyExpirationDate;

  InsuranceValidationEvent({
    required this.companyGeneralLiabilityInsCarrier,
    required this.companyPolicyNumber,
    required this.policyHolderName,
    required this.companyGLPolicyExpirationDate,
  });
}

class InsuranceSubmittedEvent extends InsuranceEvent {
  final String companyGeneralLiabilityInsCarrier;
  final PolicyTypeModel policyType;
  final String companyPolicyNumber;
  final String companyGLPolicyExpirationDate;
  final String policyHolderName;

  InsuranceSubmittedEvent({
    required this.companyGeneralLiabilityInsCarrier,
    required this.policyType,
    required this.companyPolicyNumber,
    required this.policyHolderName,
    required this.companyGLPolicyExpirationDate,
  });
}
