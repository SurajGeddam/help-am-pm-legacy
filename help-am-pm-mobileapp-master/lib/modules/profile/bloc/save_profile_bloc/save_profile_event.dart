abstract class SaveProfileEvent {}

class SaveProviderProfileValidationEvent extends SaveProfileEvent {
  final String nameController;
  final String emailController;
  final String mobileNumberController;

  SaveProviderProfileValidationEvent(
      {required this.nameController,
      required this.emailController,
      required this.mobileNumberController});
}

class SaveCustomerProfileValidationEvent extends SaveProfileEvent {
  final String firstNameController;
  final String lastNameController;
  final String emailController;
  final String mobileNumberController;

  SaveCustomerProfileValidationEvent(
      {required this.firstNameController,
        required this.lastNameController,
        required this.emailController,
        required this.mobileNumberController});
}

class SaveCustomerProfileSubmittedEvent extends SaveProfileEvent {
  final String profilePicturePath;
  final String firstNameController;
  final String lastNameController;
  final String emailController;
  final String mobileNumberController;

  SaveCustomerProfileSubmittedEvent({
    required this.profilePicturePath,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.mobileNumberController,
  });
}

class SaveProviderProfileSubmittedEvent extends SaveProfileEvent {
  final String profilePicturePath;
  final String nameController;
  final String emailController;
  final String mobileNumberController;

  SaveProviderProfileSubmittedEvent({
    required this.profilePicturePath,
    required this.nameController,
    required this.emailController,
    required this.mobileNumberController,
  });
}
