import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class TypeModel {
  final int id;
  final String title;
  final String icon;

  TypeModel({required this.id, required this.title, required this.icon});
}

class ChatController extends GetxController with WidgetsBindingObserver {
  ChatController();

  // 记录上一次底部 inset（键盘高度），用于判断键盘是弹出还是收起
  double _lastBottomInset = 0;

  EasyRefreshController refreshController = EasyRefreshController(controlFinishLoad: true);
  
  // 编辑报告请求参数
  EditReportReq req = EditReportReq(id: UserService.to.profile.id!);

  // 频道ID（个人频道即为对方用户ID）
  String channelId = "";

  // 频道信息(用户信息)
  final userMessage = UserMessage().obs;

  // 安全报告信息
  final report = SafeReportModel().obs;

  // 消息列表
  final messages = <WKMsg>[].obs;

  // 资质申请状态：reqId -> 'apply'(待处理) / 'agree' / 'reject'
  final reqStatus = <String, String>{}.obs;

  // 整份资质报告的权限状态（由历史信令推导）：
  // '' 未申请 / 'pending' 等待同意 / 'agree' 已同意 / 'reject' 已拒绝
  final permission = ''.obs;

  // 一次性申请整份报告涉及的资质项
  static const List<String> allItems = [
    QualificationItem.health,
    QualificationItem.tax,
    QualificationItem.credit,
  ];

  // 历史消息分页参数
  int _oldestOrderSeq = 0;

  final isComplete = false.obs;

  bool isFirst = true;

  // 是否显示"新消息"提示气泡（翻看历史时收到新消息且未在底部）
  final showNewMsgTip = false.obs;

  final ScrollController scrollController = ScrollController();

  // 输入框控制器（发送后清空文本）
  final TextEditingController inputController = TextEditingController();

  String? get displayRealPic => req.healthPic ?? report.value.healthPic ?? "";

  String? get displayPayTaxesPic =>
      req.payTaxesPic ?? report.value.payTaxesPic ?? "";

  String? get displayCreditPic => req.creditPic ?? report.value.creditPic ?? "";

  List<TypeModel> types = [
    TypeModel(
      id: 1,
      title: LocaleKeys.loveFourTitle1.tr,
      icon: AssetsSvgs.icMsg_01Svg,
    ),
    TypeModel(
      id: 2,
      title: LocaleKeys.loveFourTitle2.tr,
      icon: AssetsSvgs.icMsg_02Svg,
    ),
    TypeModel(
      id: 3,
      title: LocaleKeys.loveFourTitle3.tr,
      icon: AssetsSvgs.icMsg_03Svg,
    ),
  ];

  @override
  void onInit() async {
    super.onInit();

    final params = Get.arguments;
    if (params != null) {
      channelId = params["channelId"] ?? "";
      userMessage.value = params["userMessage"] ?? UserMessage();
    }

    // 标记当前打开的会话：资质申请在本会话内时交给聊天卡片处理，不再弹全局框
    MsgService.to.activeChannelId = channelId;

    loadData();

    WKIM.shared.messageManager.addOnMsgInsertedListener(_onMsgInserted);
    WKIM.shared.messageManager.addOnNewMsgListener(
      "newMsgListener2",
      _onNewMsgListener,
    );

    scrollController.addListener(_scrollListener);

    // 监听键盘弹出/收起，弹出时把最新消息顶上来，避免被输入框/键盘遮挡
    WidgetsBinding.instance.addObserver(this);

    // 进入会话即清未读（覆盖非 toChatPage 入口的情况）
    _clearChannelUnread();
  }

