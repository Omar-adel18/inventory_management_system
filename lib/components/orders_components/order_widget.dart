import 'package:flutter/material.dart';
import 'package:inventory_management_system/models/order.dart';
import 'order_products_widget.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // Add elevation to the card for depth
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(15), // Rounded corners
      ),
      child: ExpansionTile(
        leading: const Icon(
          Icons.shopping_cart,
          color: Colors.teal, // Icon color
        ),
        title: Text(
          'Order #${order.orderID}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal, // Custom color for the title
          ),
        ),
        subtitle: Text(
          'Date: ${order.orderDate}',
          style:
          const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Text(
          order.customerName,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        children: order.orderItems.map((item) {
          return OrderProductsWidget(
            productName: item.productName,
            quantity: item.quantity,
            price: item.price,
          );
        }).toList(),
      ),
    );
  }
}
