class Record {
  String? id;
  String? createTime;
  String? updateTime;
  String? phoneAreaCode;
  String? shortEn;
  String? country;
  String? account;
  String? portrait;
  dynamic password;
  dynamic earningsBalance;
  int? isFreeze;
  String? name;
  dynamic pid;
  String? userId;
  String? birthday;
  int? sex;
  dynamic longitude;
  dynamic latitude;
  dynamic coin;
  dynamic sendCoin;
  dynamic nobleGrade;
  dynamic expireTime;
  int? notifyType;
  int? isLocation;
  int? isPersonality;
  String? constellation;
  int? online;
  int? freeNum;
  int? freeMsgNum;
  int? freeDateNum;
  int? freeTranslateNum;
  int? type;
  dynamic onlineTime;
  String? freezeTime;
  dynamic freezeReason;
  dynamic friendNeedType;
  dynamic vcr;
  String? pic;
  String? profile;
  int? height;
  int? weight;
  dynamic language;
  dynamic acceptAge;
  dynamic emotionalExperience;
  dynamic income;
  dynamic buyCar;
  dynamic buyHouse;
  dynamic drink;
  int? status;
  String? zoneId;
  String? channel;
  int? isSend;
  dynamic isRenew;
  dynamic pcode;
  dynamic ip;
  String? banTime;
  dynamic exposureTime;
  dynamic exposureNum;
  dynamic job;
  dynamic education;
  int? isAccount;
  dynamic isRealName;
  dynamic isMessage;
  dynamic isBelieve;
  dynamic isConcern;
  int? age;
  dynamic distance;
  dynamic concernNum;
  dynamic concernedNum;
  dynamic viewNum;
  dynamic viewedNum;
  dynamic likedNum;
  dynamic likeNum;
  dynamic giftNum;
  dynamic seq;
  dynamic agoraToken;
  dynamic appKey;
  dynamic header;
  int? isReal;
  int? isHealth;
  int? isPayTaxes;
  int? isCredit;
  dynamic insomniaDuration;
  dynamic sleepOnsetDuration;
  dynamic setBedtime;
  dynamic nighttimeStatus;
  dynamic clockinTime;
  dynamic num;
  dynamic nationalFlag;
  String? isFreezeDictText;
  String? sexDictText;
  String? statusDictText;
  String? channelDictText;
  String? isAccountDictText;

