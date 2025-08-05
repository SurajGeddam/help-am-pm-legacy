abstract class ChangePasswordEvent {}

class ChangePasswordValidationEvent extends ChangePasswordEvent {
  final String oldPassword;
  final String password;
  final String reEnterpassword;

  ChangePasswordValidationEvent({
    required this.oldPassword,
    required this.password,
    required this.reEnterpassword,
  });
}

class ChangePasswordSubmittedEvent extends ChangePasswordEvent {
  final String userId;
  final String oldPassword;
  final String password;

  ChangePasswordSubmittedEvent({
    required this.userId,
    required this.oldPassword,
    required this.password,
  });

}

