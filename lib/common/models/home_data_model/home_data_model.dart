import '../comment_model/order.dart';
import '../user_model/user_message.dart';

class HomeDataModel {
  String? countId;
  int? current;
  int? maxLimit;
  bool? optimizeCountSql;
  List<Order>? orders;
  int? pages;
  List<UserMessage>? records;
  bool? searchCount;
  int? size;
  int? total;

  HomeDataModel({
    this.countId,
    this.current,
    this.maxLimit,
    this.optimizeCountSql,
    this.orders,
    this.pages,
    this.records,
    this.searchCount,
    this.size,
    this.total,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
    countId: json['countId'] as String?,
    current: json['current'] as int?,
    maxLimit: json['maxLimit'] as int?,
    optimizeCountSql: json['optimizeCountSql'] as bool?,
    orders: (json['orders'] as List<dynamic>?)
        ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList(),
    pages: json['pages'] as int?,
    records: (json['records'] as List<dynamic>?)
        ?.map((e) => UserMessage.fromJson(e as Map<String, dynamic>))
        .toList(),
    searchCount: json['searchCount'] as bool?,
    size: json['size'] as int?,
    total: json['total'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'countId': countId,
    'current': current,
    'maxLimit': maxLimit,
    'optimizeCountSql': optimizeCountSql,
    'orders': orders?.map((e) => e.toJson()).toList(),
    'pages': pages,
    'records': records?.map((e) => e.toJson()).toList(),
    'searchCount': searchCount,
    'size': size,
    'total': total,
  };
}
