import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class MsgIndexController extends GetxController {
  MsgIndexController();

  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<WKUIConversationMsg> conversations = [];
  final Map<String, MsgConversation> parsedConversations = {};
  final Set<String> parsingConversationKeys = <String>{};

  bool isLoading = false;

  _initData() {
    _loadConversations();

    /// 监听会频道信息刷新
    WKIM.shared.channelManager.addOnRefreshListener(
      "onRefreshChannelListener",
      _onRefreshChannelListener,
    );

    /// 会话列表刷新监听
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      "conversationListener2",
      _onRefreshConversationListener,
    );

    /// 消息状态刷新监听
    WKIM.shared.messageManager.addOnNewMsgListener(
      "newMsgListener2",
      _onNewMsgListener,
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

      //更新频道信息
      WKIM.shared.channelManager.addOrUpdateChannel(channel);
    }
  }

  /// 加载会话列表
  Future<void> _loadConversations() async {
    isLoading = true;
    try {
      // List<WKUIConversationMsg> data = MsgService.to.conversations;

      final data = await WKIM.shared.conversationManager.getAll();

      conversations.clear();
      conversations.addAll(data);
      parsedConversations.clear();
      parsingConversationKeys.clear();
      logger.d('加载了 ${data.length} 个会话');

      for (final conversation in conversations) {
        await getUserMessages(conversation.channelID);
        await parseConversation(conversation);
      }
    } catch (e) {
      logger.d('加载会话列表失败: $e');
    } finally {
      isLoading = false;
    }

    update(["msg_index"]);
  }

  Future<void> parseConversation(WKUIConversationMsg conversation) async {
    final key = _conversationKey(conversation);
    if (parsedConversations.containsKey(key) ||
        parsingConversationKeys.contains(key)) {
      return;
    }

    parsingConversationKeys.add(key);
    final channel = await conversation.getWkChannel();
    final lastMsg = await conversation.getWkMsg();

    parsedConversations[key] = MsgConversation(
      avatar: channel?.avatar ?? '',
      title: channel?.channelName ?? '未知',
      lastMessage: lastMsg?.messageContent?.displayText() ?? '',
    );
    parsingConversationKeys.remove(key);
  }

  MsgConversation? getParsedConversation(WKUIConversationMsg conversation) {
    return parsedConversations[_conversationKey(conversation)];
  }

  String _conversationKey(WKUIConversationMsg conversation) {
    return '${conversation.channelID}_${conversation.channelType}';
  }

  /// 更新频道信息回调
  _onRefreshChannelListener(WKChannel channel) {
    for (var item in conversations) {
      item.setWkChannel(channel);
    }
    update(["msg_index"]);
  }

  /// 新消息监听回调  ====> 接收方
  _onNewMsgListener(List<WKMsg> p1) {
    logger.d(
      '_onNewMsgListener   收到新消息: ${p1.map((msg) => msg.content).join(", ")}',
    );

    for (var msg in p1) {
      int index = conversations.indexWhere(
        (conv) =>
            conv.channelID == msg.channelID &&
            conv.channelType == msg.channelType,
      );
      if (index != -1) {
        conversations[index].setWkMsg(msg);
        conversations[index].lastMsgTimestamp = msg.timestamp;
        conversations[index].unreadCount++;
        update(["msg_index"]);
      } else {
        _loadConversations();
      }
    }
  }

  /// 会话列表刷新监听回调  ====> 接收方
  _onRefreshConversationListener(List<WKUIConversationMsg> p1) {
    // 会话列表有更新，刷新 UI
    logger.d('_onRefreshConversationListener   会话列表刷新，当前会话数量: ${p1.length}');
    _loadConversations();
    update(["msg_index"]);
  }
}
