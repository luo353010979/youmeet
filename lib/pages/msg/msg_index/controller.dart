import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/cmd.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class MsgIndexController extends GetxController {
  MsgIndexController();

  final refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  List<WKUIConversationMsg> conversations = [];
  final Map<String, MsgConversation> parsedConversations = {};
  final Set<String> parsingConversationKeys = <String>{};


  List<MsgConversation> msgConversation = [];

  _initData() {
    _loadConversations();
    /// 会话列表刷新监听
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      "conversationListener2",
      _onRefreshConversationListener,
    );

    WKIM.shared.cmdManager.addOnCmdListener("cmdListener", _onCmdListener);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener("conversationListener2");
  }



  /// 加载会话列表
  Future<void> _loadConversations() async {
    try {
      final data = await WKIM.shared.conversationManager.getAll();

      for (var conversation in data) {
        final wkChannel = await conversation.getWkChannel();
        final lastMsg = await conversation.getWkMsg();
        var cov = MsgConversation.fromUIConversation(conversation: conversation, channel: wkChannel, lastMsg: lastMsg);
        msgConversation.add(cov);
      }

      logger.d('加载了 ${data.length} 个会话');

    } catch (e) {
      logger.d('加载会话列表失败: $e');
    } finally {
      update(["msg_index"]);
    }
  }

  /// 频道信息更新
  _onRefreshChannelListener(WKChannel channel) {
    logger.d('频道信息刷新: ${channel.channelID}, 新名称: ${channel.channelName}');
    for (var item in conversations) {
      item.setWkChannel(channel);
    }
    update(["msg_index"]);
  }

  /// 会话列表刷新监听回调  ====> 接收方
  _onRefreshConversationListener(List<WKUIConversationMsg> p1) async{
    logger.d('_onRefreshConversationListener   会话列表刷新，当前会话数量: ${p1.length}');
    // 会话列表有更新，刷新 UI
    for (var conversation in p1) {
      final wkChannel = await conversation.getWkChannel();
      final lastMsg = await conversation.getWkMsg();
      var cov = MsgConversation.fromUIConversation(conversation: conversation, channel: wkChannel, lastMsg: lastMsg);

      if (msgConversation.isEmpty) {
        msgConversation.add(cov);
      } else {
        var item = msgConversation.firstWhere((cov) {
          return cov.channelID == conversation.channelID;
        });
        msgConversation[msgConversation.indexOf(item)] = cov;
      }

      update(["msg_index"]);
    }

  }

  void toChatPage(String channelId) {
    WKIM.shared.conversationManager.updateRedDot(
      channelId,
      WKChannelType.personal,
      0,
    );

    final userMessage = MsgService.to.userMap[channelId];
    Get.toNamed(RouteNames.msgChat, arguments: {"channelId": channelId, "userMessage": userMessage});
  }


  _onCmdListener(WKCMD cmd) {
    print('收到 CMD 消息: ${cmd.cmd}');
    print('参数: ${cmd.param}');

    switch (cmd.cmd) {
      case 'messageRevoke':
        // await handleMessageRevoke(cmd);
        break;
      case 'channelUpdate':
        // await handleChannelUpdate(cmd);
        break;
      case 'unreadClear':
        handleUnreadClear(cmd);
        break;
      default:
        print('未知的 CMD 消息: ${cmd.cmd}');
    }
  }

  /// 处理未读数清除
  void handleUnreadClear(WKCMD cmd) {
    String channelID = cmd.param['channel_id'] ?? '';
    int channelType = cmd.param['channel_type'] ?? 0;
    int unread = cmd.param['unread'] ?? 0;

    if (channelID.isEmpty) return;

    WKIM.shared.conversationManager.updateRedDot(
      channelID,
      channelType,
      unread,
    );
  }
}
