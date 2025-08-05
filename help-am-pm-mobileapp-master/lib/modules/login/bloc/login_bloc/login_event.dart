abstract class LoginEvent {}

class LoginValidationEvent extends LoginEvent {
  final String emailValue;
  final String passwordValue;

  LoginValidationEvent({
    required this.emailValue,
    required this.passwordValue,
  });
}

class LoginSubmittedEvent extends LoginEvent {
  final String emailValue;
  final String passwordValue;

  LoginSubmittedEvent({
    required this.emailValue,
    required this.passwordValue,
  });
}
