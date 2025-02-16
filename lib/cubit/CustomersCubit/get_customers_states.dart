abstract class CustomersState{ }

final class CustomersInitial extends CustomersState { }

final class CustomersLoading extends CustomersState { }

final class CustomersLoaded extends CustomersState {
  final List<Map<String, dynamic>> customers;

  CustomersLoaded({required this.customers});
}

final class CustomersEmpty extends CustomersState { }

final class CustomersError extends CustomersState{
  final String message;

  CustomersError({required this.message});
}
