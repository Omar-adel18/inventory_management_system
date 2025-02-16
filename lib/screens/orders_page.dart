import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/OrdersCubit/get_orders_state.dart';
import 'package:inventory_management_system/utils/auth_service.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import '../components/orders_components/order_widget.dart';
import '../components/orders_components/handle_delete.dart';
import '../cubit/OrdersCubit/get_orders_cubit.dart';
import '../models/order.dart';
import 'add_order_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final dpHelper = DatabaseHelper();
  final authService = AuthService();
  List<Order> ordersFuture = [];

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = authService.getCurrentUserRole();
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
          if (state is OrdersLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrdersEmpty) {
            return Center(
              child: Text('No orders found'),
            );
          } else if (state is OrdersLoaded) {
            final orders = state.orders;
            return ListView.separated(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              itemCount: orders.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                    onLongPress: () {
                      if(userRole == 'admin'){
                        handleDelete(context, order.orderID);
                      }
                    },
                    child: OrderWidget(order: order));
              },
            );
          } else if (state is OrderAdded) {
            context.read<OrdersCubit>().getOrders();
          }
          return Container();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal, // Custom color for FAB
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddOrderPage.id,
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
