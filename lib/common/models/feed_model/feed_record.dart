class FeedRecord {
  String? id;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? content;
  String? pic;
  String? userId;
  int? status;
  String? address;
  int? viewNum;
  String? voice;
  String? video;
  String? videoTaskId;
  String? voiceTaskId;
  int? isCheck;
  int? isVoiceCheck;
  String? lon;
  String? lat;
  String? subject;
  String? name;
  String? portrait;
  int? sex;
  int? age;
  String? second;
  int? isTop;
  int? likeNum;
  int? commentNum;
  int? isLike;
  String? nationalFlag;
  String? shortEn;
  String? distance;
  String? friendIds;
  String? country;
  int? isConcern;
  String? userIdDictText;
  String? statusDictText;
  String? isTopDictText;

  FeedRecord({
    this.id,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.content,
    this.pic,
    this.userId,
    this.status,
    this.address,
    this.viewNum,
    this.voice,
    this.video,
    this.videoTaskId,
    this.voiceTaskId,
    this.isCheck,
    this.isVoiceCheck,
    this.lon,
    this.lat,
    this.subject,
    this.name,
    this.portrait,
    this.sex,
    this.age,
    this.second,
    this.isTop,
    this.likeNum,
    this.commentNum,
    this.isLike,
    this.nationalFlag,
    this.shortEn,
    this.distance,
    this.friendIds,
    this.country,
    this.isConcern,
    this.userIdDictText,
    this.statusDictText,
    this.isTopDictText,
  });

  factory FeedRecord.fromJson(Map<String, dynamic> json) => FeedRecord(
    id: json['id'] as String?,
    createBy: json['createBy'] as String?,
    createTime: json['createTime'] as String?,
    updateBy: json['updateBy'] as String?,
    updateTime: json['updateTime'] as String?,
    content: json['content'] as String?,
    pic: json['pic'] as String?,
    userId: json['userId'] as String?,
    status: json['status'] as int?,
    address: json['address'] as String?,
    viewNum: json['viewNum'] as int?,
    voice: json['voice'] as String?,
    video: json['video'] as String?,
    videoTaskId: json['videoTaskId'] as String?,
    voiceTaskId: json['voiceTaskId'] as String?,
    isCheck: json['isCheck'] as int?,
    isVoiceCheck: json['isVoiceCheck'] as int?,
    lon: json['lon'] as String?,
    lat: json['lat'] as String?,
    subject: json['subject'] as String?,
    name: json['name'] as String?,
    portrait: json['portrait'] as String?,
    sex: json['sex'] as int?,
    age: json['age'] as int?,
    second: json['second'] as String?,
    isTop: json['isTop'] as int?,
    likeNum: json['likeNum'] as int?,
    commentNum: json['commentNum'] as int?,
    isLike: json['isLike'] as int?,
    nationalFlag: json['nationalFlag'] as String?,
    shortEn: json['shortEn'] as String?,
    distance: json['distance'] as String?,
    friendIds: json['friendIds'] as String?,
    country: json['country'] as String?,
    isConcern: json['isConcern'] as int?,
    userIdDictText: json['userId_dictText'] as String?,
    statusDictText: json['status_dictText'] as String?,
    isTopDictText: json['isTop_dictText'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createBy': createBy,
    'createTime': createTime,
    'updateBy': updateBy,
    'updateTime': updateTime,
    'content': content,
    'pic': pic,
    'userId': userId,
    'status': status,
    'address': address,
    'viewNum': viewNum,
    'voice': voice,
    'video': video,
    'videoTaskId': videoTaskId,
    'voiceTaskId': voiceTaskId,
    'isCheck': isCheck,
    'isVoiceCheck': isVoiceCheck,
    'lon': lon,
    'lat': lat,
    'subject': subject,
    'name': name,
    'portrait': portrait,
    'sex': sex,
    'age': age,
    'second': second,
    'isTop': isTop,
    'likeNum': likeNum,
    'commentNum': commentNum,
    'isLike': isLike,
    'nationalFlag': nationalFlag,
    'shortEn': shortEn,
    'distance': distance,
    'friendIds': friendIds,
    'country': country,
    'isConcern': isConcern,
    'userId_dictText': userIdDictText,
    'status_dictText': statusDictText,
    'isTop_dictText': isTopDictText,
  };
}
