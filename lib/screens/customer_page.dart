import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/CustomersCubit/get_customers_cubit.dart';
import 'package:inventory_management_system/cubit/CustomersCubit/get_customers_states.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import 'package:inventory_management_system/models/customer.dart';

import '../components/customers_components/add_dialog.dart';
import '../components/customers_components/customer_widget.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final dpHelper = DatabaseHelper();
  List<Map<String, dynamic>> allCustomers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomersCubit>().getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<CustomersCubit, CustomersState>(
        builder: (context, state) {
          if (state is CustomersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomersEmpty) {
            return const Center(child: Text('No customers found'));
          } else if (state is CustomersError) {
            return Center(child: Text(state.message));
          } else if (state is CustomersLoaded) {
            allCustomers = state.customers;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Customers...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<CustomersCubit>().getCustomers();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<CustomersCubit>()
                          .searchCustomers(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      final Customer customer = Customer(
                        customerId: state.customers[index]['CustomerID'],
                        customerName: state.customers[index]['CustomerName'],
                        customerEmail: state.customers[index]['CustomerEmail'],
                        city: state.customers[index]['City'],
                        zone: state.customers[index]['Zone'],
                        street: state.customers[index]['Street'],
                      );
                      return CustomerWidget(
                        customer: customer,
                        onDelete: () {
                          context
                              .read<CustomersCubit>()
                              .deleteCustomer(customer.customerId);
                        },
                        onUpdate: () {
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showCustomerDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}