  Record({
    this.id,
    this.createTime,
    this.updateTime,
    this.phoneAreaCode,
    this.shortEn,
    this.country,
    this.account,
    this.portrait,
    this.password,
    this.earningsBalance,
    this.isFreeze,
    this.name,
    this.pid,
    this.userId,
    this.birthday,
    this.sex,
    this.longitude,
    this.latitude,
    this.coin,
    this.sendCoin,
    this.nobleGrade,
    this.expireTime,
    this.notifyType,
    this.isLocation,
    this.isPersonality,
    this.constellation,
    this.online,
    this.freeNum,
    this.freeMsgNum,
    this.freeDateNum,
    this.freeTranslateNum,
    this.type,
    this.onlineTime,
    this.freezeTime,
    this.freezeReason,
    this.friendNeedType,
    this.vcr,
    this.pic,
    this.profile,
    this.height,
    this.weight,
    this.language,
    this.acceptAge,
    this.emotionalExperience,
    this.income,
    this.buyCar,
    this.buyHouse,
    this.drink,
    this.status,
    this.zoneId,
    this.channel,
    this.isSend,
    this.isRenew,
    this.pcode,
    this.ip,
    this.banTime,
    this.exposureTime,
    this.exposureNum,
    this.job,
    this.education,
    this.isAccount,
    this.isRealName,
    this.isMessage,
    this.isBelieve,
    this.isConcern,
    this.age,
    this.distance,
    this.concernNum,
    this.concernedNum,
    this.viewNum,
    this.viewedNum,
    this.likedNum,
    this.likeNum,
    this.giftNum,
    this.seq,
    this.agoraToken,
    this.appKey,
    this.header,
    this.isReal,
    this.isHealth,
    this.isPayTaxes,
    this.isCredit,
    this.insomniaDuration,
    this.sleepOnsetDuration,
    this.setBedtime,
    this.nighttimeStatus,
    this.clockinTime,
    this.num,
    this.nationalFlag,
    this.isFreezeDictText,
    this.sexDictText,
    this.statusDictText,
    this.channelDictText,
    this.isAccountDictText,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json['id'] as String?,
    createTime: json['createTime'] as String?,
    updateTime: json['updateTime'] as String?,
    phoneAreaCode: json['phoneAreaCode'] as String?,
    shortEn: json['shortEn'] as String?,
    country: json['country'] as String?,
    account: json['account'] as String?,
    portrait: json['portrait'] as String?,
    password: json['password'] as dynamic,
    earningsBalance: json['earningsBalance'] as dynamic,
    isFreeze: json['isFreeze'] as int?,
    name: json['name'] as String?,
    pid: json['pid'] as dynamic,
    userId: json['userId'] as String?,
    birthday: json['birthday'] as String?,
    sex: json['sex'] as int?,
    longitude: json['longitude'] as dynamic,
    latitude: json['latitude'] as dynamic,
    coin: json['coin'] as dynamic,
    sendCoin: json['sendCoin'] as dynamic,
    nobleGrade: json['nobleGrade'] as dynamic,
    expireTime: json['expireTime'] as dynamic,
    notifyType: json['notifyType'] as int?,
    isLocation: json['isLocation'] as int?,
    isPersonality: json['isPersonality'] as int?,
    constellation: json['constellation'] as String?,
    online: json['online'] as int?,
    freeNum: json['freeNum'] as int?,
    freeMsgNum: json['freeMsgNum'] as int?,
    freeDateNum: json['freeDateNum'] as int?,
    freeTranslateNum: json['freeTranslateNum'] as int?,
    type: json['type'] as int?,
    onlineTime: json['onlineTime'] as dynamic,
    freezeTime: json['freezeTime'] as String?,
    freezeReason: json['freezeReason'] as dynamic,
    friendNeedType: json['friendNeedType'] as dynamic,
    vcr: json['vcr'] as dynamic,
    pic: json['pic'] as String?,
    profile: json['profile'] as String?,
    height: json['height'] as int?,
    weight: json['weight'] as int?,
    language: json['language'] as dynamic,
    acceptAge: json['acceptAge'] as dynamic,
    emotionalExperience: json['emotionalExperience'] as dynamic,
    income: json['income'] as dynamic,
    buyCar: json['buyCar'] as dynamic,
    buyHouse: json['buyHouse'] as dynamic,
    drink: json['drink'] as dynamic,
    status: json['status'] as int?,
    zoneId: json['zoneId'] as String?,
    channel: json['channel'] as String?,
    isSend: json['isSend'] as int?,
    isRenew: json['isRenew'] as dynamic,
    pcode: json['pcode'] as dynamic,
    ip: json['ip'] as dynamic,
    banTime: json['banTime'] as String?,
    exposureTime: json['exposureTime'] as dynamic,
    exposureNum: json['exposureNum'] as dynamic,
    job: json['job'] as dynamic,
    education: json['education'] as dynamic,
    isAccount: json['isAccount'] as int?,
    isRealName: json['isRealName'] as dynamic,
    isMessage: json['isMessage'] as dynamic,
    isBelieve: json['isBelieve'] as dynamic,
    isConcern: json['isConcern'] as dynamic,
    age: json['age'] as int?,
    distance: json['distance'] as dynamic,
    concernNum: json['concernNum'] as dynamic,
    concernedNum: json['concernedNum'] as dynamic,
    viewNum: json['viewNum'] as dynamic,
    viewedNum: json['viewedNum'] as dynamic,
    likedNum: json['likedNum'] as dynamic,
    likeNum: json['likeNum'] as dynamic,
    giftNum: json['giftNum'] as dynamic,
    seq: json['seq'] as dynamic,
    agoraToken: json['agoraToken'] as dynamic,
    appKey: json['appKey'] as dynamic,
    header: json['header'] as dynamic,
    isReal: json['isReal'] as int?,
    isHealth: json['isHealth'] as int?,
    isPayTaxes: json['isPayTaxes'] as int?,
    isCredit: json['isCredit'] as int?,
    insomniaDuration: json['insomniaDuration'] as dynamic,
    sleepOnsetDuration: json['sleepOnsetDuration'] as dynamic,
    setBedtime: json['setBedtime'] as dynamic,
    nighttimeStatus: json['nighttimeStatus'] as dynamic,
    clockinTime: json['clockinTime'] as dynamic,
    num: json['num'] as dynamic,
    nationalFlag: json['nationalFlag'] as dynamic,
    isFreezeDictText: json['isFreeze_dictText'] as String?,
    sexDictText: json['sex_dictText'] as String?,
    statusDictText: json['status_dictText'] as String?,
    channelDictText: json['channel_dictText'] as String?,
    isAccountDictText: json['isAccount_dictText'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createTime': createTime,
    'updateTime': updateTime,
    'phoneAreaCode': phoneAreaCode,
    'shortEn': shortEn,
    'country': country,
    'account': account,
    'portrait': portrait,
    'password': password,
    'earningsBalance': earningsBalance,
    'isFreeze': isFreeze,
    'name': name,
    'pid': pid,
    'userId': userId,
    'birthday': birthday,
    'sex': sex,
    'longitude': longitude,
    'latitude': latitude,
    'coin': coin,
    'sendCoin': sendCoin,
    'nobleGrade': nobleGrade,
    'expireTime': expireTime,
    'notifyType': notifyType,
    'isLocation': isLocation,
    'isPersonality': isPersonality,
    'constellation': constellation,
    'online': online,
    'freeNum': freeNum,
    'freeMsgNum': freeMsgNum,
    'freeDateNum': freeDateNum,
    'freeTranslateNum': freeTranslateNum,
    'type': type,
    'onlineTime': onlineTime,
    'freezeTime': freezeTime,
    'freezeReason': freezeReason,
    'friendNeedType': friendNeedType,
    'vcr': vcr,
    'pic': pic,
    'profile': profile,
    'height': height,
    'weight': weight,
    'language': language,
    'acceptAge': acceptAge,
    'emotionalExperience': emotionalExperience,
    'income': income,
    'buyCar': buyCar,
    'buyHouse': buyHouse,
    'drink': drink,
    'status': status,
    'zoneId': zoneId,
    'channel': channel,
    'isSend': isSend,
    'isRenew': isRenew,
    'pcode': pcode,
    'ip': ip,
    'banTime': banTime,
    'exposureTime': exposureTime,
    'exposureNum': exposureNum,
    'job': job,
    'education': education,
    'isAccount': isAccount,
    'isRealName': isRealName,
    'isMessage': isMessage,
    'isBelieve': isBelieve,
    'isConcern': isConcern,
    'age': age,
    'distance': distance,
    'concernNum': concernNum,
    'concernedNum': concernedNum,
    'viewNum': viewNum,
    'viewedNum': viewedNum,
    'likedNum': likedNum,
    'likeNum': likeNum,
    'giftNum': giftNum,
    'seq': seq,
    'agoraToken': agoraToken,
    'appKey': appKey,
    'header': header,
    'isReal': isReal,
    'isHealth': isHealth,
    'isPayTaxes': isPayTaxes,
    'isCredit': isCredit,
    'insomniaDuration': insomniaDuration,
    'sleepOnsetDuration': sleepOnsetDuration,
    'setBedtime': setBedtime,
    'nighttimeStatus': nighttimeStatus,
    'clockinTime': clockinTime,
    'num': num,
    'nationalFlag': nationalFlag,
    'isFreeze_dictText': isFreezeDictText,
    'sex_dictText': sexDictText,
    'status_dictText': statusDictText,
    'channel_dictText': channelDictText,
    'isAccount_dictText': isAccountDictText,
  };
}
