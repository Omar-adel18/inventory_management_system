import 'package:inventory_management_system/models/order.dart';

abstract class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState { }

final class OrdersLoaded extends OrdersState{
  final List<Order> orders;

  OrdersLoaded({required this.orders});
}

final class OrdersEmpty extends OrdersState { }

class OrderAdded extends OrdersState {
  final int orderId;

  OrderAdded({required this.orderId});
}

class InsufficientStock extends OrdersState {
  final String productName;

  InsufficientStock({required this.productName});
}

final class OrderError extends OrdersState {
  final String message;

  OrderError({required this.message});
}