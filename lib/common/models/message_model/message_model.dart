import 'message.dart';

class MessageModel {
  int? current;
  int? pages;
  List<Message>? records;
  int? size;
  int? total;

  MessageModel({this.current, this.pages, this.records, this.size, this.total});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    current: json['current'] as int?,
    pages: json['pages'] as int?,
    records: (json['records'] as List<dynamic>?)
        ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
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
