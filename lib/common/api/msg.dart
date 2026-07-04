import 'package:youmeet/common/index.dart';

class MsgApi {
  // IM添加消息
  static Future<BaseResponse<String>> addMessage(SendMessageReq req) async {
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/imRecord/imRecord/add",
      data: req.toJson(),
    );

    return BaseResponse.fromJson(response.data, (data) => data as String);
  }

  // IM消息，分页列表查询
  static Future<BaseResponse<MessageModel>> getMessageList(String id) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/imRecord/imRecord/list",
      params: {'id': id},
    );

    return BaseResponse.fromJson(
      response.data,
      (data) => MessageModel.fromJson(data),
    );
  }

  /// 同步会话列表
  static Future<BaseResponse> syncConversations({
    String? lastSsgSeqs,
    int? msgCount,
    int? version,
  }) async {
    // 这里可以调用接口获取会话列表，获取完成后调用 WKIM.shared.messageManager.syncConversations 回调传入会话列表
    // 注意：字段名必须是 lastMsgSeqs（格式 channelID:channelType:last_msg_seq），
    // 服务器靠它计算每个会话的未读数。之前误写成 lastSsgSeqs，服务器收不到已读位置，
    // 导致重新登录后未读红点又全部出现。
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/txs/conversation",
      data: {
        "lastMsgSeqs": lastSsgSeqs,
        "msgCount": msgCount,
        "version": version,
      },
    );

    return BaseResponse.fromJson(response.data, (data) => data);
  }

  /// 同步频道消息
  static Future<BaseResponse> syncHistoryMessages({
    required String channelID,
    required int pullMode,
    required int startMessageSeq,
    required int endMessageSeq,
    required int limit,
  }) async {
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/txs/messagesync",
      data: {
        "channelId": channelID,
        "pullMode": pullMode,
        "startMessageSeq": startMessageSeq,
        "endMessageSeq": endMessageSeq,
        "limit": limit,
      },
    );

    return BaseResponse.fromJson(response.data, (data) => data);
  }
}
