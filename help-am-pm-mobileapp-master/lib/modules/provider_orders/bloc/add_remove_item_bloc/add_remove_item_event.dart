abstract class AddRemoveItemEvent {}

class AddRemoveItemValidationEvent extends AddRemoveItemEvent {
  final String itemValue;
  final String priceValue;

  AddRemoveItemValidationEvent({
    required this.itemValue,
    required this.priceValue,
  });
}

class AddRemoveItemSubmittedEvent extends AddRemoveItemEvent {
  final int quoteItemId;
  final String quoteUniqueId;
  final String description;
  final String itemPrice;
  final bool isFromDelete;

  AddRemoveItemSubmittedEvent({
    required this.quoteItemId,
    required this.quoteUniqueId,
    required this.description,
    required this.itemPrice,
    this.isFromDelete = false,
  });
}
