class AddGroceryModel {
  final String productName;
  final String quantity;
  final String price;
  final String? titleId;

  AddGroceryModel({
    required this.productName,
    required this.quantity,
    required this.price,
    this.titleId
  });
}
