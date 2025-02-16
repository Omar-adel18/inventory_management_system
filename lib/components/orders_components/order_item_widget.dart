import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/OrdersCubit/get_orders_cubit.dart';
import '../../../screens/add_order_page.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({
    super.key,
    required this.categoryFuture,
    required this.item,
    required this.orderItems,
    required this.index, required this.removeorderitem,
  });

  final Future<List<String>>? categoryFuture;
  final OrderItem item;
  final List<OrderItem> orderItems;
  final int index;
  final Function() removeorderitem;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      shadowColor: Colors.teal.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: widget.categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.teal);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No categories found',
                      style: TextStyle(color: Colors.grey));
                } else {
                  return DropdownButtonFormField<String>(
                    value: widget.item.selectedCategory,
                    hint: const Text('Select Category',
                        style: TextStyle(color: Colors.teal , fontWeight: FontWeight.bold)),
                    items: snapshot.data!.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category,
                            style: const TextStyle(color: Colors.teal)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.item.selectedCategory = newValue;
                        fetchProductsForCategory(widget.item, newValue!);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      labelStyle: const TextStyle(color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      filled: true,
                      fillColor: Colors.teal.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Category is required';
                      }
                      return null;
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: widget.item.selectedProduct,
              hint: const Text('Product Name',
                  style: TextStyle(color: Colors.teal , fontWeight: FontWeight.bold)),
              items:
                  widget.item.products.map<DropdownMenuItem<String>>((product) {
                return DropdownMenuItem<String>(
                  value: product[0] as String,
                  child: Text(product[0] as String,
                      style: const TextStyle(color: Colors.teal)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  widget.item.selectedProduct = newValue;
                  widget.item.productNameController.text = newValue!;
                });
              },
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Product Name',
                labelStyle: const TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                filled: true,
                fillColor: Colors.teal.withOpacity(0.1),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.item.quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                labelStyle: const TextStyle(color: Colors.teal , fontWeight: FontWeight.bold),
                prefixIcon:
                    const Icon(Icons.format_list_numbered, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                filled: true,
                fillColor: Colors.teal.withOpacity(0.1),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quantity is required';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Quantity must be a valid number greater than 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: widget.removeorderitem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
