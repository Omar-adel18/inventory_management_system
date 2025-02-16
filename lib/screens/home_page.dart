import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/CategoriesCubit/get_categories_cubit.dart';
import 'package:inventory_management_system/cubit/CustomersCubit/get_customers_cubit.dart';
import 'package:inventory_management_system/cubit/OrdersCubit/get_orders_cubit.dart';
import 'package:inventory_management_system/screens/categories_page.dart';
import 'package:inventory_management_system/screens/customer_page.dart';
import 'package:inventory_management_system/screens/login_page.dart';
import 'package:inventory_management_system/screens/notification_page.dart';
import 'package:inventory_management_system/screens/orders_page.dart';
import '../utils/auth_service.dart';
import '../utils/databasehelper.dart';
import 'dashboard_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final authService = AuthService();
  final dbHelper = DatabaseHelper();
  final List<Widget> _screens = [
    const CategoriesPage(),
    const OrdersPage(),
    const CustomersPage(),
    DashboardScreen(),
  ];

  void logout() async {
    await authService.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Wrap(
          // runSpacing: 10,
          // padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              color: Colors.teal,
              padding: EdgeInsets.only(
                top: 50,
                bottom: 24,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: const Icon(
                          Icons.face,
                          size: 48,
                          color: Colors.black,
                        ),
                      )),
                  Text(
                    authService.getCurrentUserName().toString(),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    authService.getCurrentUserEmail().toString(),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // UserAccountsDrawerHeader(
            //   accountName: Padding(
            //     padding: const EdgeInsets.only(left: 10.0),
            //     child: Text(authService.getCurrentUserName().toString()),
            //   ),
            //   accountEmail: Padding(
            //     padding: const EdgeInsets.only(left: 10.0),
            //     child: Text(authService.getCurrentUserEmail().toString()),
            //   ),
            //   currentAccountPicture: Icon(
            //     Icons.face,
            //     size: 48,
            //     color: Colors.white,
            //   ),
            //   currentAccountPictureSize: Size.square(70),
            // ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home Page',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text(
                'Notification',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationsPage())),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Invent',
                style: TextStyle(
                  // color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'Ease',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              )
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              onPressed: () {
                dbHelper.deleteAllRows();
                context.read<CategoriesCubit>().getCategories();
                context.read<OrdersCubit>().getOrders();
                context.read<CustomersCubit>().getCustomers();
              },
              icon: Icon(Icons.delete),
            ),
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/category.png',
              width: 20,
              height: 23,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/order.png',
              width: 20,
              height: 23,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/customer.png',
              width: 25,
              height: 25,
            ),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/dashboard.png',
              width: 20,
              height: 23,
            ),
            label: 'DashBoard',
          ),
        ],
      ),
    );
  }
}
