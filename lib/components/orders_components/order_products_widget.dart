import 'package:flutter/material.dart';

class OrderProductsWidget extends StatelessWidget {
  const OrderProductsWidget({super.key, required this.productName, required this.quantity, required this.price});
  final String productName;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 8),
      leading: const Icon(
        Icons.storefront,
        color: Colors.blueAccent, // Custom icon color
      ),
      title: Text(
        productName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Quantity: $quantity'),
      trailing: Text(
        '\$${price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.green, // Price in green color
        ),
      ),
    );
  }
}
