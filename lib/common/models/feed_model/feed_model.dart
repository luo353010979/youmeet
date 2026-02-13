import 'feed.dart';

class FeedModel {
  int? current;
  int? pages;
  List<Feed>? records;
  int? size;
  int? total;

  FeedModel({this.current, this.pages, this.records, this.size, this.total});

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    current: json['current'] as int?,
    pages: json['pages'] as int?,
    records: (json['records'] as List<dynamic>?)
        ?.map((e) => Feed.fromJson(e as Map<String, dynamic>))
        .toList(),
    size: json['size'] as int?,
    total: json['total'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'current': current,
    'pages': pages,
    'records': records?.map((e) => e.toJson()).toList(),
    'size': size,
    'total': total,
  };
}
