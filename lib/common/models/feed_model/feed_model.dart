import 'feed_record.dart';

class FeedModel {
  List<FeedRecord>? records;
  int? total;
  int? size;
  int? current;
  List<dynamic>? orders;
  bool? optimizeCountSql;
  bool? searchCount;
  dynamic countId;
  dynamic maxLimit;
  int? pages;

  FeedModel({
    this.records,
    this.total,
    this.size,
    this.current,
    this.orders,
    this.optimizeCountSql,
    this.searchCount,
    this.countId,
    this.maxLimit,
    this.pages,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    records: (json['records'] as List<dynamic>?)
        ?.map((e) => FeedRecord.fromJson(e as Map<String, dynamic>))
        .toList(),
    total: json['total'] as int?,
    size: json['size'] as int?,
    current: json['current'] as int?,
    orders: json['orders'] as List<dynamic>?,
    optimizeCountSql: json['optimizeCountSql'] as bool?,
    searchCount: json['searchCount'] as bool?,
    countId: json['countId'] as dynamic,
    maxLimit: json['maxLimit'] as dynamic,
    pages: json['pages'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'records': records?.map((e) => e.toJson()).toList(),
    'total': total,
    'size': size,
    'current': current,
    'orders': orders,
    'optimizeCountSql': optimizeCountSql,
    'searchCount': searchCount,
    'countId': countId,
    'maxLimit': maxLimit,
    'pages': pages,
  };
}
