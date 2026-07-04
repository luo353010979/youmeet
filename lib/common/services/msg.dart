import 'package:flutter/material.dart';
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

  /// 当前正在打开的聊天频道ID（由 ChatController 维护）。
  /// 用于判断资质申请是否要弹全局审批框：正在该会话内则交给聊天卡片处理。
  String? activeChannelId;

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
    WKIM.shared.messageManager.removeNewMsgListener("qualificationGlobal");
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
    // 说明：这里只注册「全局/单例、与后端同步」的监听。
    // 具体某个聊天页的新消息/发送/分页，放在对应页面的 controller，
    // 会话列表刷新放 MsgIndexController。

    /// 连接状态监听
    WKIM.shared.connectionManager.addOnConnectionStatus(
      "connectionStatusListener",
      _onConnectionStatus,
    );

    /// 会话同步监听（初始化时与后端同步会话列表）
    WKIM.shared.conversationManager.addOnSyncConversationListener(
      _onSyncConversationListener,
    );

    /// 同步频道消息监听（与后端同步历史消息）
    WKIM.shared.messageManager.addOnSyncChannelMsgListener(
      _onSyncChannelMsgListener,
    );

    /// 附件上传监听
    WKIM.shared.messageManager.addOnUploadAttachmentListener(
      _onUploadAttachmentListener,
    );

    /// 获取频道信息监听
    WKIM.shared.channelManager.addOnGetChannelListener(_onGetChannelListener);

    /// 注册资质查看自定义消息类型
    WKIM.shared.messageManager.registerMsgContent(
      kQualificationContentType,
      (data) => QualificationContent().decodeJson(data),
    );

    /// 全局资质信令监听：无论在哪个页面都能收到申请并弹审批
    WKIM.shared.messageManager.addOnNewMsgListener(
      "qualificationGlobal",
      _onQualificationSignal,
    );
  }

  /// 全局资质信令处理（申请弹审批、同意/拒绝弹 toast）
  void _onQualificationSignal(List<WKMsg> msgs) {
    final myId = UserService.to.profile.id;
    for (final m in msgs) {
      if (m.contentType != kQualificationContentType) continue;
      // 忽略自己发出的信令
      if (m.fromUID == myId) continue;
      final content = m.messageContent;
      if (content is! QualificationContent) continue;

      switch (content.action) {
        case QualificationAction.apply:
          // 正在该会话页内则交给聊天卡片处理，避免和卡片重复
          if (activeChannelId == m.channelID) break;
          _showApplyDialog(m, content);
          break;
        case QualificationAction.agree:
          Loading.toast('对方已同意查看你的资质');
          break;
        case QualificationAction.reject:
          Loading.toast('对方已拒绝');
          break;
      }
    }
  }

  /// 弹出资质查看审批框
  void _showApplyDialog(WKMsg msg, QualificationContent content) {
    final name = content.applicantName.isNotEmpty ? content.applicantName : '对方';
    Get.dialog(
      AlertDialog(
        title: const Text('资质查看申请'),
        content: Text('$name 申请查看您的${QualificationItem.labels(content.items)}，是否同意？'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              respondQualification(msg, content, false);
            },
            child: const Text('拒绝'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              respondQualification(msg, content, true);
            },
            child: const Text('同意'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// 响应资质申请（同意/拒绝）：同意时先向后端登记授权，再回发信令
  Future<void> respondQualification(
    WKMsg msg,
    QualificationContent content,
    bool agree,
  ) async {
    if (agree) {
      // TODO(后端对接): 调用授权接口，登记 content.applicantId 可查看当前用户的 content.items
      // 例如：await UserApi.approveQualification(
      //   applicantId: content.applicantId, items: content.items);
    }
    await sendQualificationSignal(
      channelId: msg.channelID, // 回给申请方（个人频道ID即对方用户ID）
      action: agree ? QualificationAction.agree : QualificationAction.reject,
      reqId: content.reqId,
      items: content.items,
      applicantId: content.applicantId,
      applicantName: content.applicantName,
    );
  }

  /// 发送资质查看信令
  Future<void> sendQualificationSignal({
    required String channelId,
    required String action,
    required String reqId,
    List<String> items = const [],
    String? applicantId,
    String? applicantName,
  }) async {
    final content = QualificationContent(
      action: action,
      reqId: reqId,
      items: items,
      applicantId: applicantId ?? UserService.to.profile.id ?? '',
      applicantName: applicantName ?? UserService.to.profile.name ?? '',
    );
    final channel = WKChannel(channelId, WKChannelType.personal);
    await WKIM.shared.messageManager.sendMessage(content, channel);
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

        // 说明：不在这里对每个会话循环拉用户资料（会造成请求风暴、职责错位）。
        // 频道的昵称/头像改由 SDK 的按需回调 _onGetChannelListener 解析并缓存。

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
    logger.d('附件上传: 消息ID=${p1.messageID}, 状态=$p1');

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

  /// 频道信息按需获取回调
  /// SDK 在缺少某个频道(个人频道即对方/自己用户ID)的名称、头像时会回调这里，
  /// 我们按 channelId 拉后端资料回填并缓存；SDK 会持久化，不会重复请求同一频道。
  _onGetChannelListener(
    String channelId,
    int channelType,
    Function(WKChannel wkChannel) back,
  ) async {
    final channel = WKChannel(channelId, channelType);

    // 自己：直接用本地资料，省一次请求
    if (channelId == UserService.to.profile.id) {
      channel.channelName = UserService.to.profile.name ?? "";
      channel.avatar = UserService.to.profile.portrait ?? "";
      back(channel);
      return;
    }

    // 对方：按需拉后端资料并缓存到 userMap
    try {
      final response = await UserApi.profile(id: channelId);
      if (response.success && response.result != null) {
        final user = response.result!;
        userMap[channelId] = user;
        channel.channelName = user.name ?? "";
        channel.avatar = user.portrait ?? "";
      } else {
        logger.d('获取频道用户信息失败: ${response.message}');
      }
    } catch (e) {
      logger.d('获取频道用户信息异常: $e');
    }
    back(channel);
  }

  /// 频道ID(用户ID) -> 用户资料 的缓存，由 _onGetChannelListener 按需填充
  Map<String, UserMessage?> userMap = {};
}
