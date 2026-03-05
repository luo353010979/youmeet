import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/cmd.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/manager/connect_manager.dart';
import 'package:wukongimfluttersdk/model/wk_image_content.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/model/wk_voice_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class MsgService extends GetxService {
  static MsgService get to => Get.find();

  // 连接状态
  bool _isConnected = false;
  bool _isConnecting = false;

  // 当前用户信息
  String _uid = '';
  String _token = '';

  // 获取器
  bool get isConnected => _isConnected;

  bool get isConnecting => _isConnecting;

  /// 初始化 SDK
  Future<bool> init(String uid, String token) async {
    _uid = uid;
    _token = token;

    try {
      // 1. 创建配置
      Options options = Options.newDefault(uid, token);
      options.debug = kDebugMode; // 调试模式下开启日志

      // 2. 配置动态获取服务器地址
      options.addr = Constants.wkImAddr;

      // 3. 初始化 SDK
      bool success = await WKIM.shared.setup(options);

      if (success) {
        // 4. 注册监听器
        _registerListeners();

        // 5. 连接 IM
        connect();

        logger.d('IMService 初始化成功');
      } else {
        logger.d('IMService 初始化失败');
      }

      return success;
    } catch (e) {
      logger.d('IMService 初始化异常: $e');
      return false;
    }
  }

  /// 连接 IM
  void connect() {
    if (_isConnecting) {
      logger.d('正在连接中，请勿重复调用');
      return;
    }

    _isConnecting = true;
    WKIM.shared.connectionManager.connect();
  }

  /// 断开连接
  void disconnect({bool isLogout = false}) {
    WKIM.shared.connectionManager.disconnect(isLogout);
    _isConnected = false;
    _isConnecting = false;

    if (isLogout) {
      _uid = '';
      _token = '';
    }
  }

  /// 注册所有监听器
  void _registerListeners() {
    // 1. 连接状态监听器
    WKIM.shared.connectionManager.addOnConnectionStatus('im_connection', (status, reason, connectInfo) {
      _handleConnectionStatus(status, reason, connectInfo);
    });

    // 2. 新消息监听器
    WKIM.shared.messageManager.addOnNewMsgListener('im_new_msg', (List<WKMsg> msgs) {
      _onNewMsgListener(msgs);
    });

    // 3. 消息入库监听器
    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      _onMsgInserted(msg);
    });

    // 4. CMD 消息监听器
    // WKIM.shared.cmdManager.addOnCmdListener('im_cmd', (WKCMD cmd) async {
    //   await _handleCmdMessage(cmd);
    // });

    // 5. 历史消息同步监听器
    WKIM.shared.messageManager.addOnSyncChannelMsgListener((
      channelID,
      channelType,
      startSeq,
      endSeq,
      limit,
      pullMode,
      back,
    ) {
      _onSyncChannelMsgListener(channelID, channelType, startSeq, endSeq, limit, pullMode, back);
    });

    // 6. 获取频道信息监听器
    // WKIM.shared.channelManager.addOnGetChannelListener((
    //   channelId,
    //   channelType,
    //   back,
    // ) {
    //   _getChannelInfo(channelId, channelType);
    // });

    /// 会话列表刷新监听器
    WKIM.shared.conversationManager.addOnRefreshMsgListListener('conversationListener', (
      List<WKUIConversationMsg> conversations,
    ) {
      _onRefreshConversationListener(conversations);
    });

    WKIM.shared.messageManager.addOnRefreshMsgListener('refreshMsgListener', (WKMsg msg) {
      _onRefreshMsgListener(msg);
    });

    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      _onMsgInserted(msg);
    });
    // 7. 会话同步监听器
    WKIM.shared.conversationManager.addOnSyncConversationListener((lastSsgSeqs, msgCount, version, back) {
      _onSyncConversationListener(lastSsgSeqs, msgCount, version, back);
    });

    // 8. 附件上传监听器
    // WKIM.shared.messageManager.addOnUploadAttachmentListener((wkMsg, back) {
    //   _uploadAttachment(wkMsg, back);
    // });

    logger.d('所有监听器注册完成');
  }

  /// 处理连接状态
  void _handleConnectionStatus(int status, int? reason, ConnectionInfo? connectInfo) {
    switch (status) {
      case WKConnectStatus.connecting:
        _isConnecting = true;
        _isConnected = false;
        logger.d('IM 连接中...');
        break;

      case WKConnectStatus.success:
        _isConnecting = false;
        _isConnected = true;
        String nodeId = connectInfo?.nodeId.toString() ?? '未知';
        logger.d('IM 连接成功，节点ID: $nodeId');
        break;

      case WKConnectStatus.fail:
        _isConnecting = false;
        _isConnected = false;
        logger.d('IM 连接失败，原因: $reason');
        break;

      case WKConnectStatus.noNetwork:
        _isConnecting = false;
        _isConnected = false;
        logger.d('IM 无网络');
        break;

      case WKConnectStatus.kicked:
        _isConnecting = false;
        _isConnected = false;
        logger.d('IM 被踢下线');
        break;

      case WKConnectStatus.syncMsg:
        logger.d('IM 正在同步消息...');
        break;

      case WKConnectStatus.syncCompleted:
        logger.d('IM 消息同步完成');
        break;
    }
  }

  /// 处理 CMD 消息
  // Future<void> _handleCmdMessage(WKCMD cmd) async {
  //   logger.d('收到 CMD 消息: ${cmd.cmd}');

  //   if (cmd.cmd == 'messageRevoke') {
  //     var channelID = cmd.param['channel_id'];
  //     var channelType = cmd.param['channel_type'];
  //     if (channelID != '') {
  //       var maxVersion = await WKIM.shared.messageManager
  //           .getMaxExtraVersionWithChannel(channelID, channelType);
  //       await BackendAPI.syncMessageExtra(channelID, channelType, maxVersion);
  //     }
  //   } else if (cmd.cmd == 'channelUpdate') {
  //     var channelID = cmd.param['channel_id'];
  //     var channelType = cmd.param['channel_type'];
  //     if (channelID != '') {
  //       if (channelType == WKChannelType.personal) {
  //         await BackendAPI.getUserInfo(channelID);
  //       } else if (channelType == WKChannelType.group) {
  //         await BackendAPI.getGroupInfo(channelID);
  //       }
  //     }
  //   } else if (cmd.cmd == 'unreadClear') {
  //     var channelID = cmd.param['channel_id'];
  //     var channelType = cmd.param['channel_type'];
  //     var unread = cmd.param['unread'];
  //     if (channelID != '') {
  //       WKIM.shared.conversationManager.updateRedDot(
  //         channelID,
  //         channelType,
  //         unread,
  //       );
  //     }
  //   }
  // }

  /// 同步历史消息
  // void _syncChannelMessages(
  //   String channelID,
  //   int channelType,
  //   int startSeq,
  //   int endSeq,
  //   int limit,
  //   int pullMode,
  //   Function(List<WKMsg>) back,
  // ) async {
  //   logger.d('同步历史消息: $channelID');

  //   List<WKMsg> messages = await BackendAPI.syncChannelMessages(
  //     channelID,
  //     channelType,
  //     startSeq,
  //     endSeq,
  //     limit,
  //     pullMode,
  //   );

  //   back(messages);
  // }

  /// 获取频道信息
  // void _getChannelInfo(String channelId, int channelType) async {
  //   logger.d('获取频道信息: $channelId, $channelType');

  //   if (channelType == WKChannelType.personal) {
  //     await BackendAPI.getUserInfo(channelId);
  //   } else if (channelType == WKChannelType.group) {
  //     await BackendAPI.getGroupInfo(channelId);
  //   }
  // }

  /// 上传附件
  // void _uploadAttachment(WKMsg wkMsg, Function(bool, WKMsg) back) async {
  //   if (wkMsg.contentType == WkMessageContentType.image) {
  //     WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
  //     String? url = await BackendAPI.uploadImage(imageContent.localPath);

  //     if (url != null) {
  //       imageContent.url = url;
  //       wkMsg.messageContent = imageContent;
  //       back(true, wkMsg);
  //     } else {
  //       back(false, wkMsg);
  //     }
  //   } else if (wkMsg.contentType == WkMessageContentType.voice) {
  //     WKVoiceContent voiceContent = wkMsg.messageContent! as WKVoiceContent;
  //     String? url = await BackendAPI.uploadVoice(voiceContent.localPath);

  //     if (url != null) {
  //       voiceContent.url = url;
  //       wkMsg.messageContent = voiceContent;
  //       back(true, wkMsg);
  //     } else {
  //       back(false, wkMsg);
  //     }
  //   } else if (wkMsg.contentType == WkMessageContentType.video) {
  //     WKVideoContent videoContent = wkMsg.messageContent! as WKVideoContent;
  //     String? videoUrl = await BackendAPI.uploadVideo(videoContent.localPath);
  //     String? coverUrl = await BackendAPI.uploadImage(
  //       videoContent.coverLocalPath,
  //     );

  //     if (videoUrl != null && coverUrl != null) {
  //       videoContent.url = videoUrl;
  //       videoContent.cover = coverUrl;
  //       wkMsg.messageContent = videoContent;
  //       back(true, wkMsg);
  //     } else {
  //       back(false, wkMsg);
  //     }
  //   }
  // }

  /// 发送文本消息
  Future<WKMsg?> sendTextMessage(String text, String channelID, int channelType) async {
    try {
      WKTextContent textContent = WKTextContent(text);
      WKChannel channel = WKChannel(channelID, channelType);

      WKMsg msg = await WKIM.shared.messageManager.sendMessage(textContent, channel);
      logger.d('文本消息发送成功: ${msg.messageID}');

      return msg;
    } catch (e) {
      logger.d('文本消息发送失败: $e');
      return null;
    }
  }

  /// 发送图片消息
  // Future<WKMsg?> sendImageMessage(
  //   String imagePath,
  //   String channelID,
  //   int channelType,
  // ) async {
  //   try {
  //     // 获取图片尺寸
  //     var decodedImage = await decodeImageFromList(
  //       await File(imagePath).readAsBytes(),
  //     );
  //     int width = decodedImage.width;
  //     int height = decodedImage.height;

  //     WKImageContent imageContent = WKImageContent(width, height);
  //     imageContent.localPath = imagePath;

  //     WKChannel channel = WKChannel(channelID, channelType);

  //     WKMsg msg = await WKIM.shared.messageManager.sendMessage(
  //       imageContent,
  //       channel,
  //     );
  //     logger.d('图片消息发送中...');

  //     return msg;
  //   } catch (e) {
  //     logger.d('图片消息发送失败: $e');
  //     return null;
  //   }
  // }

  /// 发送语音消息
  Future<WKMsg?> sendVoiceMessage(String voicePath, int duration, String channelID, int channelType) async {
    try {
      WKVoiceContent voiceContent = WKVoiceContent(duration);
      voiceContent.localPath = voicePath;

      WKChannel channel = WKChannel(channelID, channelType);

      WKMsg msg = await WKIM.shared.messageManager.sendMessage(voiceContent, channel);
      logger.d('语音消息发送中...');

      return msg;
    } catch (e) {
      logger.d('语音消息发送失败: $e');
      return null;
    }
  }

  /// 获取会话列表
  Future<List<WKUIConversationMsg>> getConversationList() async {
    List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.getAll();
    logger.d('查询到 ${conversations.length} 个会话');
    return conversations;
  }

  /// 获取历史消息
  // Future<List<WKMsg>> getHistoryMessages(
  //   String channelID,
  //   int channelType, {
  //   int limit = 20,
  // }) async {
  //   List<WKMsg> messages = await WKIM.shared.messageManager
  //       .getOrSyncHistoryMessages(
  //         channelID,
  //         WKChannelType.personal,
  //         oldestOrderSeq,
  //         oldestOrderSeq == 0,
  //         0,
  //         limit,
  //         0,
  //         (List<WKMsg> list) {
  //           logger.d("iGetOrSyncHistoryMsgBack: ${list.length}");
  //           onComplete(list);
  //         },
  //         () {
  //           onLoding?.call();
  //         },
  //       );
  //   logger.d('查询到 ${messages.length} 条历史消息');
  //   return messages.reversed; // 转换为升序
  // }

  /// 标记已读
  Future<void> markAsRead(String channelID, int channelType) async {
    await WKIM.shared.messageManager.clearWithChannel(channelID, channelType);
    logger.d('标记已读: $channelID');
  }

  /// 置顶会话
  // Future<void> setConversationTop(
  //   String channelID,
  //   int channelType,
  //   bool isTop,
  // ) async {
  //   await WKIM.shared.conversationManager.setTop(channelID, channelType, isTop);
  //   logger.d('会话 $channelID ${isTop ? "已置顶" : "已取消置顶"}');
  // }

  /// 设置免打扰
  // Future<void> setConversationMute(
  //   String channelID,
  //   int channelType,
  //   bool isMute,
  // ) async {
  //   await WKIM.shared.conversationManager.setMute(
  //     channelID,
  //     channelType,
  //     isMute,
  //   );
  //   logger.d('会话 $channelID ${isMute ? "已免打扰" : "已取消免打扰"}');
  // }

  /// 删除会话
  Future<void> deleteConversation(String channelID, int channelType) async {
    await WKIM.shared.conversationManager.deleteMsg(channelID, channelType);
    logger.d('会话 $channelID 已删除');
  }

  /// 销毁
  void dispose() {
    WKIM.shared.connectionManager.removeOnConnectionStatus('im_connection');
    WKIM.shared.messageManager.removeNewMsgListener('im_new_msg');
    WKIM.shared.cmdManager.removeCmdListener('im_cmd');
    // 注意：其他监听器可能没有 remove 方法

    logger.d('IMService 已销毁');
  }

  @override
  void onClose() {
    super.onClose();
    WKIM.shared.connectionManager.disconnect(true);
    WKIM.shared.connectionManager.removeOnConnectionStatus('connectionStatusListener');
    WKIM.shared.messageManager.removeNewMsgListener('newMsgListener');
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener('conversationListener');
    WKIM.shared.messageManager.removeOnRefreshMsgListener('refreshMsgListener');
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
