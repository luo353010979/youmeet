import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class TypeModel {
  final int id;
  final String title;
  final String icon;

  TypeModel({required this.id, required this.title, required this.icon});
}

class ChatController extends GetxController {
  ChatController();

  // UserMessage? user;

  // 安全报告数据
  SafeReportModel? report;

  // 编辑报告请求参数
  EditReportReq req = EditReportReq(id: UserService.to.profile.id!);

  WKUIConversationMsg? conversation;
  MsgConversation? msgConversation;

  List<WKMsg> _messages = [];

  String? get displayRealPic {
    if (req.healthPic?.isNotEmpty == true) {
      return req.healthPic;
    }
    return report?.healthPic;
  }

  String? get displayPayTaxesPic {
    if (req.payTaxesPic?.isNotEmpty == true) {
      return req.payTaxesPic;
    }
    return report?.payTaxesPic;
  }

  String? get displayCreditPic {
    if (req.creditPic?.isNotEmpty == true) {
      return req.creditPic;
    }
    return report?.creditPic;
  }

  List<TypeModel> types = [
    TypeModel(id: 1, title: LocaleKeys.loveFourTitle1.tr, icon: AssetsSvgs.icMsg_01Svg),
    TypeModel(id: 2, title: LocaleKeys.loveFourTitle2.tr, icon: AssetsSvgs.icMsg_02Svg),
    TypeModel(id: 3, title: LocaleKeys.loveFourTitle3.tr, icon: AssetsSvgs.icMsg_03Svg),
  ];

  final List<String> messages = ["Hello!", "How are you?", "What's up?", "Let's meet up.", "See you later!"];

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments;
    // if (data != null && data is UserMessage) {
    //   user = data;
    //   update(["chat"]);
    // }
    conversation = data['conversation'];
    msgConversation = data['item'];

    final channelID = conversation?.channelID ?? "";
    final channelType = conversation?.channelType ?? 0;

    getSafeReport();

    WKIM.shared.messageManager.addOnSyncChannelMsgListener(_onSyncChannelMsgListener);

