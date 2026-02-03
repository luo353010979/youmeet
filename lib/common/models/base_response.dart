/// 通用响应模型
class BaseResponse<T> {
  bool? success;
  String? message;
  int? code;
  T? result;
  int? timestamp;

  BaseResponse({
    this.success,
    this.message,
    this.code,
    this.result,
    this.timestamp,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => BaseResponse(
    success: json['success'] as bool?,
    message: json['message'] as String?,
    code: json['code'] as int?,
    result: json['result'] == null ? null : fromJsonT(json['result']),
    timestamp: json['timestamp'] as int?,
  );

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => {
    'success': success,
    'message': message,
    'code': code,
    'result': result == null ? null : toJsonT(result as T),
    'timestamp': timestamp,
  };
}
