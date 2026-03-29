import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
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

  final Map<String, UserMessage?> userMap = {};

  List<MsgConversation> msgConversation = [];

  _initData() {
    _loadConversations();

    /// 监听频道信息刷新
    WKIM.shared.channelManager.addOnRefreshListener("onRefreshChannelListener2", _onRefreshChannelListener);

    /// 会话列表刷新监听
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      "conversationListener2",
      _onRefreshConversationListener,
    );
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
    WKIM.shared.channelManager.removeOnRefreshListener("onRefreshChannelListener2");
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener("conversationListener2");
  }

  /// 获取用户消息并更新至频道信息
  Future<void> getUserMessages(String channelId) async {
    final response = await UserApi.profile(id: channelId);
    if (response.success) {
      final userMessage = response.result;
      WKChannel channel = WKChannel(channelId, WKChannelType.personal);
      channel.channelName = userMessage?.name ?? '';
      channel.avatar = userMessage?.portrait ?? '';
      logger.d('用户信息更新成功: ${channel.channelName}');
      userMap[channelId] = userMessage;
      //更新频道信息
      WKIM.shared.channelManager.addOrUpdateChannel(channel);
    }
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

      // for (final conversation in conversations) {
      //   final channel = await conversation.getWkChannel();
      //   if (channel?.channelName.isEmpty == true) {
      //     await getUserMessages(conversation.channelID);
      //   }
      //   await parseConversation(conversation);
      // }
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

      var item = msgConversation.firstWhere((cov){
        return cov.channelID == conversation.channelID;
      });

      msgConversation[msgConversation.indexOf(item)] = cov;

      update(["msg_index"]);
    }

  }

  void toChatPage(String channelId) {
    final userMessage = userMap[channelId];
    Get.toNamed(RouteNames.msgChat, arguments: {"channelId": channelId, "userMessage": userMessage});
  }

  void getConversation(String channelID) async {
    final conversation = await WKIM.shared.conversationManager.getWithChannel(channelID, WKChannelType.personal);
    conversation?.lastMsgSeq;
  }
}
