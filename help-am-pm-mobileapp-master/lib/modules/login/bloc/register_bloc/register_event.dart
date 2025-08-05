abstract class RegisterEvent {}

class RegisterValidationEvent extends RegisterEvent {
  final bool selectUserIsCustomer;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String emailValue;
  final String passwordValue;
  final String confirmPasswordValue;
  final String employerCode;
  final bool isMandatoryProviderEmployee;

  RegisterValidationEvent({
    this.selectUserIsCustomer = false,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailValue,
    required this.passwordValue,
    required this.confirmPasswordValue,
    required this.employerCode,
    this.isMandatoryProviderEmployee = false,
  });
}

class RegisterSubmittedEvent extends RegisterEvent {
  final bool selectUserIsCustomer;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String emailValue;
  final String passwordValue;
  final String confirmPasswordValue;
  final String employerCode;
  final bool isMandatoryProviderEmployee;

  RegisterSubmittedEvent({
    this.selectUserIsCustomer = false,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailValue,
    required this.passwordValue,
    required this.confirmPasswordValue,
    required this.employerCode,
    this.isMandatoryProviderEmployee = false,
  });
}
