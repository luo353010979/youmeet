/// 用户注册请求模型
class UserRegisterReq {
  String? account;
  String? appId;
  String? birthday;
  String? code;
  String? country;
  String? friendNeedType;
  String? insomniaDuration;
  String? invitationCode;
  String? name;
  int? nighttimeStatus1;
  int? nighttimeStatus2;
  int? nighttimeStatus3;
  int? nighttimeStatus4;
  String? password;
  String? phoneAreaCode;
  String? pic;
  String? portrait;
  String? realPic;
  String? setBedtime;
  int? sex;
  String? shortEn;
  String? sleepOnsetDuration;
  String? vcr;
  String? zoneId;

  UserRegisterReq({
    this.account,
    this.appId,
    this.birthday,
    this.code,
    this.country,
    this.friendNeedType,
    this.insomniaDuration,
    this.invitationCode,
    this.name,
    this.nighttimeStatus1,
    this.nighttimeStatus2,
    this.nighttimeStatus3,
    this.nighttimeStatus4,
    this.password,
    this.phoneAreaCode,
    this.pic,
    this.portrait,
    this.realPic,
    this.setBedtime,
    this.sex,
    this.shortEn,
    this.sleepOnsetDuration,
    this.vcr,
    this.zoneId,
  });

  factory UserRegisterReq.fromJson(Map<String, dynamic> json) {
    return UserRegisterReq(
      account: json['account'] as String?,
      appId: json['appId'] as String?,
      birthday: json['birthday'] as String?,
      code: json['code'] as String?,
      country: json['country'] as String?,
      friendNeedType: json['friendNeedType'] as String?,
      insomniaDuration: json['insomniaDuration'] as String?,
      invitationCode: json['invitationCode'] as String?,
      name: json['name'] as String?,
      nighttimeStatus1: json['nighttimeStatus1'] as int?,
      nighttimeStatus2: json['nighttimeStatus2'] as int?,
      nighttimeStatus3: json['nighttimeStatus3'] as int?,
      nighttimeStatus4: json['nighttimeStatus4'] as int?,
      password: json['password'] as String?,
      phoneAreaCode: json['phoneAreaCode'] as String?,
      pic: json['pic'] as String?,
      portrait: json['portrait'] as String?,
      realPic: json['realPic'] as String?,
      setBedtime: json['setBedtime'] as String?,
      sex: json['sex'] as int?,
      shortEn: json['shortEn'] as String?,
      sleepOnsetDuration: json['sleepOnsetDuration'] as String?,
      vcr: json['vcr'] as String?,
      zoneId: json['zoneId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'account': account,
    'appId': appId,
    'birthday': birthday,
    'code': code,
    'country': country,
    'friendNeedType': friendNeedType,
    'insomniaDuration': insomniaDuration,
    'invitationCode': invitationCode,
    'name': name,
    'nighttimeStatus1': nighttimeStatus1,
    'nighttimeStatus2': nighttimeStatus2,
    'nighttimeStatus3': nighttimeStatus3,
    'nighttimeStatus4': nighttimeStatus4,
    'password': password,
    'phoneAreaCode': phoneAreaCode,
    'pic': pic,
    'portrait': portrait,
    'realPic': realPic,
    'setBedtime': setBedtime,
    'sex': sex,
    'shortEn': shortEn,
    'sleepOnsetDuration': sleepOnsetDuration,
    'vcr': vcr,
    'zoneId': zoneId,
  };
}
