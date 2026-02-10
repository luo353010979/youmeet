class Feed {
  String? id;
  dynamic createBy;
  String? createTime;
  dynamic updateBy;
  dynamic updateTime;
  String? content;
  dynamic pic;
  String? userId;
  int? status;
  dynamic address;
  int? viewNum;
  dynamic voice;
  dynamic video;
  dynamic videoTaskId;
  dynamic voiceTaskId;
  int? isCheck;
  int? isVoiceCheck;
  String? name;
  String? portrait;
  int? likeNum;
  int? commentNum;
  int? isLike;
  int? isConcern;
  String? nationalFlag;
  String? shortEn;
  dynamic comments;
  List<dynamic>? likes;

  Feed({
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
    this.name,
    this.portrait,
    this.likeNum,
    this.commentNum,
    this.isLike,
    this.isConcern,
    this.nationalFlag,
    this.shortEn,
    this.comments,
    this.likes,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    id: json['id'] as String?,
    createBy: json['createBy'] as dynamic,
    createTime: json['createTime'] as String?,
    updateBy: json['updateBy'] as dynamic,
    updateTime: json['updateTime'] as dynamic,
    content: json['content'] as String?,
    pic: json['pic'] as dynamic,
    userId: json['userId'] as String?,
    status: json['status'] as int?,
    address: json['address'] as dynamic,
    viewNum: json['viewNum'] as int?,
    voice: json['voice'] as dynamic,
    video: json['video'] as dynamic,
    videoTaskId: json['videoTaskId'] as dynamic,
    voiceTaskId: json['voiceTaskId'] as dynamic,
    isCheck: json['isCheck'] as int?,
    isVoiceCheck: json['isVoiceCheck'] as int?,
    name: json['name'] as String?,
    portrait: json['portrait'] as String?,
    likeNum: json['likeNum'] as int?,
    commentNum: json['commentNum'] as int?,
    isLike: json['isLike'] as int?,
    isConcern: json['isConcern'] as int?,
    nationalFlag: json['nationalFlag'] as String?,
    shortEn: json['shortEn'] as String?,
    comments: json['comments'] as dynamic,
    likes: json['likes'] as List<dynamic>?,
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
    'name': name,
    'portrait': portrait,
    'likeNum': likeNum,
    'commentNum': commentNum,
    'isLike': isLike,
    'isConcern': isConcern,
    'nationalFlag': nationalFlag,
    'shortEn': shortEn,
    'comments': comments,
    'likes': likes,
  };
}
