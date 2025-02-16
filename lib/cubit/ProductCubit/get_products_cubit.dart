import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/ProductCubit/get_product_state.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> originalProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];

  void getProducts(int categoryID) async {
    try {
      originalProducts = await dbHelper
          .retrieveProducts(categoryId: categoryID);
      filteredProducts =
          originalProducts;
      if(originalProducts.isEmpty && filteredProducts.isEmpty){
        emit(ProductsEmpty());
        return;
      }
      emit(ProductsLoaded(products: filteredProducts));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = originalProducts;
    } else {
      filteredProducts = originalProducts
          .where((category) =>
              category['Name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(ProductsLoaded(products: filteredProducts));
  }

  Future<void> addProduct(
    String name,
    String description,
    double price,
    int stockQuantity,
    int categoryID,
  ) async {
    try {
      await dbHelper.addProduct(
        name: name,
        description: description,
        price: price,
        stockQuantity: stockQuantity,
        categoryId: categoryID,
      );
      getProducts(categoryID);
    } catch (e) {
      emit(ProductsError(message: 'Failed to add product'));
    }
  }

  Future<void> updateProduct(
      String name,
      String description,
      double price,
      int stockQuantity,
      int productID,
      int categoryID
      ) async {
    try {
      await dbHelper.updateProduct(
        name: name,
        description: description,
        price: price,
        stockQuantity: stockQuantity,
        productID: productID,
      );
      getProducts(categoryID);
    } catch (e) {
      emit(ProductsError(message: 'Failed to update product'));
    }
  }

  Future<void> deleteProduct(int productID , int categoryID) async{
    try{
      await dbHelper.deleteProduct(productID);
      getProducts(categoryID);
    } catch(e){
      emit(ProductsError(message: 'Failed to delete product'));
    }
  }
}
