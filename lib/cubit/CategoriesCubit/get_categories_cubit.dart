import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_categories_states.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';

class CategoriesCubit  extends Cubit<CategoriesState>{
  CategoriesCubit() : super(CategoriesInitial());
  final dpHelper = DatabaseHelper();
  List<Map<String, dynamic>> originalCategories = [];
  List<Map<String, dynamic>> filteredCategories = [];

  void getCategories() async {
    try{
      originalCategories = await dpHelper.retrieveCategories(); // Fetch and store the original list
      filteredCategories = originalCategories; // Initialize filteredCategories with the original list
      if(originalCategories.isEmpty && filteredCategories.isEmpty){
        emit(CategoriesEmpty());
        return;
      }
      emit(CategoriesLoaded(categories: filteredCategories));
    } catch(e){
      emit(CategoriesError(message: e.toString()));
    }
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories = originalCategories;
    } else {
      filteredCategories = originalCategories
          .where((category) =>
          category['Name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(CategoriesLoaded(categories: filteredCategories));
  }

  Future<void> addCategory(String name) async{
    try{
      await dpHelper.addCategory(name: name);
      getCategories();
    }
    catch(e){
      emit(CategoriesError(message: 'Failed to add category'));
    }
  }

  Future<void> updateCategory(int categoryId, String updatedName) async {
    try {
      await dpHelper.updateCategory(categoryId: categoryId, updatedName: updatedName);
      getCategories();
    } catch (e) {
      emit(CategoriesError(message: 'Failed to update category'));
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      await dpHelper.deleteCategory(categoryId);
      getCategories();
    } catch (e) {
      emit(CategoriesError(message: 'Failed to delete category'));
    }
  }
}