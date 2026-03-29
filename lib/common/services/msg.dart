import 'package:get/get.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/manager/connect_manager.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class MsgService extends GetxService {
  static MsgService get to => Get.find();

  @override
  void onClose() {
    super.onClose();
    disconnectIM();
  }

  void init() {
    initWuKongIM();
    initListeners();
    connectIM();
  }

  void connectIM() {
    WKIM.shared.connectionManager.connect();
  }

  void disconnectIM() {
    WKIM.shared.connectionManager.disconnect(false);
    WKIM.shared.connectionManager.removeOnConnectionStatus(
      'connectionStatusListener',
    );
    WKIM.shared.messageManager.removeNewMsgListener('newMsgListener');
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener(
      'conversationListener',
    );
    WKIM.shared.messageManager.removeOnRefreshMsgListener('refreshMsgListener');
  }

  void initWuKongIM() {
    final token = UserService.to.token;
    final profile = UserService.to.profile;

    if (token.isEmpty) {
      logger.d("没有 token，无法连接 IM");
      return;
    }

    Options options = Options.newDefault(profile.id ?? '', token);

    options.addr = Constants.wkImAddr;

    // 可选：开启调试模式
    options.debug = true;

    // 初始化 SDK
    WKIM.shared.setup(options);

    logger.d('WuKongIM SDK 初始化完成');
  }

  void initListeners() {
    /// 连接状态监听
    WKIM.shared.connectionManager.addOnConnectionStatus(
      "connectionStatusListener",
      _onConnectionStatus,
    );

    /// 会话列表刷新监听
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      "conversationListener",
      _onRefreshConversationListener,
    );

    /// 会话同步监听
    WKIM.shared.conversationManager.addOnSyncConversationListener(
      _onSyncConversationListener,
    );

    /// 新消息监听
    WKIM.shared.messageManager.addOnNewMsgListener(
      "newMsgListener",
      _onNewMsgListener,
    );

    /// 消息状态监听
    WKIM.shared.messageManager.addOnRefreshMsgListener(
      "refreshMsgListener",
      _onRefreshMsgListener,
    );

    /// 同步频道消息监听
    WKIM.shared.messageManager.addOnSyncChannelMsgListener(
      _onSyncChannelMsgListener,
    );

    /// 附件上传监听
    WKIM.shared.messageManager.addOnUploadAttachmentListener(
      _onUploadAttachmentListener,
    );

    WKIM.shared.channelManager.addOnGetChannelListener(_onGetChannelListener);
  }

  /// 连接状态监听回调
  _onConnectionStatus(int status, int? reason, ConnectionInfo? connectInfo) {
    switch (status) {
      case WKConnectStatus.connecting:
        logger.d('IM 连接中...');
        break;
      case WKConnectStatus.success:
        logger.d('IM 连接成功，节点ID: ${connectInfo?.nodeId}');
        break;
      case WKConnectStatus.fail:
        logger.d('IM 连接失败，原因: $reason');
        break;
      case WKConnectStatus.noNetwork:
        logger.d('网络异常，无法连接');
        break;
      case WKConnectStatus.kicked:
        logger.d('被踢下线（其他设备登录）');
        break;
      case WKConnectStatus.syncMsg:
        logger.d('正在同步消息...');
        break;
      case WKConnectStatus.syncCompleted:
        logger.d('消息同步完成');
        break;
    }
  }

  /// 会话列表刷新监听回调  ====> 接收方
  _onRefreshConversationListener(List<WKUIConversationMsg> p1) {
    // 会话列表有更新，刷新 UI
    // logger.d('_onRefreshConversationListener   会话列表刷新，当前会话数量: ${p1.length}');
  }

  /// 会话列表同步监听回调  ===>初始化时
  _onSyncConversationListener(
    String lastSsgSeqs,
    int msgCount,
    int version,
    Function(WKSyncConversation p1) back,
  ) async {
    try {
      WKSyncConversation ret = WKSyncConversation();
      final response = await MsgApi.syncConversations(
        lastSsgSeqs: lastSsgSeqs,
        msgCount: msgCount,
        version: version,
      );
      if (response.success) {
        ret = WKSyncConversationMapper.fromDynamic(response.result);
        final conversations = ret.conversations ?? [];

        // 获取用户消息并更新至频道信息
        for(var cov in conversations){
          getUserMessages(cov.channelID);
        }

        logger.d(
          '_onSyncConversationListener   会话同步成功: 当前 ${ret.conversations?.length ?? 0} 条会话',
        );
        back(ret);
      } else {
        logger.d('_onSyncConversationListener   会话同步失败: ${response.message}');
      }
    } catch (e) {
      logger.d('_onSyncConversationListener   会话同步异常: $e');
    }
  }

  /// 新消息监听回调  ====> 接收方
  _onNewMsgListener(List<WKMsg> p1) {

    p1.forEach((msg) {
      // 这里可以根据需要刷新聊天列表 UI 或者显示通知等
    logger.d(
        '新消息内容: ${msg.content}, 消息ID: ${msg.messageID}, 来自：${msg.getFrom()?.channelName}',
    );
    });
  }

  /// 消息状态刷新监听回调
  _onRefreshMsgListener(WKMsg p1) {
    logger.d(
      '_onRefreshMsgListener   消息状态更新: ${p1.content}, 消息ID: ${p1.messageID}',
    );
  }

  /// 同步频道消息监听回调
  _onSyncChannelMsgListener(
    String channelID,
    int channelType,
    int startMessageSeq,
    int endMessageSeq,
    int limit,
    int pullMode,
    Function(WKSyncChannelMsg? p1) back,
  ) async {
    logger.d(
      '_onSyncChannelMsgListener 同步频道消息: channelID=$channelID, channelType=$channelType, startMessageSeq=$startMessageSeq, endMessageSeq=$endMessageSeq, limit=$limit, pullMode=$pullMode',
    );

    final response = await MsgApi.syncHistoryMessages(
      channelID: channelID,
      pullMode: pullMode,
      startMessageSeq: startMessageSeq,
      endMessageSeq: endMessageSeq,
      limit: limit,
    );

    if (response.success) {
      final wkSyncChannelMsg = WKSyncChannelMsgMapper.fromDynamic(
        response.result,
      );
      back(wkSyncChannelMsg);
    } else {
      logger.d('_onSyncChannelMsgListener 同步频道消息失败: ${response.message}');
    }
  }

  /// 附件上传监听回调
  _onUploadAttachmentListener(WKMsg p1, Function(bool p1, WKMsg p2) p2) {
    logger.d('附件上传: 消息ID=${p1.messageID}, 状态=${p1}');

    // 这里可以调用接口上传附件，上传完成后调用 p2 回调传入上传结果和消息对象
  }

  /// 获取频道历史消息
  /// [channelId] 频道ID
  /// [channelType] 频道类型，默认为个人频道
  /// [oldestOrderSeq] 最后一次消息大orderSeq 第一次进入聊天传入0
  /// [limit] 每次拉取的消息数量，默认为20
  /// [pullModel] 拉取模式 0:向下拉取 1:向上拉取
  /// [aroundMsgOrderSeq] 查询此消息附近消息
  /// [onComplete] 拉取完成后的回调，返回拉取到的消息列表
  /// [onLoading] 拉取过程中加载状态的回调
  Future<void> getHistoryMessages(
    String channelId, {
    int channelType = WKChannelType.personal,
    int oldestOrderSeq = 0,
    int pullModel = 0,
    int limit = 100,
    int aroundMsgOrderSeq = 0,
    required Function(List<WKMsg>) onComplete,
    Function()? onLoading,
  }) async {
    WKIM.shared.messageManager.getOrSyncHistoryMessages(
      channelId,
      channelType,
      oldestOrderSeq,
      oldestOrderSeq == 0,
      pullModel,
      limit,
      0,
      (List<WKMsg> p1) {
        onComplete(p1);
      },
      () {
        onLoading?.call();
      },
    );
  }

  _onGetChannelListener(
    String channelId,
    int channelType,
    Function(WKChannel wkChannel) back,
  ) {
    WKChannel channel = WKChannel(channelId, channelType);
    channel.channelName = UserService.to.profile.name ?? "";
    channel.avatar = UserService.to.profile.portrait ?? "";

    logger.d("更新成功：${channel.channelName}");
    back(channel);
  }

  Map<String,UserMessage?> userMap = {};

  /// 获取用户消息并更新至频道信息
  Future getUserMessages(String channelId) async {
    final response = await UserApi.profile(id: channelId);
    if (response.success) {
      final userMessage = response.result;
      userMap[channelId] = userMessage;
      WKChannel channel = WKChannel(channelId, WKChannelType.personal);
      channel.channelName = userMessage?.name ?? '';
      channel.avatar = userMessage?.portrait ?? '';
      //更新频道信息
      WKIM.shared.channelManager.addOrUpdateChannel(channel);
      logger.d('用户信息更新成功: ${channel.channelName}');
    }else{
      logger.d('用户信息更新失败: ${response.message}');
    }
  }
}
