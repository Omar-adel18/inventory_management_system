import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/components/customers_components/edit_dialog.dart';
import 'package:inventory_management_system/components/customers_components/handle_delete.dart';
import 'package:inventory_management_system/cubit/CustomersCubit/get_customers_cubit.dart';
import 'package:inventory_management_system/utils/auth_service.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import 'package:inventory_management_system/models/customer.dart';
import 'package:inventory_management_system/screens/customer_details_page.dart';

class CustomerWidget extends StatefulWidget {
  final Customer customer;
  final Function() onDelete;
  final Function() onUpdate;

  const CustomerWidget({
    super.key,
    required this.onDelete,
    required this.onUpdate,
    required this.customer,
  });

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  final dbHelper = DatabaseHelper();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userRole = authService.getCurrentUserRole(); // Get the user's role
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CustomerDetailsPage.id,
          arguments: {
            'id': widget.customer.customerId,
            'name': widget.customer.customerName,
            'email': widget.customer.customerEmail,
            'street': widget.customer.street,
            'zone': widget.customer.zone,
            'city': widget.customer.city,
          },
        );
      },
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.green,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Center(
                  child: Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            // Only allow delete for admin
            if (userRole == 'admin') {
              handleDelete(context, widget.onDelete);
              context.read<CustomersCubit>().getCustomers();
            } else {
              // Show SnackBar for unauthorized delete action
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Only admins can delete customers'),
                    duration: Duration(seconds: 2),
                  ),
                );
                context.read<CustomersCubit>().getCustomers();
              }
            }
          } else if (direction == DismissDirection.endToStart) {
            // Allow edit for admin and staff
            if (userRole == 'admin' || userRole == 'staff') {
              showEditDialog(
                context: context,
                customerName: widget.customer.customerName,
                customerEmail: widget.customer.customerEmail,
                street: widget.customer.street,
                zone: widget.customer.zone,
                city: widget.customer.city,
                customerId: widget.customer.customerId,
              );
              context.read<CustomersCubit>().getCustomers();
            } else {
              // Show SnackBar for unauthorized edit action
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Only admins and staff can edit customers'),
                    duration: Duration(seconds: 2),
                  ),
                );
                context.read<CustomersCubit>().getCustomers();
              }
            }
          }
        },
        // confirmDismiss: (direction) async {
        //   // Prevent dismissal if the user doesn't have the required role
        //   if (direction == DismissDirection.startToEnd) {
        //     return userRole == 'admin'; // Only allow delete for admin
        //   } else if (direction == DismissDirection.endToStart) {
        //     return userRole == 'admin' || userRole == 'staff'; // Allow edit for admin and staff
        //   }
        //   return false;
        // },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                widget.customer.customerName[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              widget.customer.customerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(widget.customer.customerEmail),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}