class Message {
  String? createBy;
  String? createTime;
  String? id;
  String? msg;
  String? receiveId;
  String? updateBy;
  String? updateTime;
  String? userId;

  Message({
    this.createBy,
    this.createTime,
    this.id,
    this.msg,
    this.receiveId,
    this.updateBy,
    this.updateTime,
    this.userId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    createBy: json['createBy'] as String?,
    createTime: json['createTime'] as String?,
    id: json['id'] as String?,
    msg: json['msg'] as String?,
    receiveId: json['receiveId'] as String?,
    updateBy: json['updateBy'] as String?,
    updateTime: json['updateTime'] as String?,
    userId: json['userId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'createBy': createBy,
    'createTime': createTime,
    'id': id,
    'msg': msg,
    'receiveId': receiveId,
    'updateBy': updateBy,
    'updateTime': updateTime,
    'userId': userId,
  };
}
