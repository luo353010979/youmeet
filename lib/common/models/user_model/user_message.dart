class UserMessage {
  String? acceptAge;
  String? account;
  int? age;
  String? agoraToken;
  String? appKey;
  String? banTime;
  String? birthday;
  int? buyCar;
  int? buyHouse;
  String? channel;
  String? clockinTime;
  int? coin;
  int? concernNum;
  int? concernedNum;
  String? constellation;
  String? country;
  String? createTime;
  String? distance;
  int? drink;
  dynamic earningsBalance;
  String? education;
  int? emotionalExperience;
  String? expireTime;
  int? exposureNum;
  String? exposureTime;
  int? freeDateNum;
  int? freeMsgNum;
  int? freeNum;
  int? freeTranslateNum;
  String? freezeReason;
  String? freezeTime;
  String? friendNeedType;
  int? giftNum;
  String? header;
  int? height;
  String? id;
  int? income;
  String? hobby;
  String? insomniaDuration;
  String? ip;
  int? isAccount;
  int? isBelieve;
  int? isConcern;
  int? isCredit;
  int? isFreeze;
  int? isHealth;
  int? isLocation;
  int? isMessage;
  int? isPayTaxes;
  int? isPersonality;
  int? isReal;
  int? isRealName;
  int? isRenew;
  int? isSend;
  String? job;
  int? language;
  String? latitude;
  int? likeNum;
  int? likedNum;
  String? longitude;
  String? name;
  String? nationalFlag;
  String? nighttimeStatus;
  int? nobleGrade;
  int? notifyType;
  int? num;
  int? online;
  String? onlineTime;
  String? password;
  String? pcode;
  String? phoneAreaCode;
  String? pic;
  String? pid;
  String? portrait;
  String? profile;
  int? sendCoin;
  int? seq;
  String? setBedtime;
  int? sex;
  String? shortEn;
  String? sleepOnsetDuration;
  int? status;
  int? type;
  String? updateTime;
  String? userId;
  String? vcr;
  int? viewNum;
  int? viewedNum;
  int? weight;
  String? zoneId;

  UserMessage({
    this.acceptAge,
    this.account,
    this.age,
    this.agoraToken,
    this.appKey,
    this.banTime,
    this.birthday,
    this.buyCar,
    this.buyHouse,
    this.channel,
    this.clockinTime,
    this.coin,
    this.concernNum,
    this.concernedNum,
    this.constellation,
    this.country,
    this.createTime,
    this.distance,
    this.drink,
    this.earningsBalance,
    this.education,
    this.emotionalExperience,
    this.expireTime,
    this.exposureNum,
    this.exposureTime,
    this.freeDateNum,
    this.freeMsgNum,
    this.freeNum,
    this.freeTranslateNum,
    this.freezeReason,
    this.freezeTime,
    this.friendNeedType,
    this.giftNum,
    this.header,
    this.height,
    this.id,
    this.income,
    this.insomniaDuration,
    this.ip,
    this.isAccount,
    this.isBelieve,
    this.isConcern,
    this.isCredit,
    this.isFreeze,
    this.isHealth,
    this.isLocation,
    this.isMessage,
    this.isPayTaxes,
    this.isPersonality,
    this.isReal,
    this.isRealName,
    this.isRenew,
    this.isSend,
    this.job,
    this.hobby,
    this.language,
    this.latitude,
    this.likeNum,
    this.likedNum,
    this.longitude,
    this.name,
    this.nationalFlag,
    this.nighttimeStatus,
    this.nobleGrade,
    this.notifyType,
    this.num,
    this.online,
    this.onlineTime,
    this.password,
    this.pcode,
    this.phoneAreaCode,
    this.pic,
    this.pid,
    this.portrait,
    this.profile,
    this.sendCoin,
    this.seq,
    this.setBedtime,
    this.sex,
    this.shortEn,
    this.sleepOnsetDuration,
    this.status,
    this.type,
    this.updateTime,
    this.userId,
    this.vcr,
    this.viewNum,
    this.viewedNum,
    this.weight,
    this.zoneId,
  });

  factory UserMessage.fromJson(Map<String, dynamic> json) => UserMessage(
    acceptAge: json['acceptAge'] as String?,
    account: json['account'] as String?,
    age: json['age'] as int?,
    agoraToken: json['agoraToken'] as String?,
    appKey: json['appKey'] as String?,
    banTime: json['banTime'] as String?,
    birthday: json['birthday'] as String?,
    buyCar: json['buyCar'] as int?,
    buyHouse: json['buyHouse'] as int?,
    channel: json['channel'] as String?,
    clockinTime: json['clockinTime'] as String?,
    coin: json['coin'] as int?,
    concernNum: json['concernNum'] as int?,
    concernedNum: json['concernedNum'] as int?,
    constellation: json['constellation'] as String?,
    country: json['country'] as String?,
    createTime: json['createTime'] as String?,
    distance: json['distance'] as String?,
    drink: json['drink'] as int?,
    earningsBalance: json['earningsBalance'],
    education: json['education'] as String?,
    emotionalExperience: json['emotionalExperience'] as int?,
    expireTime: json['expireTime'] as String?,
    exposureNum: json['exposureNum'] as int?,
    exposureTime: json['exposureTime'] as String?,
    freeDateNum: json['freeDateNum'] as int?,
    freeMsgNum: json['freeMsgNum'] as int?,
    freeNum: json['freeNum'] as int?,
    freeTranslateNum: json['freeTranslateNum'] as int?,
    freezeReason: json['freezeReason'] as String?,
    freezeTime: json['freezeTime'] as String?,
    friendNeedType: json['friendNeedType'] as String?,
    giftNum: json['giftNum'] as int?,
    header: json['header'] as String?,
    height: json['height'] as int?,
    hobby: json['hobby'] as String?,
    id: json['id'] as String?,
    income: json['income'] as int?,
    insomniaDuration: json['insomniaDuration'] as String?,
    ip: json['ip'] as String?,
    isAccount: json['isAccount'] as int?,
    isBelieve: json['isBelieve'] as int?,
    isConcern: json['isConcern'] as int?,
    isCredit: json['isCredit'] as int?,
    isFreeze: json['isFreeze'] as int?,
    isHealth: json['isHealth'] as int?,
    isLocation: json['isLocation'] as int?,
    isMessage: json['isMessage'] as int?,
    isPayTaxes: json['isPayTaxes'] as int?,
    isPersonality: json['isPersonality'] as int?,
    isReal: json['isReal'] as int?,
    isRealName: json['isRealName'] as int?,
    isRenew: json['isRenew'] as int?,
    isSend: json['isSend'] as int?,
    job: json['job'] as String?,
    language: json['language'] as int?,
    latitude: json['latitude'] as String?,
    likeNum: json['likeNum'] as int?,
    likedNum: json['likedNum'] as int?,
    longitude: json['longitude'] as String?,
    name: json['name'] as String?,
    nationalFlag: json['nationalFlag'] as String?,
    nighttimeStatus: json['nighttimeStatus'] as String?,
    nobleGrade: json['nobleGrade'] as int?,
    notifyType: json['notifyType'] as int?,
    num: json['num'] as int?,
    online: json['online'] as int?,
    onlineTime: json['onlineTime'] as String?,
    password: json['password'] as String?,
    pcode: json['pcode'] as String?,
    phoneAreaCode: json['phoneAreaCode'] as String?,
    pic: json['pic'] as String?,
    pid: json['pid'] as String?,
    portrait: json['portrait'] as String?,
    profile: json['profile'] as String?,
    sendCoin: json['sendCoin'] as int?,
    seq: json['seq'] as int?,
    setBedtime: json['setBedtime'] as String?,
    sex: json['sex'] as int?,
    shortEn: json['shortEn'] as String?,
    sleepOnsetDuration: json['sleepOnsetDuration'] as String?,
    status: json['status'] as int?,
    type: json['type'] as int?,
    updateTime: json['updateTime'] as String?,
    userId: json['userId'] as String?,
    vcr: json['vcr'] as String?,
    viewNum: json['viewNum'] as int?,
    viewedNum: json['viewedNum'] as int?,
    weight: json['weight'] as int?,
    zoneId: json['zoneId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'acceptAge': acceptAge,
    'account': account,
    'age': age,
    'agoraToken': agoraToken,
    'appKey': appKey,
    'banTime': banTime,
    'birthday': birthday,
    'buyCar': buyCar,
    'buyHouse': buyHouse,
    'channel': channel,
    'clockinTime': clockinTime,
    'coin': coin,
    'concernNum': concernNum,
    'concernedNum': concernedNum,
    'constellation': constellation,
    'country': country,
    'createTime': createTime,
    'distance': distance,
    'drink': drink,
    'earningsBalance': earningsBalance,
    'education': education,
    'emotionalExperience': emotionalExperience,
    'expireTime': expireTime,
    'exposureNum': exposureNum,
    'exposureTime': exposureTime,
    'freeDateNum': freeDateNum,
    'freeMsgNum': freeMsgNum,
    'freeNum': freeNum,
    'freeTranslateNum': freeTranslateNum,
    'freezeReason': freezeReason,
    'freezeTime': freezeTime,
    'friendNeedType': friendNeedType,
    'giftNum': giftNum,
    'header': header,
    'height': height,
    'id': id,
    'income': income,
    'insomniaDuration': insomniaDuration,
    'ip': ip,
    'isAccount': isAccount,
    'isBelieve': isBelieve,
    'hobby':hobby,
    'isConcern': isConcern,
    'isCredit': isCredit,
    'isFreeze': isFreeze,
    'isHealth': isHealth,
    'isLocation': isLocation,
    'isMessage': isMessage,
    'isPayTaxes': isPayTaxes,
    'isPersonality': isPersonality,
    'isReal': isReal,
    'isRealName': isRealName,
    'isRenew': isRenew,
    'isSend': isSend,
    'job': job,
    'language': language,
    'latitude': latitude,
    'likeNum': likeNum,
    'likedNum': likedNum,
    'longitude': longitude,
    'name': name,
    'nationalFlag': nationalFlag,
    'nighttimeStatus': nighttimeStatus,
    'nobleGrade': nobleGrade,
    'notifyType': notifyType,
    'num': num,
    'online': online,
    'onlineTime': onlineTime,
    'password': password,
    'pcode': pcode,
    'phoneAreaCode': phoneAreaCode,
    'pic': pic,
    'pid': pid,
    'portrait': portrait,
    'profile': profile,
    'sendCoin': sendCoin,
    'seq': seq,
    'setBedtime': setBedtime,
    'sex': sex,
    'shortEn': shortEn,
    'sleepOnsetDuration': sleepOnsetDuration,
    'status': status,
    'type': type,
    'updateTime': updateTime,
    'userId': userId,
    'vcr': vcr,
    'viewNum': viewNum,
    'viewedNum': viewedNum,
    'weight': weight,
    'zoneId': zoneId,
  };
}
