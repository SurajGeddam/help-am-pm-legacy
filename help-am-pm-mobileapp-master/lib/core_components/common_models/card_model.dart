import '../../utils/app_strings.dart';

class CardModel {
  final String key;
  final String cardNumber;
  final String ddyy;
  final String cardHolderName;
  final String cardType;
  late bool isDefault;

  CardModel({
    required this.key,
    this.cardNumber = AppStrings.emptyString,
    this.ddyy = AppStrings.emptyString,
    this.cardHolderName = AppStrings.emptyString,
    this.cardType = AppStrings.emptyString,
    this.isDefault = false,
  });
}
