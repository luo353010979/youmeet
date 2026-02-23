/// 通用响应模型
class BaseResponse<T> {
  bool success;
  String message;
  int code;
  T? result;
  int timestamp;

  BaseResponse({
    required this.success,
    required this.message,
    required this.code,
    this.result,
    required this.timestamp,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => BaseResponse(
    success: json['success'] as bool,
    message: json['message'] as String,
    code: json['code'] as int,
    result: json['result'] != null ? fromJsonT(json['result']) : null,
    timestamp: json['timestamp'] as int,
  );

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => {
    'success': success,
    'message': message,
    'code': code,
    'result': result != null ? toJsonT(result as T) : null,
    'timestamp': timestamp,
  };
}
