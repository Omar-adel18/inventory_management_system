import 'package:flutter/material.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';

class CustomerDetailsPage extends StatelessWidget {
  static const String id = 'CustomerDetailsPage';

  const CustomerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments from the navigation
    final Map<String, dynamic> customer =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final customerID = customer['id'];
    final customerName = customer['name'];
    final customerEmail = customer['email'];
    final customerAddress = customer['street'] +
        ' street ' +
        customer['zone'] +
        ' - ' +
        customer['city'];
    final dpHelper = DatabaseHelper();

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for overall feel
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Customer Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.teal, // A nice accent color for the app bar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          // Assuming db is already opened and passed to this widget
          future: Future.wait([
            dpHelper.getRecentOrdersPerCustomer(customerID),
            dpHelper.getTotalSpend(customerID),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Extract results from the snapshot
            final recentOrders =
                snapshot.data![0] as List<Map<String, dynamic>>;
            final totalSpend = snapshot.data![1] as double;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information Section
                  _buildSectionTitle('Customer Information'),
                  _buildInfoTile('Customer ID', '$customerID'),
                  _buildInfoTile('Name', customerName),
                  _buildInfoTile('Email', customerEmail),
                  _buildInfoTile('Address', customerAddress),
                  const SizedBox(height: 16),

                  // Total Spent Section
                  _buildSectionTitle('Total Spent'),
                  Text(
                    '\$${totalSpend.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recent Orders Section
                  _buildSectionTitle('Recent Orders'),
                  if (recentOrders.isEmpty)
                    const Text('No recent orders found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey))
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recentOrders.length,
                      itemBuilder: (context, index) {
                        final order = recentOrders[index];
                        final orderID = order['OrderID'];
                        return FutureBuilder<String?>(
                          future: dpHelper.getCategoryNameByProductName(
                              order['ProductName']), // Your async function
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Show a loading indicator while waiting for the category name
                              return
                                Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  title: Row(
                                    children: [
                                      const Icon(Icons.shopping_cart,
                                          color: Colors.teal, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          order['ProductName'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        '(Order ID: $orderID)',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  subtitle:
                                      const CircularProgressIndicator(), // Loading indicator
                                ),
                              );
                            } else if (snapshot.hasError) {
                              // Handle errors
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  title: Text(
                                    'Error loading category for ${order['ProductName']}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              // Build the order card with the fetched category name
                              final categoryName = snapshot.data!;
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  title: Row(
                                    children: [
                                      const Icon(Icons.shopping_cart,
                                          color: Colors.teal, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          order['ProductName'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        '(Order ID: $orderID)',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Category: $categoryName',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const Spacer(),
                                          Text('Date: ${order['OrderDate']}')
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('Quantity: ${order['Quantity']}',
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                          const Spacer(),
                                          Text(
                                            '\$${(order['TotalPrice'] as double).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              // Handle the case where no data is returned
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  title: Text(
                                    'No category data for ${order['ProductName']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper Widget to Build Section Titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  // Helper Widget to Build Info Tiles (for Customer Information)
  Widget _buildInfoTile(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(title),
        subtitle: Text(content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

}
