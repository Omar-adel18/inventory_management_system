import 'package:flutter/material.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({super.key, required this.orderDateController, required this.customerIDController});
  final TextEditingController orderDateController;
  final TextEditingController customerIDController;

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        widget.orderDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Date is required';
              }
              return null;
            },
            controller: widget.orderDateController,
            decoration: InputDecoration(
              labelText: 'Date',
              labelStyle: const TextStyle(color: Colors.teal , fontWeight: FontWeight.bold),
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              filled: true,
              fillColor: Colors.teal.withOpacity(0.1),
            ),
            readOnly: true,
            onTap: _selectDate,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.customerIDController,
            decoration: InputDecoration(
              labelText: 'Customer ID',
              labelStyle: const TextStyle(color: Colors.teal , fontWeight: FontWeight.bold),
              prefixIcon: const Icon(Icons.person, color: Colors.teal),
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
                return 'Customer ID is required';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Customer ID must be a valid number greater than 0';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
