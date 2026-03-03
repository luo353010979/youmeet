import 'package:get/get.dart';
import 'package:wukongimfluttersdk/common/options.dart';
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
    WKIM.shared.connectionManager.disconnect(true);
    WKIM.shared.connectionManager.removeOnConnectionStatus('connectionStatusListener');
    WKIM.shared.messageManager.removeNewMsgListener('newMsgListener');
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener('conversationListener');
    WKIM.shared.messageManager.removeOnRefreshMsgListener('refreshMsgListener');
  }

  void init() {
    initWuKongIM();
    initListeners();
    connectIM();
  }

  void connectIM() {
    WKIM.shared.connectionManager.connect();
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
    WKIM.shared.connectionManager.addOnConnectionStatus("connectionStatusListener", _onConnectionStatus);

    /// 会话列表刷新监听
    WKIM.shared.conversationManager.addOnRefreshMsgListListener("conversationListener", _onRefreshConversationListener);

    /// 会话同步监听
    WKIM.shared.conversationManager.addOnSyncConversationListener(_onSyncConversationListener);

    /// 新消息监听
    WKIM.shared.messageManager.addOnNewMsgListener("newMsgListener", _onNewMsgListener);

    /// 消息插入数据库监听 - 作为消息的主要来源
    WKIM.shared.messageManager.addOnMsgInsertedListener(_onMsgInserted);

    /// 消息状态监听
    WKIM.shared.messageManager.addOnRefreshMsgListener("refreshMsgListener", _onRefreshMsgListener);

    /// 同步频道消息监听
    WKIM.shared.messageManager.addOnSyncChannelMsgListener(_onSyncChannelMsgListener);

    /// 附件上传监听
    WKIM.shared.messageManager.addOnUploadAttachmentListener(_onUploadAttachmentListener);

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
    logger.d('_onRefreshConversationListener   会话列表刷新，当前会话数量: ${p1.length}');
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
      final response = await MsgApi.syncConversations(lastSsgSeqs: lastSsgSeqs, msgCount: msgCount, version: version);
      if (response.success) {
        ret = WKSyncConversationMapper.fromDynamic(response.result);
        logger.d('_onSyncConversationListener   会话同步成功: 当前 ${ret.conversations?.length ?? 0} 条会话');
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
    logger.d('_onNewMsgListener   收到新消息: ${p1.map((msg) => msg.content).join(", ")}');
  }

  /// 消息状态刷新监听回调
  _onRefreshMsgListener(WKMsg p1) {
    logger.d('_onRefreshMsgListener   消息状态更新: ${p1.content}, 消息ID: ${p1.messageID}');
  }

  /// 消息插入数据库监听回调   ===> 发送方
  _onMsgInserted(WKMsg msg) {
    logger.d('_onMsgInserted   消息插入数据库: ${msg.content}, 消息ID: ${msg.messageID}');
    // 此时可以刷新聊天列表 UI
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
  ) {
    logger.d(
      '同步频道消息: channelID=$channelID, channelType=$channelType, startMessageSeq=$startMessageSeq, endMessageSeq=$endMessageSeq, limit=$limit, pullMode=$pullMode',
    );

    // todo 文档6151
  }

  /// 附件上传监听回调
  _onUploadAttachmentListener(WKMsg p1, Function(bool p1, WKMsg p2) p2) {
    logger.d('附件上传: 消息ID=${p1.messageID}, 状态=${p1}');

    // 这里可以调用接口上传附件，上传完成后调用 p2 回调传入上传结果和消息对象
  }

}
