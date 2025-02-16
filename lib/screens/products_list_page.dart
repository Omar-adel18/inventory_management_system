import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/cubit/ProductCubit/get_product_state.dart';
import 'package:inventory_management_system/cubit/ProductCubit/get_products_cubit.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import 'package:inventory_management_system/models/product.dart';
import '../components/products_components/add_dialog.dart';
import '../components/products_components/product_widget.dart';

class ProductListPage extends StatefulWidget {
  static String id = 'ProductListPage';

  final int categoryId;
  final String categoryName;

  const ProductListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> allProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getProducts(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            '${widget.categoryName} Products',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 5,
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsEmpty) {
            return Center(
              child: Text(
                'No products found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (state is ProductsError) {
            return Center(child: Text(state.message));
          } else if (state is ProductsLoaded) {
            allProducts = state.products;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<ProductsCubit>()
                              .getProducts(widget.categoryId);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<ProductsCubit>()
                          .searchProducts(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.1),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final Product product = Product(
                        productID: state.products[index]['ProductID'],
                        productName: state.products[index]['Name'],
                        productDescription: state.products[index]['Description'],
                        productPrice: state.products[index]['Price'],
                        productQuantity: state.products[index]['StockQuantity'],
                        categoryID: widget.categoryId,
                      );
                      return ProductWidget(
                        product: product,
                        onDelete: () {
                          context.read<ProductsCubit>().deleteProduct(
                            product.productID,
                            widget.categoryId,
                          );
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
        onPressed: () {
          showAddProductDialog(widget.categoryId, context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}