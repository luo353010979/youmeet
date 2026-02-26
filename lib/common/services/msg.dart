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
  void onInit() {
    super.onInit();
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
      print("没有 token，无法连接 IM");
      return;
    }

    Options options = Options.newDefault(profile.id ?? '', token);

    options.addr = Constants.wkImAddr;

    // 可选：开启调试模式
    options.debug = true;

    // 初始化 SDK
    WKIM.shared.setup(options);

    print('WuKongIM SDK 初始化完成');
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

    /// 消息插入数据库监听 - 作为消息的主要来源
    WKIM.shared.messageManager.addOnMsgInsertedListener(_onMsgInserted);

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

    /// 获取频道信息监听
    WKIM.shared.channelManager.addOnGetChannelListener(_onGetChannelListener);
  }

  /// 连接状态监听回调
  _onConnectionStatus(int status, int? reason, ConnectionInfo? connectInfo) {
    switch (status) {
      case WKConnectStatus.connecting:
        print('IM 连接中...');
        break;
      case WKConnectStatus.success:
        print('IM 连接成功，节点ID: ${connectInfo?.nodeId}');
        break;
      case WKConnectStatus.fail:
        print('IM 连接失败，原因: $reason');
        break;
      case WKConnectStatus.noNetwork:
        print('网络异常，无法连接');
        break;
      case WKConnectStatus.kicked:
        print('被踢下线（其他设备登录）');
        break;
      case WKConnectStatus.syncMsg:
        print('正在同步消息...');
        break;
      case WKConnectStatus.syncCompleted:
        print('消息同步完成');
        break;
    }
  }

  /// 会话列表刷新监听回调  ====> 接收方
  _onRefreshConversationListener(List<WKUIConversationMsg> p1) {
    // 会话列表有更新，刷新 UI
    print('_onRefreshConversationListener   会话列表刷新，当前会话数量: ${p1.length}');
  }

  /// 会话同步监听回调  ===>初始化时
  _onSyncConversationListener(
    String lastSsgSeqs,
    int msgCount,
    int version,
    Function(WKSyncConversation p1) back,
  ) async {
    WKSyncConversation ret = WKSyncConversation();
    ret.conversations = [];
    try {
      final response = await MsgApi.syncConversations(
        lastSsgSeqs: lastSsgSeqs,
        msgCount: msgCount,
        version: version,
      );
      if (response.success) {
        ret = WKSyncConversationMapper.fromDynamic(response.result);
        print(
          '_onSyncConversationListener   会话同步成功: ${ret.conversations?.length ?? 0}',
        );

        ret.conversations?.forEach((conv) {
          WKIM.shared.channelManager.fetchChannelInfo(
            conv.channelID,
            conv.channelType,
          );
        });
      } else {
        print('_onSyncConversationListener   会话同步失败: ${response.message}');
      }
    } catch (e) {
      print('_onSyncConversationListener   会话同步异常: $e');
    }
    back(ret);
  }

  /// 新消息监听回调  ====> 接收方
  _onNewMsgListener(List<WKMsg> p1) {
    print(
      '_onNewMsgListener   收到新消息: ${p1.map((msg) => msg.content).join(", ")}',
    );
  }

  /// 消息状态刷新监听回调
  _onRefreshMsgListener(WKMsg p1) {
    print(
      '_onRefreshMsgListener   消息状态更新: ${p1.content}, 消息ID: ${p1.messageID}',
    );
  }

  /// 消息插入数据库监听回调   ===> 发送方
  _onMsgInserted(WKMsg msg) {
    print('_onMsgInserted   消息插入数据库: ${msg.content}, 消息ID: ${msg.messageID}');

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
    print(
      '同步频道消息: channelID=$channelID, channelType=$channelType, startMessageSeq=$startMessageSeq, endMessageSeq=$endMessageSeq, limit=$limit, pullMode=$pullMode',
    );

    // todo 文档6151

    // 这里可以调用接口获取频道消息列表，获取完成后调用 back 回调传入 WKSyncChannelMsg 对象
  }

  /// 附件上传监听回调
  _onUploadAttachmentListener(WKMsg p1, Function(bool p1, WKMsg p2) p2) {
    print('附件上传: 消息ID=${p1.messageID}, 状态=${p1}');

    // 这里可以调用接口上传附件，上传完成后调用 p2 回调传入上传结果和消息对象
  }

  _onGetChannelListener(
    String channelId,
    int channelType,
    Function(WKChannel p1) back,
  ) async {
    print('请求获取频道信息:');
    print('  频道ID: $channelId');
    print('  频道类型: $channelType');

    if (channelType == WKChannelType.personal) {
      // 获取个人频道信息

      UserApi.profile(id: channelId).then((info) {
        if (info.success) {
          final userInfo = info.result;
          print('获取频道信息成功: ${userInfo?.name}');

          WKChannel channel = WKChannel(channelId, channelType);
          channel.channelName = userInfo?.name ?? '';
          channel.avatar = userInfo?.portrait ?? '';

          // 保存到本地
          // WKIM.shared.channelManager.addOrUpdateChannel(channel);

          print('用户信息更新成功: ${channel.channelName}');

          back(channel);
        } else {
          print('获取频道信息失败: ${info.message}');
        }
      });
      String uid = UserService.to.profile.id ?? '';
      WKChannel channel = WKChannel(uid, WKChannelType.personal);
      channel.channelName = UserService.to.profile.name ?? '';
      channel.avatar = UserService.to.profile.portrait ?? '';

      // 保存到本地
      await WKIM.shared.channelManager.addOrUpdateChannel(channel);

      print('用户信息更新成功: ${channel.channelName}');

      back(channel);
    }
  }
}
