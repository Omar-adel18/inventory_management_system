abstract class ProductsState { }

final class ProductsInitial extends ProductsState { }

final class ProductsLoading extends ProductsState { }

final class ProductsLoaded extends ProductsState {
  final List<Map<String, dynamic>> products;

  ProductsLoaded({required this.products});
}

final class ProductsEmpty extends ProductsState { }

final class ProductsError extends ProductsState{
  final String message;

  ProductsError({required this.message});
}