class ApiResponse<T> {
  final int status;
  final bool success;
  final T? data;
  final String message;

  ApiResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'],
      success: json['body']['success'],
      data: json['body']['data'] != null && fromJsonT != null
          ? fromJsonT(json['body']['data'])
          : json['body']['data'],
      message: json['body']['message'],
    );
  }
}