import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import '../../utils/local_notifications.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import 'get_orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());
  final dpHelper = DatabaseHelper();
  List<Order> orders = [];

  // Get orders
  void getOrders() async {
    try {
      final ordersWithItems = await dpHelper.retrieveAllOrders();

      orders = ordersWithItems.map((orderData) {
        final orderDetails = orderData['order'];
        final orderItems = orderData['items'];

        return Order(
          orderID: orderDetails['id'] ?? 0,
          orderDate: orderDetails['orderDate'] ?? 'Unknown Date',
          customerName: orderDetails['customerName'] ?? 'Unknown Customer',
          orderItems: orderItems.map<OrderItem>((item) {
            return OrderItem(
              productName: item['productName'] ?? 'Unknown Product',
              quantity: item['quantity'] ?? 0,
              price: (item['price'] ?? 0).toDouble(),
            );
          }).toList(),
        );
      }).toList();
      if(orders.isEmpty){
        emit(OrdersEmpty());
        return;
      }

      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  // Delete order
  Future<void> deleteOrder(int orderID) async {
    try {
      await dpHelper.deleteOrder(orderID);
      getOrders();
    } catch (e) {
      emit(OrderError(message: 'Failed to delete Order'));
    }
  }

  // Add order
  Future<void> addOrder(
      int customerId, String orderDate, List<Map<String, dynamic>> items) async {
    emit(OrdersLoading());
    try {
      log('Validating customer existence...');
      bool customerExists;
      try {
        customerExists = await dpHelper.customerExists(customerId);
      } catch (e) {
        log('Error validating customer existence: $e');
        emit(OrderError(message: 'Error validating customer existence: $e'));
        return;
      }

      if (!customerExists) {
        log('Customer does not exist');
        emit(OrderError(message: 'Customer does not exist'));
        return;
      }

      log('Validating products and stock...');
      for (var item in items) {
        log('Checking product: ${item['productName']}');
        int productId;
        try {
          productId = await dpHelper.getProductID(item['productName']);
        } catch (e) {
          log('Error retrieving product ID for ${item['productName']}: $e');
          emit(OrderError(message: 'Error retrieving product ID for ${item['productName']}: $e'));
          return;
        }

        if (productId == -1) {
          log('Product ${item['productName']} does not exist');
          emit(OrderError(message: 'Product ${item['productName']} does not exist'));
          return;
        }

        log('Checking stock for product ID: $productId');
        int? stockQuantity;
        try {
          stockQuantity = await dpHelper.getProductStockQuantity(productId);
        } catch (e) {
          log('Error retrieving stock quantity for product ID $productId: $e');
          emit(OrderError(message: 'Error retrieving stock quantity for product ID $productId: $e'));
          return;
        }

        if (stockQuantity < item['quantity']) {
          log('Insufficient stock for ${item['productName']}');
          emit(InsufficientStock(productName: item['productName']));
          return;
        }
      }

      log('Adding order to database...');
      int orderId;
      try {
        orderId = await dpHelper.addOrder(
          customerId: customerId,
          orderDate: orderDate,
        );
      } catch (e) {
        log('Error adding order to database: $e');
        emit(OrderError(message: 'Error adding order to database: $e'));
        return;
      }
      log('Order ID: $orderId');

      log('Adding order items and updating stock...');
      List<Map<String, dynamic>> lowStockProducts = [];
      for (var item in items) {
        int productId;
        try {
          productId = await dpHelper.getProductID(item['productName']);
        } catch (e) {
          log('Error retrieving product ID for ${item['productName']}: $e');
          emit(OrderError(message: 'Error retrieving product ID for ${item['productName']}: $e'));
          return;
        }

        log('Adding order item for product ID: $productId');
        try {
          await dpHelper.addOrderItem(
            orderId: orderId,
            productId: productId,
            quantity: item['quantity'],
          );
        } catch (e) {
          log('Error adding order item for product ID $productId: $e');
          emit(OrderError(message: 'Error adding order item for product ID $productId: $e'));
          return;
        }

        log('Updating stock for product ID: $productId');
        try {
          // Update the stock quantity
          await _updateProductQuantity(productId, item['quantity']);

          // Check if the stock is below the threshold (10 items)
          int? updatedStockQuantity = await dpHelper.getProductStockQuantity(productId);
          if (updatedStockQuantity < 10) {
            // Add the low-stock product to a list for sequential notifications
            lowStockProducts.add({
              'productId': productId,
              'productName': item['productName'],
              'stockQuantity': updatedStockQuantity,
            });
          }
        } catch (e) {
          log('Error updating stock for product ID $productId: $e');
          emit(OrderError(message: 'Error updating stock for product ID $productId: $e'));
          return;
        }
      }

      // After processing all items, show notifications sequentially
      if (lowStockProducts.isNotEmpty) {
        for (var product in lowStockProducts) {
          await showNotification(
            product['productId'], // Use productId as the unique notification ID
            'Low Stock Alert',
            '${product['productName']} is running low. Only ${product['stockQuantity']} left!',
          );
        }
      }

      log('Fetching updated orders...');
      try {
        getOrders(); // Fetch updated orders
      } catch (e) {
        log('Error fetching updated orders: $e');
        emit(OrderError(message: 'Error fetching updated orders: $e'));
        return;
      }

      emit(OrderAdded(orderId: orderId));
    } catch (e) {
      log('Unexpected error in addOrder: $e');
      emit(OrderError(message: 'Unexpected error: $e'));
    }
  }

  // Update product quantity
  Future<void> _updateProductQuantity(int productId, int quantity) async {
    final db = await dpHelper.database;
    var result = await db.query(
      'Products',
      columns: ['StockQuantity'],
      where: 'ProductID = ?',
      whereArgs: [productId],
    );

    if (result.isNotEmpty) {
      int currentQuantity = result.first['StockQuantity'] as int;
      int newQuantity = currentQuantity - quantity;
      newQuantity = newQuantity < 0 ? 0 : newQuantity;

      await db.update(
        'Products',
        {'StockQuantity': newQuantity},
        where: 'ProductID = ?',
        whereArgs: [productId],
      );
    }
  }
}