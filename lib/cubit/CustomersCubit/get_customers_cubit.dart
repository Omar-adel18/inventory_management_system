import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/CustomersCubit/get_customers_states.dart';
import '../../utils/databasehelper.dart';

class CustomersCubit extends Cubit<CustomersState>{
  CustomersCubit() : super(CustomersInitial());
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> originalCustomers = [];
  List<Map<String, dynamic>> filteredCustomers = [];

  void getCustomers() async{
    try {
      originalCustomers = await dbHelper.retrieveCustomers();
      filteredCustomers = originalCustomers;
      if(originalCustomers.isEmpty && filteredCustomers.isEmpty){
        emit(CustomersEmpty());
        return;
      }
      emit(CustomersLoaded(customers: filteredCustomers));
    } catch (e) {
      emit(CustomersError(message: e.toString()));
    }
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers = originalCustomers;
    } else {
      filteredCustomers = originalCustomers
          .where((customer) =>
          customer['CustomerName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(CustomersLoaded(customers: filteredCustomers));
  }

  Future<void> addCustomer(
      String name,
      String email,
      String street,
      String zone,
      String city,
      ) async {
    try {
      await dbHelper.addCustomer(
        name: name,
        email: email,
        street: street,
        zone: zone,
        city: city,
      );
      getCustomers();
    } catch (e) {
      emit(CustomersError(message: 'Failed to add product'));
    }
  }

  Future<void> updateCustomer(
      int customerID,
      String name,
      String email,
      String street,
      String zone,
      String city,
      ) async {
    try {
      await dbHelper.updateCustomer(
        customerID: customerID,
        name: name,
        email: email,
        street: street,
        zone: zone,
        city: city,
      );
      getCustomers();
    } catch (e) {
      emit(CustomersError(message: 'Failed to add product'));
    }
  }

  Future<void> deleteCustomer(int customerID) async{
    try{
      await dbHelper.deleteCustomer(customerID: customerID);
      getCustomers();
    } catch(e){
      emit(CustomersError(message: 'Failed to delete product'));
    }
  }

}