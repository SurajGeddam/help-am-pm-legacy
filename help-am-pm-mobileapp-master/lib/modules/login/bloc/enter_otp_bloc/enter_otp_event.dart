abstract class EnterOtpEvent {}

class EnterOtpValidationEvent extends EnterOtpEvent {
  final String userId;
  final String otp;
  final String systemOtp;

  EnterOtpValidationEvent({
    required this.userId,
    required this.otp,
    required this.systemOtp,
  });
}

class EnterOtpSubmittedEvent extends EnterOtpEvent {}

class ReSendOtpEvent extends EnterOtpEvent {
  final String userId;

  ReSendOtpEvent({
    required this.userId,
  });
}