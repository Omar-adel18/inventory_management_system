import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/components/categories_components/edit_dialog.dart';
import 'package:inventory_management_system/cubit/CategoriesCubit/get_categories_cubit.dart';
import 'package:inventory_management_system/utils/auth_service.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import 'package:inventory_management_system/screens/products_list_page.dart';
import '../components/categories_components/add_dialog.dart';
import '../components/categories_components/category_widget.dart';
import '../cubit/CategoriesCubit/get_categories_states.dart';
import '../models/category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final dpHelper = DatabaseHelper();
  final authService = AuthService();
  List<Map<String, dynamic>> allCategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dpHelper.printDatabasePath();
    log('User Email : ${authService.getCurrentUserEmail().toString()}');
    log("User Name :${authService.getCurrentUserName()}");
    log('User Role : ${authService.getCurrentUserRole().toString()}');
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = authService.getCurrentUserRole();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
            if (state is CategoriesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CategoriesEmpty) {
              return Center(
                child: Text(
                  'No categories found',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else if (state is CategoriesError) {
              return Center(child: Text(state.message));
            } else if (state is CategoriesLoaded) {
              allCategories = state.categories;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search category...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<CategoriesCubit>().getCategories();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        context
                            .read<CategoriesCubit>()
                            .searchCategories(value);
                      },
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.1),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final Category category = Category(
                        categoryID: state.categories[index]['CategoryID'],
                        name: state.categories[index]['Name'],
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListPage(
                                categoryId: category.categoryID,
                                categoryName: category.name,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          if(userRole == 'admin' || userRole == 'staff'){
                            showEditCategoryDialog(
                              context,
                              category.categoryID,
                              category.name,
                            );
                          }
                        },
                        child: CategoryWidget(
                          category: category,
                          userRole: userRole,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Container();
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCategoryDialog(context);
        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