  /// 系统窗口指标变化（含软键盘弹出/收起）
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final inset =
        WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    // 仅在键盘弹出（底部 inset 变大）时，把消息列表滚到底部展示最新消息。
    // 键盘动画有过程，maxScrollExtent 逐帧变化，故 postFrame + 延迟各滚一次兜底。
    if (inset > _lastBottomInset) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollToBottom(animate: false),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isClosed) scrollToBottom(animate: false);
      });
    }
    _lastBottomInset = inset;
  }

  /// 清除当前会话未读数（本地红点归零）
  void _clearChannelUnread() {
    if (channelId.isEmpty) return;
    WKIM.shared.conversationManager.updateRedDot(
      channelId,
      WKChannelType.personal,
      0,
    );
  }

  @override
  void onClose() {
    // 页面关闭时移除本页监听、释放控制器，避免重复插入与内存泄漏
    WKIM.shared.messageManager.removeNewMsgListener("newMsgListener2");
    WidgetsBinding.instance.removeObserver(this);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    inputController.dispose();
    refreshController.dispose();
    if (MsgService.to.activeChannelId == channelId) {
      MsgService.to.activeChannelId = null;
    }
    super.onClose();
  }

  /// 消息是否已在列表中（按 clientMsgNO / messageID 去重）
  bool _exists(WKMsg m) => messages.any(
        (e) =>
            (m.clientMsgNO.isNotEmpty && e.clientMsgNO == m.clientMsgNO) ||
            (m.messageID.isNotEmpty && e.messageID == m.messageID),
      );

  /// 只接收属于当前会话、且未重复的消息，插到列表头部（配合 reverse:true 显示在底部）
  void _prependMessages(List<WKMsg> list) {
    final incoming =
        list.where((m) => m.channelID == channelId && !_exists(m)).toList();
    if (incoming.isEmpty) return;

    // 记录资质信令状态（apply/agree/reject）
    _recordQualification(incoming);

    // 消息在聊天页已被看到，立即清未读，避免返回列表时残留红点
    _clearChannelUnread();

    // 只有申请卡片和普通消息进入可见列表；同意/拒绝仅用于更新状态，不单独成条
    final visible = incoming.where(_isVisibleMsg).toList();

    // 自己发的消息，或当前已在底部附近 → 直接滚到底；
    // 否则说明用户正在往上翻历史，不打断，弹出"新消息"提示。
    final hasSelf = incoming.any((m) => m.fromUID == UserService.to.profile.id);
    final nearBottom = _isNearBottom();

    if (visible.isNotEmpty) {
      messages.insertAll(0, visible);
    }

    if (visible.isEmpty) return;

    if (hasSelf || nearBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } else {
      showNewMsgTip.value = true;
    }
  }

  /// 是否为资质信令消息
  bool _isQualification(WKMsg m) => m.contentType == kQualificationContentType;

  /// 是否在消息列表可见：普通消息与"申请"卡片可见；同意/拒绝不单独显示
  bool _isVisibleMsg(WKMsg m) {
    if (!_isQualification(m)) return true;
    final c = m.messageContent;
    return c is QualificationContent && c.action == QualificationAction.apply;
  }

  /// 从消息里提取资质信令，更新 reqId -> 状态
  void _recordQualification(List<WKMsg> list) {
    var changed = false;
    for (final m in list) {
      if (!_isQualification(m)) continue;
      final c = m.messageContent;
      if (c is! QualificationContent || c.reqId.isEmpty) continue;
      if (c.action == QualificationAction.apply) {
        reqStatus.putIfAbsent(c.reqId, () => QualificationAction.apply);
      } else {
        reqStatus[c.reqId] = c.action; // agree / reject
      }
      changed = true;
    }
    if (changed) {
      reqStatus.refresh();
      _recomputePermission();
    }
  }

  /// 从所有信令推导整份报告权限状态。
  /// 优先级：已同意(终态，随时可看) > 待处理 > 已拒绝 > 未申请。
  void _recomputePermission() {
    var hasAgree = false, hasPending = false, hasReject = false;
    for (final st in reqStatus.values) {
      if (st == QualificationAction.agree) {
        hasAgree = true;
      } else if (st == QualificationAction.reject) {
        hasReject = true;
      } else {
        hasPending = true; // 'apply' = 待处理
      }
    }
    if (hasAgree) {
      permission.value = QualificationAction.agree;
    } else if (hasPending) {
      permission.value = 'pending';
    } else if (hasReject) {
      permission.value = QualificationAction.reject;
    } else {
      permission.value = '';
    }
  }

  /// 发起整份资质报告查看申请（只需申请一次）
  Future<void> applyReport() async {
    if (channelId.isEmpty) return;
    switch (permission.value) {
      case QualificationAction.agree:
        return; // 已同意，无需再申请
      case 'pending':
        Loading.toast('已发送申请，等待对方同意中');
        return;
      case QualificationAction.reject:
        Loading.toast('对方已拒绝');
        return;
    }
    final reqId =
        '${UserService.to.profile.id}_${DateTime.now().millisecondsSinceEpoch}';
    permission.value = 'pending';
    await MsgService.to.sendQualificationSignal(
      channelId: channelId,
      action: QualificationAction.apply,
      reqId: reqId,
      items: allItems,
    );
    Loading.toast('已发送申请，等待对方处理');
  }

  /// 响应资质申请（同意/拒绝），供聊天卡片按钮调用
  Future<void> respondQualification(
    WKMsg msg,
    QualificationContent content,
    bool agree,
  ) async {
    reqStatus[content.reqId] =
        agree ? QualificationAction.agree : QualificationAction.reject;
    reqStatus.refresh();
    await MsgService.to.respondQualification(msg, content, agree);
  }

  /// 拉取对方资质报告（同意后，申请方点击查看时调用）
  Future<SafeReportModel?> fetchPeerReport() async {
    // 说明：getSafeReport 已支持按任意 id 查询；能否查看应由后端根据授权校验。
    final response = await UserApi.getSafeReport(id: channelId);
    if (response.success) {
      return response.result;
    }
    Loading.error(response.message);
    return null;
  }

  /// 是否已滚动到底部附近（底部即最新消息，reverse 布局下为 maxScrollExtent）
  bool _isNearBottom() {
    if (!scrollController.hasClients) return true;
    final pos = scrollController.position;
    return pos.maxScrollExtent - pos.pixels <= 120;
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    // 用户手动滑回底部时，收起新消息提示
    if (_isNearBottom() && showNewMsgTip.value) {
      showNewMsgTip.value = false;
    }
  }

  /// 滚动到底部（最新消息），并收起新消息提示
  void scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;
    final target = scrollController.position.maxScrollExtent;
    if (animate) {
      scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(target);
    }
    showNewMsgTip.value = false;
  }

  /// 加载数据
  void loadData() async {
    Future.wait([
          // 只要有 channelId 就主动拉一次对方资料：
          // 传进来的 userMessage 只作即时占位，首次进入(还没聊过、频道信息未生成)
          // 时也能拿到头像/昵称，避免"第一次进聊天没头像、发条消息后才有"的问题。
          if (channelId.isNotEmpty) _getUserMessages(channelId),
      _getSafeReport(),
      _loadHistoryMessages(),
        ])
        .then((v) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isFirst) {
              scrollToBottom(animate: false);
              isFirst = false;
            }
          });
        })
        .onError((e, s) {
          logger.d("加载数据失败: $e");
        });
  }

  /// 获取历史消息
  Future<void> _loadHistoryMessages() async {
    await MsgService.to.getHistoryMessages(
      channelId,
      oldestOrderSeq: _oldestOrderSeq,
      // pullModel: 1,
      limit: 20,
      onComplete: (List<WKMsg> msg) {
        if (msg.isEmpty) return;
        _oldestOrderSeq = msg[0].orderSeq;

        _recordQualification(msg);
        messages.addAll(msg.where(_isVisibleMsg).toList().reversed);

        isComplete.value = true;

        if(msg.length < 20){
          refreshController.finishLoad(IndicatorResult.noMore);
        }else{
          refreshController.finishLoad();
        }
      },
    );
  }

  /// 获取安全报告
  Future<void> _getSafeReport() async {
    final response = await UserApi.getSafeReport(
      id: UserService.to.profile.id!,
    );
    if (response.success) {
      report.value = response.result ?? SafeReportModel();
      if (report.value.creditPic?.isEmpty == true) {}
    }
  }

  /// 获取用户消息并更新至频道信息
  Future<void> _getUserMessages(String channelId) async {
    final response = await UserApi.profile(id: channelId);
    // 拉到才覆盖，拉失败保留传进来的占位数据；同时回写 userMap 供会话列表复用
    if (response.success && response.result != null) {
      userMessage.value = response.result!;
      MsgService.to.userMap[channelId] = response.result!;
    }
  }

  /// 更多按钮点击事件
  void onMorePressed() {}

  /// 上传报告点击事件
  Future<void> onComplete() async {
    if (req.creditPic == null &&
        req.healthPic == null &&
        req.payTaxesPic == null) {
      Loading.error("请上传完整的报告图片");
      return;
    }

    final response = await UserApi.editReport(req);
    if (response.success) {
      Loading.success('提交成功');
    } else {
      Loading.error(response.message);
    }
  }

  /// 图片选择
  Future<void> pickImage(int id) async {
    String? imageUrl = await UploadService.to.pickImage();
    if (imageUrl != null) {
      switch (id) {
        case 1:
          // 恋爱四项
          req.healthPic = imageUrl;
          break;
        case 2:
          // 个人纳税
          req.payTaxesPic = imageUrl;
          break;
        case 3:
          // 个人信用
          req.creditPic = imageUrl;
          break;
      }

      logger.d("选择图片成功: $imageUrl");
      update(["chat"]);
    }
  }

  // 3.1 发送文本消息
  Future<void> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty) {
      return;
    }

    // 创建文本消息内容
    WKTextContent textContent = WKTextContent(text);

    // 创建频道对象（个人频道）
    String targetUID = channelId; // 目标用户ID
    if (targetUID.isEmpty) {
      logger.d('消息发送失败: 目标用户ID为空');
      return;
    }
    int channelType = WKChannelType.personal; // 频道类型：个人
    WKChannel channel = WKChannel(targetUID, channelType);

    // 发送后清空输入框
    inputController.clear();

    // 发送消息
    try {
      await WKIM.shared.messageManager.sendMessage(textContent, channel);
      logger.d('消息发送成功: $text');
    } catch (error) {
      logger.d('消息发送失败: $error');
    }
  }

  /// 消息插入数据库监听回调   ===> 发送方（自己发的消息）
  _onMsgInserted(WKMsg msg) {
    if (isClosed) return;
    _prependMessages([msg]);
  }

  /// 新消息监听回调  ====> 接收方（收到别人的消息）
  _onNewMsgListener(List<WKMsg> p1) {
    if (isClosed) return;
    _prependMessages(p1);
  }

  void onLoad() async {
    await Future.delayed(Duration(seconds: 1));
    _loadHistoryMessages();
  }
}