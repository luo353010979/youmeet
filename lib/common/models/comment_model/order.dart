class Order {
  bool? asc;
  String? column;

  Order({this.asc, this.column});

  factory Order.fromJson(Map<String, dynamic> json) =>
      Order(asc: json['asc'] as bool?, column: json['column'] as String?);

  Map<String, dynamic> toJson() => {'asc': asc, 'column': column};
}
