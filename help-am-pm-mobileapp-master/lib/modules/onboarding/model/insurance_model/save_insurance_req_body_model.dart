import '../../../../utils/app_strings.dart';
import '../common/policy_type_model.dart';

class SaveInsuranceReqBodyModel {
  String insurerName;
  PolicyTypeModel? policyType;
  String policyNumber;
  String policyStartDate;
  String policyExpiryDate;
  String policyHolderName;
  bool isActive;

  SaveInsuranceReqBodyModel({
    this.insurerName = AppStrings.emptyString,
    this.policyType,
    this.policyNumber = AppStrings.emptyString,
    this.policyStartDate = AppStrings.emptyString,
    this.policyExpiryDate = AppStrings.emptyString,
    this.policyHolderName = AppStrings.emptyString,
    this.isActive = false,
  });
}
