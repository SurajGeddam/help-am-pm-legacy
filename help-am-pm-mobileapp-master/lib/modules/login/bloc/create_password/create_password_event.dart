abstract class CreatePasswordEvent {}

class CreatePasswordValidationEvent extends CreatePasswordEvent {
  final String userId;
  final String otp;
  final String password;
  final String reEnterpassword;

  CreatePasswordValidationEvent({
    required this.userId,
    required this.otp,
    required this.password,
    required this.reEnterpassword,
  });
}

class CreatePasswordSubmittedEvent extends CreatePasswordEvent {
  final String userId;
  final String otp;
  final String password;

  CreatePasswordSubmittedEvent({
    required this.userId,
    required this.otp,
    required this.password,
  });

}

