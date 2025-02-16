import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/components/build_text_field.dart';

import '../../../cubit/ProductCubit/get_products_cubit.dart';

void showAddProductDialog(int categoryId, BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String productName = '';
  String productDescription = '';
  String productPrice = '';
  String productQuantity = '';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    right: 16.0,
                    left: 16,
                    top: 16,
                  ),
                  child: Text(
                    'Add New Product',
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
                  initialValue: productName,
                  onChanged: (value) => productName = value,
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
                  initialValue: productDescription,
                  onChanged: (value) => productDescription = value,
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
                  initialValue: productPrice,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => productPrice = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product Price is required';
                    }
                    // Check if the input contains any alphabetic characters
                    final containsAlphabetic =
                    RegExp(r'[a-zA-Z]').hasMatch(value);
                    // Check if the input contains any numeric characters
                    final containsNumeric = RegExp(r'[0-9]').hasMatch(value);
                    // If the input contains alphabetic characters (with or without numbers)
                    if (containsAlphabetic) {
                      return 'Only numbers are allowed ... remove Alphabetic';
                    }
                    // If the input contains only numbers, it is valid
                    if (containsNumeric) {
                      return null;
                    }
                    // If the input contains neither (e.g., special characters), return an error
                    return 'Only numbers are allowed';
                  },
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  label: 'Product Quantity',
                  initialValue: productQuantity,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => productQuantity = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product Quantity is required';
                    }
                    // Check if the input contains any alphabetic characters
                    final containsAlphabetic =
                    RegExp(r'[a-zA-Z]').hasMatch(value);
                    // Check if the input contains any numeric characters
                    final containsNumeric = RegExp(r'[0-9]').hasMatch(value);
                    // If the input contains alphabetic characters (with or without numbers)
                    if (containsAlphabetic) {
                      return 'Only numbers are allowed ... remove Alphabetic';
                    }
                    // If the input contains only numbers, it is valid
                    if (containsNumeric) {
                      return null;
                    }
                    // If the input contains neither (e.g., special characters), return an error
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
                          if (productName.isNotEmpty &&
                              productDescription.isNotEmpty &&
                              productPrice.isNotEmpty &&
                              productQuantity.isNotEmpty) {
                            context.read<ProductsCubit>().addProduct(
                              productName,
                              productDescription,
                              double.tryParse(productPrice)!,
                              int.tryParse(productQuantity)!,
                              categoryId,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Product added successfully'),
                              ),
                            );
                          }
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
                const SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      );
    },
  );

  // showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (context) {
  //     // Get screen size
  //     final screenWidth = MediaQuery.of(context).size.width;
  //     final screenHeight = MediaQuery.of(context).size.height;
  //
  //     // Define dialog width and height based on screen size
  //     final dialogWidth = screenWidth * 0.8; // 80% of screen width
  //     final dialogHeight = screenHeight * 0.55; // 60% of screen height
  //     return Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15.0),
  //       ),
  //       child: SizedBox(
  //         height: dialogHeight,
  //         width: dialogWidth,
  //         child: Form(
  //           key: formKey,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.only(
  //                   right: 16.0,
  //                   left: 16,
  //                   top: 16,
  //                 ),
  //                 child: Text(
  //                   'Add New Product',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.teal,
  //                   ),
  //                 ),
  //               ),
  //               const Divider(
  //                 color: Colors.teal,
  //                 thickness: 2,
  //                 indent: 20,
  //                 endIndent: 20,
  //               ),
  //               const SizedBox(height: 10),
  //               BuildTextField(
  //                 label: 'Product Name',
  //                 initialValue: productName,
  //                 onChanged: (value) => productName = value,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Product Name is required';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'Product Description',
  //                 initialValue: productDescription,
  //                 onChanged: (value) => productDescription = value,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Product Description is required';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'Product Price',
  //                 initialValue: productPrice,
  //                 keyboardType: TextInputType.number,
  //                 onChanged: (value) => productPrice = value,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Product Price is required';
  //                   }
  //                   // Check if the input contains any alphabetic characters
  //                   final containsAlphabetic = RegExp(r'[a-zA-Z]').hasMatch(value);
  //                   // Check if the input contains any numeric characters
  //                   final containsNumeric = RegExp(r'[0-9]').hasMatch(value);
  //                   // If the input contains alphabetic characters (with or without numbers)
  //                   if (containsAlphabetic) {
  //                     return 'Only numbers are allowed ... remove Alphabetic';
  //                   }
  //                   // If the input contains only numbers, it is valid
  //                   if (containsNumeric) {
  //                     return null;
  //                   }
  //                   // If the input contains neither (e.g., special characters), return an error
  //                   return 'Only numbers are allowed';
  //                 },
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'Product Quantity',
  //                 initialValue: productQuantity,
  //                 keyboardType: TextInputType.number,
  //                 onChanged: (value) => productQuantity = value,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Product Quantity is required';
  //                   }
  //                   // Check if the input contains any alphabetic characters
  //                   final containsAlphabetic = RegExp(r'[a-zA-Z]').hasMatch(value);
  //                   // Check if the input contains any numeric characters
  //                   final containsNumeric = RegExp(r'[0-9]').hasMatch(value);
  //                   // If the input contains alphabetic characters (with or without numbers)
  //                   if (containsAlphabetic) {
  //                     return 'Only numbers are allowed ... remove Alphabetic';
  //                   }
  //                   // If the input contains only numbers, it is valid
  //                   if (containsNumeric) {
  //                     return null;
  //                   }
  //                   // If the input contains neither (e.g., special characters), return an error
  //                   return 'Only numbers are allowed';
  //                 },
  //               ),
  //               const Spacer(),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.grey,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Cancel',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       if (formKey.currentState!.validate()) {
  //                         if (productName.isNotEmpty &&
  //                             productPrice.isNotEmpty &&
  //                             productQuantity.isNotEmpty &&
  //                             productDescription.isNotEmpty) {
  //                           context.read<ProductsCubit>().addProduct(
  //                             productName,
  //                             productDescription,
  //                             double.tryParse(productPrice)!,
  //                             int.tryParse(productQuantity)!,
  //                             categoryId,
  //                           );
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(context)
  //                               .showSnackBar(const SnackBar(
  //                             backgroundColor: Colors.green,
  //                             content: Text('Product added successfully'),
  //                           ));
  //                         }
  //                       }
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.teal,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Submit',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   },
  // );
}
