class Product {
  final int productID;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final int categoryID;

  const Product({
    required this.productID,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.categoryID,
  });
}
