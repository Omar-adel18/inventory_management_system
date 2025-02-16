import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/orders_components/order_details_widget.dart';
import '../components/orders_components/order_item_widget.dart';
import '../cubit/OrdersCubit/get_orders_cubit.dart';
import '../cubit/OrdersCubit/get_orders_state.dart';

class OrderItem {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String? selectedCategory;
  String? selectedProduct;
  List<dynamic> products = [];

  String get productName => productNameController.text;

  int get quantity => int.tryParse(quantityController.text) ?? 0;
}

class AddOrderPage extends StatefulWidget {
  static String id = 'AddOrderPage';
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final formKey = GlobalKey<FormState>();
  List<OrderItem> orderItems = [];
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController customerIDController = TextEditingController();
  Future<List<String>>? categoryFuture;

  @override
  void initState() {
    super.initState();
    orderItems.add(OrderItem());
    categoryFuture =
        context.read<OrdersCubit>().dpHelper.retrieveCategories().then(
              (categories) => categories
                  .map((category) => category['Name'].toString())
                  .toList(),
            );
  }

  void _addOrderItem() {
    setState(() {
      orderItems.add(OrderItem());
    });
  }

  void _removeOrderItem(int index) {
    setState(() {
      orderItems.removeAt(index);
    });
  }

  void _submitOrder() {
    if (!formKey.currentState!.validate()) return;

    final customerId = int.tryParse(customerIDController.text);

    final orderDate = orderDateController.text;
    final items = orderItems.map((item) {
      return {
        'productName': item.productName,
        'quantity': item.quantity,
      };
    }).toList();

    context.read<OrdersCubit>().addOrder(customerId!, orderDate, items);
  }

  void fetchProductsForCategory(OrderItem item, String category) async {
    try {
      final products = await context
          .read<OrdersCubit>()
          .dpHelper
          .retrieveProductsByCategory(category);
      setState(() {
        item.products = products.map((product) {
          return [product['Name'], product['Price'].toString()];
        }).toList();
        item.selectedProduct =
            item.products.isNotEmpty ? item.products[0][0] : null;
        item.productNameController.text = item.selectedProduct ?? '';
      });
    } catch (error) {
      log('Error fetching products for category $category: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order submitted successfully!')),
          );
          Navigator.pop(context); // Navigate back after successful order
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is InsufficientStock) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Insufficient stock for ${state.productName}')),
          );
          context.read<OrdersCubit>().getOrders();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Add Order',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.teal.withOpacity(0.5),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Details',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 16),
                OrderDetailsWidget(
                  orderDateController: orderDateController,
                  customerIDController: customerIDController,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Items',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 16),
                ...orderItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  OrderItem item = entry.value;
                  return OrderItemWidget(
                    categoryFuture: categoryFuture,
                    item: item,
                    orderItems: orderItems,
                    index: index,
                    removeorderitem: () {
                      setState(() {
                        _removeOrderItem(index);
                      });
                    },
                  );
                }),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _addOrderItem,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Order Item',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Submit Order',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
