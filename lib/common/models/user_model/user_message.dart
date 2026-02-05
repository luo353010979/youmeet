class UserMessage {
  String? id;
  String? createTime;
  String? updateTime;
  String? phoneAreaCode;
  String? shortEn;
  String? country;
  String? account;
  String? portrait;
  String? password;
  int? earningsBalance;
  int? isFreeze;
  String? name;
  dynamic pid;
  String? userId;
  String? birthday;
  int? sex;
  dynamic longitude;
  dynamic latitude;
  int? coin;
  int? sendCoin;
  int? nobleGrade;
  String? expireTime;
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
  dynamic pic;
  dynamic profile;
  dynamic height;
  dynamic weight;
  dynamic language;
  dynamic acceptAge;
  dynamic emotionalExperience;
  dynamic income;
  dynamic buyCar;
  dynamic buyHouse;
  dynamic drink;
  int? status;
  String? zoneId;
  dynamic uniId;
  String? channel;
  int? isSend;
  int? isRenew;
  dynamic pcode;
  dynamic imAppid;
  dynamic ip;
  String? banTime;
  dynamic exposureTime;
  int? exposureNum;
  dynamic job;
  dynamic education;
  int? isAccount;
  int? isRealName;
  dynamic isMessage;
  dynamic isBelieve;
  dynamic isConcern;
  int? age;
  dynamic distance;
  int? concernNum;
  int? concernedNum;
  int? viewNum;
  int? viewedNum;
  int? likedNum;
  int? likeNum;
  int? giftNum;
  dynamic seq;
  dynamic uniToken;
  dynamic agoraToken;
  dynamic appKey;
  dynamic header;
  int? isReal;
  int? isHealth;
  int? isPayTaxes;
  int? isCredit;
  dynamic stardrmSet;
  String? nationalFlag;

  UserMessage({
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
    this.uniId,
    this.channel,
    this.isSend,
    this.isRenew,
    this.pcode,
    this.imAppid,
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
    this.uniToken,
    this.agoraToken,
    this.appKey,
    this.header,
    this.isReal,
    this.isHealth,
    this.isPayTaxes,
    this.isCredit,
    this.stardrmSet,
    this.nationalFlag,
  });

  factory UserMessage.fromJson(Map<String, dynamic> json) => UserMessage(
    id: json['id'] as String?,
    createTime: json['createTime'] as String?,
    updateTime: json['updateTime'] as String?,
    phoneAreaCode: json['phoneAreaCode'] as String?,
    shortEn: json['shortEn'] as String?,
    country: json['country'] as String?,
    account: json['account'] as String?,
    portrait: json['portrait'] as String?,
    password: json['password'] as String?,
    earningsBalance: json['earningsBalance'] as int?,
    isFreeze: json['isFreeze'] as int?,
    name: json['name'] as String?,
    pid: json['pid'] as dynamic,
    userId: json['userId'] as String?,
    birthday: json['birthday'] as String?,
    sex: json['sex'] as int?,
    longitude: json['longitude'] as dynamic,
    latitude: json['latitude'] as dynamic,
    coin: json['coin'] as int?,
    sendCoin: json['sendCoin'] as int?,
    nobleGrade: json['nobleGrade'] as int?,
    expireTime: json['expireTime'] as String?,
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
    pic: json['pic'] as dynamic,
    profile: json['profile'] as dynamic,
    height: json['height'] as dynamic,
    weight: json['weight'] as dynamic,
    language: json['language'] as dynamic,
    acceptAge: json['acceptAge'] as dynamic,
    emotionalExperience: json['emotionalExperience'] as dynamic,
    income: json['income'] as dynamic,
    buyCar: json['buyCar'] as dynamic,
    buyHouse: json['buyHouse'] as dynamic,
    drink: json['drink'] as dynamic,
    status: json['status'] as int?,
    zoneId: json['zoneId'] as String?,
    uniId: json['uniId'] as dynamic,
    channel: json['channel'] as String?,
    isSend: json['isSend'] as int?,
    isRenew: json['isRenew'] as int?,
    pcode: json['pcode'] as dynamic,
    imAppid: json['imAppid'] as dynamic,
    ip: json['ip'] as dynamic,
    banTime: json['banTime'] as String?,
    exposureTime: json['exposureTime'] as dynamic,
    exposureNum: json['exposureNum'] as int?,
    job: json['job'] as dynamic,
    education: json['education'] as dynamic,
    isAccount: json['isAccount'] as int?,
    isRealName: json['isRealName'] as int?,
    isMessage: json['isMessage'] as dynamic,
    isBelieve: json['isBelieve'] as dynamic,
    isConcern: json['isConcern'] as dynamic,
    age: json['age'] as int?,
    distance: json['distance'] as dynamic,
    concernNum: json['concernNum'] as int?,
    concernedNum: json['concernedNum'] as int?,
    viewNum: json['viewNum'] as int?,
    viewedNum: json['viewedNum'] as int?,
    likedNum: json['likedNum'] as int?,
    likeNum: json['likeNum'] as int?,
    giftNum: json['giftNum'] as int?,
    seq: json['seq'] as dynamic,
    uniToken: json['uniToken'] as dynamic,
    agoraToken: json['agoraToken'] as dynamic,
    appKey: json['appKey'] as dynamic,
    header: json['header'] as dynamic,
    isReal: json['isReal'] as int?,
    isHealth: json['isHealth'] as int?,
    isPayTaxes: json['isPayTaxes'] as int?,
    isCredit: json['isCredit'] as int?,
    stardrmSet: json['stardrmSet'] as dynamic,
    nationalFlag: json['nationalFlag'] as String?,
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
    'uniId': uniId,
    'channel': channel,
    'isSend': isSend,
    'isRenew': isRenew,
    'pcode': pcode,
    'imAppid': imAppid,
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
    'uniToken': uniToken,
    'agoraToken': agoraToken,
    'appKey': appKey,
    'header': header,
    'isReal': isReal,
    'isHealth': isHealth,
    'isPayTaxes': isPayTaxes,
    'isCredit': isCredit,
    'stardrmSet': stardrmSet,
    'nationalFlag': nationalFlag,
  };
}
