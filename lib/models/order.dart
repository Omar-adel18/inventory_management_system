import 'order_item.dart';

class Order {
  final int orderID;
  final String orderDate;
  final String customerName;
  final List<OrderItem> orderItems;

  const Order({
    required this.orderID,
    required this.orderDate,
    required this.customerName,
    required this.orderItems,
  });
}