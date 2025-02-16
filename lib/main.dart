import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/CategoriesCubit/get_categories_cubit.dart';
import 'package:inventory_management_system/cubit/CustomersCubit/get_customers_cubit.dart';
import 'package:inventory_management_system/cubit/OrdersCubit/get_orders_cubit.dart';
import 'package:inventory_management_system/cubit/ProductCubit/get_products_cubit.dart';
import 'package:inventory_management_system/utils/local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotifications();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  await Supabase.initialize(
    url: dotenv.env["url"]!,
    anonKey: dotenv.env['anonKey']!,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
        BlocProvider<OrdersCubit>(create: (context) => OrdersCubit()),
        BlocProvider<ProductsCubit>(create: (context) => ProductsCubit()),
        BlocProvider<CustomersCubit>(create: (context) => CustomersCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
