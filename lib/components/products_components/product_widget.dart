import 'package:flutter/material.dart';
import 'package:inventory_management_system/components/products_components/handle_delete.dart';
import 'package:inventory_management_system/components/products_components/edit_dialog.dart';
import 'package:inventory_management_system/utils/auth_service.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import 'package:inventory_management_system/models/product.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.onDelete,
    required this.onUpdate,
    required this.product,
  });

  final Product product;
  final Function() onDelete;
  final Function() onUpdate;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final dbHelper = DatabaseHelper();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userRole = authService.getCurrentUserRole();
    return GestureDetector(
      onLongPress: () {
        if (userRole == 'admin' || userRole == 'staff') {
          showEditDialog(
            context: context,
            productName: widget.product.productName,
            productDescription: widget.product.productDescription,
            productPrice: widget.product.productPrice,
            productQuantity: widget.product.productQuantity,
            productID: widget.product.productID,
            categoryID: widget.product.categoryID,
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product ID: ${widget.product.productID}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if(userRole == 'admin')
                    IconButton(
                      onPressed: () {
                        handleDelete(context, widget.onDelete);
                      },
                      icon: const Icon(Icons.delete),
                    )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Name: ${widget.product.productName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${widget.product.productDescription}',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color.fromARGB(255, 82, 82, 82),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price: \$${widget.product.productPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Quantity: ${widget.product.productQuantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
