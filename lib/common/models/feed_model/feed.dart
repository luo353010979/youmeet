import 'comment.dart';
import 'like.dart';

class Feed {
  String? address;
  int? commentNum;
  List<Comment>? comments;
  String? content;
  String? createBy;
  String? createTime;
  String? id;
  int? isCheck;
  int? isConcern;
  int? isLike;
  int? isVoiceCheck;
  int? likeNum;
  List<Like>? likes;
  String? name;
  String? nationalFlag;
  String? pic;
  String? portrait;
  String? shortEn;
  int? status;
  String? updateBy;
  String? updateTime;
  String? userId;
  String? video;
  String? videoTaskId;
  int? viewNum;
  String? voice;
  String? voiceTaskId;

  Feed({
    this.address,
    this.commentNum,
    this.comments,
    this.content,
    this.createBy,
    this.createTime,
    this.id,
    this.isCheck,
    this.isConcern,
    this.isLike,
    this.isVoiceCheck,
    this.likeNum,
    this.likes,
    this.name,
    this.nationalFlag,
    this.pic,
    this.portrait,
    this.shortEn,
    this.status,
    this.updateBy,
    this.updateTime,
    this.userId,
    this.video,
    this.videoTaskId,
    this.viewNum,
    this.voice,
    this.voiceTaskId,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    address: json['address'] as String?,
    commentNum: json['commentNum'] as int?,
    comments: (json['comments'] as List<dynamic>?)
        ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList(),
    content: json['content'] as String?,
    createBy: json['createBy'] as String?,
    createTime: json['createTime'] as String?,
    id: json['id'] as String?,
    isCheck: json['isCheck'] as int?,
    isConcern: json['isConcern'] as int?,
    isLike: json['isLike'] as int?,
    isVoiceCheck: json['isVoiceCheck'] as int?,
    likeNum: json['likeNum'] as int?,
    likes: (json['likes'] as List<dynamic>?)
        ?.map((e) => Like.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String?,
    nationalFlag: json['nationalFlag'] as String?,
    pic: json['pic'] as String?,
    portrait: json['portrait'] as String?,
    shortEn: json['shortEn'] as String?,
    status: json['status'] as int?,
    updateBy: json['updateBy'] as String?,
    updateTime: json['updateTime'] as String?,
    userId: json['userId'] as String?,
    video: json['video'] as String?,
    videoTaskId: json['videoTaskId'] as String?,
    viewNum: json['viewNum'] as int?,
    voice: json['voice'] as String?,
    voiceTaskId: json['voiceTaskId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'address': address,
    'commentNum': commentNum,
    'comments': comments?.map((e) => e.toJson()).toList(),
    'content': content,
    'createBy': createBy,
    'createTime': createTime,
    'id': id,
    'isCheck': isCheck,
    'isConcern': isConcern,
    'isLike': isLike,
    'isVoiceCheck': isVoiceCheck,
    'likeNum': likeNum,
    'likes': likes?.map((e) => e.toJson()).toList(),
    'name': name,
    'nationalFlag': nationalFlag,
    'pic': pic,
    'portrait': portrait,
    'shortEn': shortEn,
    'status': status,
    'updateBy': updateBy,
    'updateTime': updateTime,
    'userId': userId,
    'video': video,
    'videoTaskId': videoTaskId,
    'viewNum': viewNum,
    'voice': voice,
    'voiceTaskId': voiceTaskId,
  };
}
