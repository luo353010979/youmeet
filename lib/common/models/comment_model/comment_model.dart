import 'order.dart';
import 'feed_comment.dart';

class CommentModel {
  String? countId;
  int? current;
  int? maxLimit;
  bool? optimizeCountSql;
  List<Order>? orders;
  int? pages;
  List<FeedComments>? records;
  bool? searchCount;
  int? size;
  int? total;

  CommentModel({
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

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    countId: json['countId'] as String?,
    current: json['current'] as int?,
    maxLimit: json['maxLimit'] as int?,
    optimizeCountSql: json['optimizeCountSql'] as bool?,
    orders: (json['orders'] as List<dynamic>?)
        ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList(),
    pages: json['pages'] as int?,
    records: (json['records'] as List<dynamic>?)
        ?.map((e) => FeedComments.fromJson(e as Map<String, dynamic>))
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
