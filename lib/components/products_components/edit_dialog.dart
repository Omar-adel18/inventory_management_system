import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/ProductCubit/get_products_cubit.dart';
import '../build_text_field.dart';

void showEditDialog({
  required BuildContext context,
  required String productName,
  required String productDescription,
  required double productPrice,
  required int productQuantity,
  required int productID,
  required int categoryID,
}) {
  final formKey = GlobalKey<FormState>();
  String updatedName = productName;
  String updatedDescription = productDescription;
  String updatedPrice = productPrice.toString();
  String updatedQuantity = productQuantity.toString();

  final FocusNode _nameFocusNode = FocusNode();

  showModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Text(
                    'Edit Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.teal,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  label: 'Product Name',
                  initialValue: updatedName,
                  focusNode: _nameFocusNode,
                  onChanged: (value) => updatedName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  label: 'Product Description',
                  initialValue: updatedDescription,
                  onChanged: (value) => updatedDescription = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  label: 'Product Price',
                  initialValue: updatedPrice,
                  onChanged: (value) => updatedPrice = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product Price is required';
                    }
                    final containsAlphabetic =
                    RegExp(r'[a-zA-Z]').hasMatch(value);
                    final containsNumeric =
                    RegExp(r'[0-9]').hasMatch(value);
                    if (containsAlphabetic) {
                      return 'Only numbers are allowed ... remove Alphabetic';
                    }
                    if (containsNumeric) {
                      return null;
                    }
                    return 'Only numbers are allowed';
                  },
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  label: 'Product Quantity',
                  initialValue: updatedQuantity,
                  onChanged: (value) => updatedQuantity = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product Quantity is required';
                    }
                    final containsAlphabetic =
                    RegExp(r'[a-zA-Z]').hasMatch(value);
                    final containsNumeric =
                    RegExp(r'[0-9]').hasMatch(value);
                    if (containsAlphabetic) {
                      return 'Only numbers are allowed ... remove Alphabetic';
                    }
                    if (containsNumeric) {
                      return null;
                    }
                    return 'Only numbers are allowed';
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          context.read<ProductsCubit>().updateProduct(
                            updatedName,
                            updatedDescription,
                            double.tryParse(updatedPrice)!,
                            int.tryParse(updatedQuantity)!,
                            productID,
                            categoryID,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Product Updated successfully'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
