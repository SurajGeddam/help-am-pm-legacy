abstract class BankEvent {}

class BankValidationEvent extends BankEvent {
  final String nameOfTheBank;
  final String nameOnTheBankAccount;
  final String accountRoutingNumber;
  final String accountNumber;

  BankValidationEvent({
    required this.nameOfTheBank,
    required this.nameOnTheBankAccount,
    required this.accountRoutingNumber,
    required this.accountNumber,
  });
}

class BankSubmittedEvent extends BankEvent {
  final String nameOfTheBank;
  final String nameOnTheBankAccount;
  final String accountRoutingNumber;
  final String accountNumber;
  final String bankAddress;
  final String bankAccountType;

  BankSubmittedEvent(
      {required this.nameOfTheBank,
      required this.nameOnTheBankAccount,
      required this.accountRoutingNumber,
      required this.accountNumber,
      required this.bankAddress,
      required this.bankAccountType});
}