    getChannelMsg();
  }

  /// 更多按钮点击事件
  void onMorePressed() {}

  /// 上传报告点击事件
  Future<void> onComplete() async {
    if (req.creditPic == null && req.healthPic == null && req.payTaxesPic == null) {
      Loading.error("请上传完整的报告图片");
      return;
    }

    final response = await UserApi.editReport(req);
    if (response.success) {
      Loading.success('提交成功');
    } else {
      Loading.error(response.message);
    }
  }

  /// 图片选择
  Future<void> pickImage(int id) async {
    String? imageUrl = await UploadService.to.pickImage();
    if (imageUrl != null) {
      switch (id) {
        case 1:
          // 恋爱四项
          req.healthPic = imageUrl;
          break;
        case 2:
          // 个人纳税
          req.payTaxesPic = imageUrl;
          break;
        case 3:
          // 个人信用
          req.creditPic = imageUrl;
          break;
      }

      print("选择图片成功: $imageUrl");
      update(["chat"]);
    }
  }

  // 3.1 发送文本消息
  Future<void> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty) {
      return;
    }

    // 创建文本消息内容
    WKTextContent textContent = WKTextContent(text);

    // 创建频道对象（个人频道）
    String targetUID = conversation?.channelID ?? ""; // 目标用户ID
    if (targetUID.isEmpty) {
      print('消息发送失败: 目标用户ID为空');
      return;
    }
    int channelType = WKChannelType.personal; // 频道类型：个人
    WKChannel channel = WKChannel(targetUID, channelType);

    // 发送消息
    try {
      await WKIM.shared.messageManager.sendMessage(textContent, channel);
      print('消息发送成功: $text');
    } catch (error) {
      print('消息发送失败: $error');
    }
  }

  /// 获取安全报告
  Future<void> getSafeReport() async {
    final response = await UserApi.getSafeReport(id: UserService.to.profile.id!);
    if (response.success) {
      report = response.result;
      update(["chat"]);
    }
  }

  /// 获取用户消息
  void getUserMessages(String channelId) {
    // 这里可以调用接口获取用户消息列表，并更新 UI
    UserApi.profile(id: channelId).then((info) {
      if (info.success) {
        final userInfo = info.result;
        WKChannel channel = WKChannel(channelId, WKChannelType.personal);
        channel.channelName = userInfo?.name ?? '';
        channel.avatar = userInfo?.portrait ?? '';
        print('用户信息更新成功: ${channel.channelName}');
      }
    });
  }

  // 加载历史消息（从后端）
  // Future<void> loadHistoryMessages() async {
  //   // if (_isLoading || !_hasMore) {
  //   //   return;
  //   // }
  //   //
  //   // _isLoading = true;
  //
  //   try {
  //     // 获取最早的消息序号
  //     int oldestSeq = 0;
  //     if (_messages.isNotEmpty) {
  //       oldestSeq = _messages.last.messageSeq;
  //     }
  //
  //     print('加载历史消息，起始序号: $oldestSeq');
  //
  //     // 调用 SDK 方法触发同步
  //     List<WKMsg> messages = await WKIM.shared.messageManager.getOrSyncHistoryMessages(channelId, channelType, oldestOrderSeq, contain, pullMode, limit, aroundMsgOrderSeq, iGetOrSyncHistoryMsgBack, syncBack)
  //
  //     if (messages.isEmpty) {
  //       _hasMore = false;
  //       print('没有更多历史消息');
  //     } else {
  //       _messages.addAll(messages.reversed); // SDK 返回的是倒序，需要反转
  //       print('加载了 ${messages.length} 条历史消息');
  //     }
  //   } catch (e) {
  //     print('加载历史消息失败: $e');
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  /// 同步频道消息监听回调
  // _onSyncChannelMsgListener(
  //     String channelID,
  //     int channelType,
  //     int startMessageSeq,
  //     int endMessageSeq,
  //     int limit,
  //     int pullMode,
  //     Function(WKSyncChannelMsg? p1) back,
  //     ) {
  //   print(
  //     '同步频道消息: channelID=$channelID, channelType=$channelType, startMessageSeq=$startMessageSeq, endMessageSeq=$endMessageSeq, limit=$limit, pullMode=$pullMode',
  //   );
  //
  //   // todo 文档6151
  // }

  void getChannelMsg() async {
    await MsgApi.syncHistoryMessages(
      channelID: conversation?.channelID ?? "",
      pullMode: 1,
      startMessageSeq: 0,
      endMessageSeq: conversation?.lastMsgSeq ?? 0,
      limit: 20,
    );
  }

  /// 同步历史消息
  void _onSyncChannelMsgListener(
    String channelID,
    int channelType,
    int startMessageSeq,
    int endMessageSeq,
    int limit,
    int pullMode,
    Function(WKSyncChannelMsg? p1) back,
  ) async {
    try {
      final response = await MsgApi.syncHistoryMessages(
        channelID: conversation?.channelID ?? "",
        pullMode: 1,
        startMessageSeq: 0,
        endMessageSeq: conversation?.lastMsgSeq ?? 0,
        limit: 20,
      );
      if (response.success) {
        var data = jsonDecode(response.result);
        WKSyncChannelMsg wkSyncChannelMsg = WKSyncChannelMsg();
        final startMessageSeq = data["start_message_seq"];
        final endMessageSeq = data["end_message_seq"];
        final more = data["more"];
        List<dynamic> messages = data['messages'] ?? [];

        // 解析消息列表
        List<WKSyncMsg> wkMsgs = messages.map((msgJson) {
          return parseMessage(msgJson);
        }).toList();

        wkSyncChannelMsg.startMessageSeq = startMessageSeq;
        wkSyncChannelMsg.endMessageSeq = endMessageSeq;
        wkSyncChannelMsg.more = more;
        wkSyncChannelMsg.messages = wkMsgs;

        back(wkSyncChannelMsg);
      } else {
        print('同步历史消息失败: ${response.message}');
        // back();
      }
    } catch (e) {
      print('同步历史消息异常: $e');
      // back();
    }
  }

  /// 解析后端返回的消息
  WKSyncMsg parseMessage(Map<String, dynamic> msgJson) {
    WKSyncMsg msg = WKSyncMsg();
    msg.messageID = msgJson['message_id'] ?? '';
    msg.messageSeq = msgJson['message_seq'] ?? 0;
    msg.clientMsgNO = msgJson['client_msg_no'] ?? '';
    msg.fromUID = msgJson['from_uid'] ?? '';
    msg.channelID = msgJson['channel_id'] ?? '';
    msg.channelType = msgJson['channel_type'] ?? 0;
    // msg.contentType = msgJson['content_type'] ?? 0;
    // msg.content = msgJson['content'] ?? '';
    msg.timestamp = msgJson['timestamp'] ?? 0;

    // 解析消息内容
    // var contentJson = jsonDecode(msg.content);
    // msg.messageContent = WKIM.shared.messageManager.getMessageModel(msg.contentType, contentJson);

    return msg;
  }

  iGetOrSyncHistoryMsgBack(List<WKMsg> p1) {
    print("iGetOrSyncHistoryMsgBack: ${p1.length}");
  }

  syncBack() {
    print("syncBack：加载中");
  }
}
