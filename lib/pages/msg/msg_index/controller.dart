import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
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

  _initData() {
    _loadConversations();

    /// 监听频道信息刷新
    WKIM.shared.channelManager.addOnRefreshListener(
      "onRefreshChannelListener2",
      _onRefreshChannelListener,
    );

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
    WKIM.shared.channelManager.removeOnRefreshListener(
      "onRefreshChannelListener2",
    );
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener(
      "conversationListener2",
    );
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
    try {
      final data = await WKIM.shared.conversationManager.getAll();
      conversations = data;
      parsedConversations.clear();
      parsingConversationKeys.clear();
      logger.d('加载了 ${data.length} 个会话');

      for (final conversation in conversations) {
        final channel = await conversation.getWkChannel();
        if (channel?.channelName.isEmpty == true) {
          await getUserMessages(conversation.channelID);
        }
        await parseConversation(conversation);
      }
    } catch (e) {
      logger.d('加载会话列表失败: $e');
    } finally {
      update(["msg_index"]);
    }
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

  /// 频道信息更新
  _onRefreshChannelListener(WKChannel channel) {
    logger.d('频道信息刷新: ${channel.channelID}, 新名称: ${channel.channelName}');
    for (var item in conversations) {
      item.setWkChannel(channel);
    }
    update(["msg_index"]);
  }

  /// 会话列表刷新监听回调  ====> 接收方
  _onRefreshConversationListener(List<WKUIConversationMsg> p1) {
    logger.d('_onRefreshConversationListener   会话列表刷新，当前会话数量: ${p1.length}');
    // 会话列表有更新，刷新 UI
    _loadConversations();

  }
}
