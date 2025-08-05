abstract class ForgotPasswordEvent {}

class ForgotPasswordValidationEvent extends ForgotPasswordEvent {
  final String emailValue;

  ForgotPasswordValidationEvent({
    required this.emailValue,
  });
}

class ForgotPasswordSubmittedEvent extends ForgotPasswordEvent {
  final String emailValue;

  ForgotPasswordSubmittedEvent({
    required this.emailValue,
  });
}

