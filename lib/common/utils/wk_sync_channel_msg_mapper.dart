import 'dart:convert';

import 'package:wukongimfluttersdk/entity/msg.dart';

class WKSyncChannelMsgMapper {
  static WKSyncChannelMsg fromDynamic(dynamic raw) {
    final syncMsg = WKSyncChannelMsg();
    syncMsg.messages = [];

    dynamic source = raw;
    if (source is String && source.isNotEmpty) {
      try {
        source = jsonDecode(source);
      } catch (_) {
        return syncMsg;
      }
    }

    if (source is! Map) {
      return syncMsg;
    }

    final map = Map<String, dynamic>.from(source);
    syncMsg.startMessageSeq = _asInt(
      map['start_message_seq'] ?? map['startMessageSeq'],
    );
    syncMsg.endMessageSeq = _asInt(
      map['end_message_seq'] ?? map['endMessageSeq'],
    );
    syncMsg.more = _asInt(map['more']);

    final messagesRaw = map['messages'];
    if (messagesRaw is List) {
      syncMsg.messages = messagesRaw
          .map((item) => _buildSyncMsg(item))
          .toList();
    }

    return syncMsg;
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
    msg.payload = _decodePayload(map['payload']);

    return msg;
  }

  static dynamic _decodePayload(dynamic payloadRaw) {
    if (payloadRaw is String && payloadRaw.isNotEmpty) {
      try {
        final decoded = utf8.decode(base64Decode(payloadRaw));
        return jsonDecode(decoded);
      } catch (_) {
        try {
          return jsonDecode(payloadRaw);
        } catch (_) {
          return null;
        }
      }
    }
    if (payloadRaw is Map || payloadRaw is List) {
      return payloadRaw;
    }
    return null;
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
