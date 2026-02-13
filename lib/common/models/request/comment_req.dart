class CommentReq {
  String? createBy;
  String? createTime;
  String? id;
  int? isView;
  String? name;
  String? nationalFlag;
  String? pid;
  String? portrait;
  String? trendsContent;
  String? trendsId;
  String? trendsUserId;
  int? type;
  String? updateBy;
  String? updateTime;
  String? userId;

  CommentReq({
    this.createBy,
    this.createTime,
    this.id,
    this.isView,
    this.name,
    this.nationalFlag,
    this.pid,
    this.portrait,
    this.trendsContent,
    this.trendsId,
    this.trendsUserId,
    this.type,
    this.updateBy,
    this.updateTime,
    this.userId,
  });

  factory CommentReq.fromJson(Map<String, dynamic> json) => CommentReq(
    createBy: json['createBy'] as String?,
    createTime: json['createTime'] as String?,
    id: json['id'] as String?,
    isView: json['isView'] as int?,
    name: json['name'] as String?,
    nationalFlag: json['nationalFlag'] as String?,
    pid: json['pid'] as String?,
    portrait: json['portrait'] as String?,
    trendsContent: json['trendsContent'] as String?,
    trendsId: json['trendsId'] as String?,
    trendsUserId: json['trendsUserId'] as String?,
    type: json['type'] as int?,
    updateBy: json['updateBy'] as String?,
    updateTime: json['updateTime'] as String?,
    userId: json['userId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'createBy': createBy,
    'createTime': createTime,
    'id': id,
    'isView': isView,
    'name': name,
    'nationalFlag': nationalFlag,
    'pid': pid,
    'portrait': portrait,
    'trendsContent': trendsContent,
    'trendsId': trendsId,
    'trendsUserId': trendsUserId,
    'type': type,
    'updateBy': updateBy,
    'updateTime': updateTime,
    'userId': userId,
  };
}
