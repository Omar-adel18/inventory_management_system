import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/components/build_text_field.dart';
import '../../../cubit/CustomersCubit/get_customers_cubit.dart';

void showCustomerDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String customerName = '';
  String customerEmail = '';
  String street = '';
  String zone = '';
  String city = '';

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
                    'Add New Customer',
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
                  label: 'Customer Name',
                  initialValue: customerName,
                  onChanged: (value) {
                    customerName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer Name is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(height: 20,),
                BuildTextField(
                  label: 'Customer Email',
                  initialValue: customerEmail,
                  onChanged: (value) {
                    customerEmail = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null; // Return null if the input is valid
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20,),
                BuildTextField(
                  label: 'Street',
                  initialValue: street,
                  onChanged: (value) {
                    street = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Street is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(height: 20,),
                BuildTextField(
                  label: 'Zone',
                  initialValue: zone,
                  onChanged: (value) {
                    zone = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zone is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(height: 20,),
                BuildTextField(
                  label: 'City',
                  initialValue: city,
                  onChanged: (value) {
                    city = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
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
                          if (customerName.isNotEmpty &&
                              customerEmail.isNotEmpty &&
                              street.isNotEmpty &&
                              zone.isNotEmpty &&
                              city.isNotEmpty) {
                            context.read<CustomersCubit>().addCustomer(
                              customerName,
                              customerEmail,
                              street,
                              zone,
                              city,
                            );
                            Navigator.pop(context); // Close dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                  Text('Customer added successfully')),
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
                const SizedBox(height: 10,),
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
  //     final dialogHeight = screenHeight * 0.6; // 60% of screen height
  //     return Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
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
  //                   'Add New Customer',
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
  //                 label: 'Customer Name',
  //                 initialValue: customerName,
  //                 onChanged: (value) {
  //                   customerName = value;
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Customer Name is required';
  //                   }
  //                   return null; // Return null if the input is valid
  //                 },
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'Customer Email',
  //                 initialValue: customerEmail,
  //                 onChanged: (value) {
  //                   customerEmail = value;
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Customer Email is required';
  //                   }
  //                   if (!value.contains('@')) {
  //                     return 'Please enter a valid email address';
  //                   }
  //                   return null; // Return null if the input is valid
  //                 },
  //                 keyboardType: TextInputType.emailAddress,
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'Street',
  //                 initialValue: street,
  //                 onChanged: (value) {
  //                   street = value;
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Street is required';
  //                   }
  //                   return null; // Return null if the input is valid
  //                 },
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'Zone',
  //                 initialValue: zone,
  //                 onChanged: (value) {
  //                   zone = value;
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Zone is required';
  //                   }
  //                   return null; // Return null if the input is valid
  //                 },
  //               ),
  //               const Spacer(),
  //               BuildTextField(
  //                 label: 'City',
  //                 initialValue: city,
  //                 onChanged: (value) {
  //                   city = value;
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'City is required';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const Spacer(),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context); // Close dialog
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
  //                         if (customerName.isNotEmpty &&
  //                             customerEmail.isNotEmpty &&
  //                             street.isNotEmpty &&
  //                             zone.isNotEmpty &&
  //                             city.isNotEmpty) {
  //                           context.read<CustomersCubit>().addCustomer(
  //                             customerName,
  //                             customerEmail,
  //                             street,
  //                             zone,
  //                             city,
  //                           );
  //                           Navigator.pop(context); // Close dialog
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                                 backgroundColor: Colors.green,
  //                                 content:
  //                                 Text('Customer added successfully')),
  //                           );
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
