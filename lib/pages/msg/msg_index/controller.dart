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

  bool isLoading = false;

  _initData() {
    _loadConversations();
    WKIM.shared.channelManager.addOnRefreshListener("onRefreshChannelListener", _onRefreshChannelListener);
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
      print('用户信息更新成功: ${channel.channelName}');

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
      print('加载了 ${data.length} 个会话');

      for (final conversation in conversations) {
        await getUserMessages(conversation.channelID);
        await parseConversation(conversation);
      }
    } catch (e) {
      print('加载会话列表失败: $e');
    } finally {
      isLoading = false;
    }

    update(["msg_index"]);
  }

  // Remove async from parseConversation, make it return Future<void>
  Future<void> parseConversation(WKUIConversationMsg conversation) async {
    final key = _conversationKey(conversation);
    if (parsedConversations.containsKey(key) || parsingConversationKeys.contains(key)) {
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
    // Do not call update here to avoid unnecessary rebuilds
  }

  MsgConversation? getParsedConversation(WKUIConversationMsg conversation) {
    return parsedConversations[_conversationKey(conversation)];
  }

  String _conversationKey(WKUIConversationMsg conversation) {
    return '${conversation.channelID}_${conversation.channelType}';
  }

  /// 更新频道信息回调
  _onRefreshChannelListener(WKChannel channel) {
    print("${channel.channelName}---${channel.avatar}");
    conversations.forEach((item) {
      item.setWkChannel(channel);
    });
    update(["msg_index"]);
  }
}
