/// 国家模型
class CountryModel {
  String? id;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? chinese;
  String? english;
  String? phone;
  String? shortEn;
  String? nationalFlag;
  String? zoneId;
  dynamic appKey;

  CountryModel({
    this.id,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.chinese,
    this.english,
    this.phone,
    this.shortEn,
    this.nationalFlag,
    this.zoneId,
    this.appKey,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json['id'] as String?,
    createBy: json['createBy'] as String?,
    createTime: json['createTime'] as String?,
    updateBy: json['updateBy'] as String?,
    updateTime: json['updateTime'] as String?,
    chinese: json['chinese'] as String?,
    english: json['english'] as String?,
    phone: json['phone'] as String?,
    shortEn: json['shortEn'] as String?,
    nationalFlag: json['nationalFlag'] as String?,
    zoneId: json['zoneId'] as String?,
    appKey: json['appKey'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createBy': createBy,
    'createTime': createTime,
    'updateBy': updateBy,
    'updateTime': updateTime,
    'chinese': chinese,
    'english': english,
    'phone': phone,
    'shortEn': shortEn,
    'nationalFlag': nationalFlag,
    'zoneId': zoneId,
    'appKey': appKey,
  };
}
