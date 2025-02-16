import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/components/build_text_field.dart';
import '../../../cubit/CustomersCubit/get_customers_cubit.dart';

void showEditDialog({
  required BuildContext context,
  required String customerName,
  required String customerEmail,
  required String street,
  required String zone,
  required String city,
  required int customerId,
}) {
  final formKey = GlobalKey<FormState>();
  String updatedName = customerName;
  String updatedEmail = customerEmail;
  String updatedCity = city;
  String updatedStreet = street;
  String updatedZone = zone;



  showModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
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
                    'Edit Customer',
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
                  initialValue: updatedName,
                  onChanged: (value) {
                    updatedName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer Name is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BuildTextField(
                  label: 'Customer Email',
                  initialValue: updatedEmail,
                  onChanged: (value) {
                    updatedEmail = value;
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
                const SizedBox(
                  height: 20,
                ),
                BuildTextField(
                  label: 'Street',
                  initialValue: updatedStreet,
                  onChanged: (value) {
                    updatedStreet = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Street is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BuildTextField(
                  label: 'Zone',
                  initialValue: updatedZone,
                  onChanged: (value) {
                    updatedZone = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zone is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BuildTextField(
                  label: 'City',
                  initialValue: updatedCity,
                  onChanged: (value) {
                    updatedCity = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<CustomersCubit>().getCustomers();
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
                          context.read<CustomersCubit>().updateCustomer(
                                customerId,
                                updatedName,
                                updatedEmail,
                                updatedStreet,
                                updatedZone,
                                updatedCity,
                              );
                          Navigator.pop(context); // Close dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Customer Updated successfully')),
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
