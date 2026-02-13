class FeedComments {
  int? commentNum;
  List<FeedComments>? comments;
  String? createBy;
  String? createTime;
  String? id;
  int? isLike;
  int? likeNum;
  String? name;
  String? nationalFlag;
  String? pid;
  String? portrait;
  String? shortEn;
  String? trendsContent;
  String? trendsId;
  String? trendsUserId;
  int? type;
  String? updateBy;
  String? updateTime;
  String? userId;

  FeedComments({
    this.commentNum,
    this.comments,
    this.createBy,
    this.createTime,
    this.id,
    this.isLike,
    this.likeNum,
    this.name,
    this.nationalFlag,
    this.pid,
    this.portrait,
    this.shortEn,
    this.trendsContent,
    this.trendsId,
    this.trendsUserId,
    this.type,
    this.updateBy,
    this.updateTime,
    this.userId,
  });

  factory FeedComments.fromJson(Map<String, dynamic> json) => FeedComments(
    commentNum: json['commentNum'] as int?,
    comments: (json['comments'] as List<dynamic>?)
        ?.map((e) => FeedComments.fromJson(e as Map<String, dynamic>))
        .toList(),
    createBy: json['createBy'] as String?,
    createTime: json['createTime'] as String?,
    id: json['id'] as String?,
    isLike: json['isLike'] as int?,
    likeNum: json['likeNum'] as int?,
    name: json['name'] as String?,
    nationalFlag: json['nationalFlag'] as String?,
    pid: json['pid'] as String?,
    portrait: json['portrait'] as String?,
    shortEn: json['shortEn'] as String?,
    trendsContent: json['trendsContent'] as String?,
    trendsId: json['trendsId'] as String?,
    trendsUserId: json['trendsUserId'] as String?,
    type: json['type'] as int?,
    updateBy: json['updateBy'] as String?,
    updateTime: json['updateTime'] as String?,
    userId: json['userId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'commentNum': commentNum,
    'comments': comments?.map((e) => e.toJson()).toList(),
    'createBy': createBy,
    'createTime': createTime,
    'id': id,
    'isLike': isLike,
    'likeNum': likeNum,
    'name': name,
    'nationalFlag': nationalFlag,
    'pid': pid,
    'portrait': portrait,
    'shortEn': shortEn,
    'trendsContent': trendsContent,
    'trendsId': trendsId,
    'trendsUserId': trendsUserId,
    'type': type,
    'updateBy': updateBy,
    'updateTime': updateTime,
    'userId': userId,
  };
}
