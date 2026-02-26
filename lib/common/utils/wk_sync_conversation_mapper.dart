import 'dart:convert';

import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

class WKSyncConversationMapper {
  static WKSyncConversation fromDynamic(dynamic raw) {
    final syncConversation = WKSyncConversation();
    syncConversation.conversations = [];

    if (raw is List) {
      syncConversation.conversations = raw
          .map((item) => _buildSyncConvMsg(item))
          .toList();
      return syncConversation;
    }

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      syncConversation.uid = _asString(map['uid']);
      syncConversation.cmdVersion = _asInt(
        map['cmd_version'] ?? map['cmdVersion'],
      );

      final conversationsRaw = map['conversations'] ?? map['result'];
      if (conversationsRaw is List) {
        syncConversation.conversations = conversationsRaw
            .map((item) => _buildSyncConvMsg(item))
            .toList();
      }
    }

    return syncConversation;
  }

  static WKSyncConvMsg _buildSyncConvMsg(dynamic raw) {
    final conv = WKSyncConvMsg();
    conv.recents = [];
    if (raw is! Map) return conv;

    final map = Map<String, dynamic>.from(raw);
    conv.channelID = _asString(map['channel_id'] ?? map['channelID']);
    conv.channelType = _asInt(map['channel_type'] ?? map['channelType']);
    conv.unread = _asInt(map['unread']);
    conv.timestamp = _asInt(map['timestamp']);
    conv.lastMsgSeq = _asInt(map['last_msg_seq'] ?? map['lastMsgSeq']);
    conv.lastClientMsgNO = _asString(
      map['last_client_msg_no'] ?? map['lastClientMsgNO'],
    );
    conv.offsetMsgSeq = _asInt(map['offset_msg_seq'] ?? map['offsetMsgSeq']);
    conv.version = _asInt(map['version']);

    final recentsRaw = map['recents'];
    if (recentsRaw is List) {
      conv.recents = recentsRaw.map((item) => _buildSyncMsg(item)).toList();
    }
    return conv;
  }

  static WKSyncMsg _buildSyncMsg(dynamic raw) {
    final msg = WKSyncMsg();
    if (raw is! Map) return msg;

    final map = Map<String, dynamic>.from(raw);
    msg.messageID = _asString(map['message_idstr'] ?? map['message_id']);
    msg.messageSeq = _asInt(map['message_seq'] ?? map['messageSeq']);
    msg.clientMsgNO = _asString(map['client_msg_no'] ?? map['clientMsgNO']);
    msg.fromUID = _asString(map['from_uid'] ?? map['fromUID']);
    msg.channelID = _asString(map['channel_id'] ?? map['channelID']);
    msg.channelType = _asInt(map['channel_type'] ?? map['channelType']);
    msg.timestamp = _asInt(map['timestamp']);
    msg.setting = _asInt(map['setting']);

    final payloadRaw = map['payload'];
    if (payloadRaw is String && payloadRaw.isNotEmpty) {
      try {
        final decoded = utf8.decode(base64Decode(payloadRaw));
        msg.payload = jsonDecode(decoded);
      } catch (_) {
        msg.payload = null;
      }
    } else if (payloadRaw is Map || payloadRaw is List) {
      msg.payload = payloadRaw;
    }

    return msg;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
