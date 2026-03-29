import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/entity/reminder.dart';

class MsgConversation {

  final int lastMsgSeq;
  final String clientMsgNo;
  // 频道ID
  final String channelID;
  // 频道类型
  final int channelType;
  // 最后一条消息时间
  final int lastMsgTimestamp;
  // 消息频道
  final WKChannel? wkChannel;
  // 消息正文
  final WKMsg? wkMsg;
  // 未读消息数量
  final int unreadCount;
  final int isDeleted;
  // 高亮内容[{type:1,text:'[有人@你]'}]
  final List<WKReminder>? reminderList;
  // 扩展字段
  final dynamic localExtraMap;
  final String parentChannelID;
  final int parentChannelType;

  const MsgConversation({
    this.lastMsgSeq = 0,
    this.clientMsgNo = '',
    this.channelID = '',
    this.channelType = 0,
    this.lastMsgTimestamp = 0,
    this.wkChannel,
    this.wkMsg,
    this.unreadCount = 0,
    this.isDeleted = 0,
    this.reminderList,
    this.localExtraMap,
    this.parentChannelID = '',
    this.parentChannelType = 0,
  });

  factory MsgConversation.fromUIConversation({
    required WKUIConversationMsg conversation,
    WKChannel? channel,
    WKMsg? lastMsg,
  }) {
    return MsgConversation(
      lastMsgSeq: conversation.lastMsgSeq,
      clientMsgNo: conversation.clientMsgNo,
      channelID: conversation.channelID,
      channelType: conversation.channelType,
      lastMsgTimestamp: conversation.lastMsgTimestamp,
      wkChannel: channel,
      wkMsg: lastMsg,
      unreadCount: conversation.unreadCount,
      isDeleted: conversation.isDeleted,
      reminderList: null,
      localExtraMap: conversation.localExtraMap,
      parentChannelID: conversation.parentChannelID,
      parentChannelType: conversation.parentChannelType,
    );
  }

  MsgConversation copyWith({
    int? lastMsgSeq,
    String? clientMsgNo,
    String? channelID,
    int? channelType,
    int? lastMsgTimestamp,
    WKChannel? wkChannel,
    WKMsg? wkMsg,
    int? unreadCount,
    int? isDeleted,
    List<WKReminder>? reminderList,
    dynamic localExtraMap,
    String? parentChannelID,
    int? parentChannelType,
  }) {
    return MsgConversation(
      lastMsgSeq: lastMsgSeq ?? this.lastMsgSeq,
      clientMsgNo: clientMsgNo ?? this.clientMsgNo,
      channelID: channelID ?? this.channelID,
      channelType: channelType ?? this.channelType,
      lastMsgTimestamp: lastMsgTimestamp ?? this.lastMsgTimestamp,
      wkChannel: wkChannel ?? this.wkChannel,
      wkMsg: wkMsg ?? this.wkMsg,
      unreadCount: unreadCount ?? this.unreadCount,
      isDeleted: isDeleted ?? this.isDeleted,
      reminderList: reminderList ?? this.reminderList,
      localExtraMap: localExtraMap ?? this.localExtraMap,
      parentChannelID: parentChannelID ?? this.parentChannelID,
      parentChannelType: parentChannelType ?? this.parentChannelType,
    );
  }
}