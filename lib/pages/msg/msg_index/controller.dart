import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
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
    _initListeners();
    update(["msg_index"]);
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

  @override
  void onClose() {
    super.onClose();
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener(
      'conversationListener',
    );
  }

  /// 初始化监听器
  void _initListeners() {
    // 监听会话列表刷新
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      'conversationListener',
      (List<WKUIConversationMsg> uiMsgs) {
        print('会话列表刷新: ${uiMsgs.length} 条');
        _loadConversations();
      },
    );
  }

  /// 加载会话列表
  Future<void> _loadConversations() async {
    isLoading = true;
    try {
      List<WKUIConversationMsg> data = await WKIM.shared.conversationManager
          .getAll();

      conversations.clear();
      conversations.addAll(data);
      parsedConversations.clear();
      parsingConversationKeys.clear();

      print('加载了 ${data.length} 个会话');
    } catch (e) {
      print('加载会话列表失败: $e');
    } finally {
      isLoading = false;
    }

    update(["msg_index"]);
  }

  void parseConversation(WKUIConversationMsg conversation) async {
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
    update(["msg_index"]);
  }

  MsgConversation? getParsedConversation(WKUIConversationMsg conversation) {
    return parsedConversations[_conversationKey(conversation)];
  }

  String _conversationKey(WKUIConversationMsg conversation) {
    return '${conversation.channelID}_${conversation.channelType}';
  }
}
