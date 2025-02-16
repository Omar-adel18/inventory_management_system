abstract class CategoriesState{ }

final class CategoriesInitial extends CategoriesState{ }

final class CategoriesLoading extends CategoriesState{ }

final class CategoriesLoaded extends CategoriesState{
  final List<Map<String, dynamic>> categories;

  CategoriesLoaded({required this.categories});
}

final class CategoriesEmpty extends CategoriesState{ }

final class CategoriesError extends CategoriesState{
  final String message;

  CategoriesError({required this.message});
}

