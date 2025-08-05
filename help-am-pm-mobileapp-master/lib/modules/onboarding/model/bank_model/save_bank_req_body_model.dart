class SaveBankReqBodyModel {
  String? accountHolderName;
  String? accountNumber;
  String? bankName;
  String? routingNumber;
  String? accountType;

  SaveBankReqBodyModel(
      {this.accountHolderName,
      this.accountNumber,
      this.bankName,
      this.routingNumber,
      this.accountType});
}
