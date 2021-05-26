class ApiResponse<T, E> {
  final T? data;
  final E? error;
  ApiResponse({
    required this.data,
    required this.error,
  });
}
