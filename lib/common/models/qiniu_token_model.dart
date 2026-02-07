class QiNiuTokenModel {
  String? key;
  String? token;

  QiNiuTokenModel({this.key, this.token});

  factory QiNiuTokenModel.fromJson(Map<String, dynamic> json) {
    return QiNiuTokenModel(
      key: json['key'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'token': token};
}
