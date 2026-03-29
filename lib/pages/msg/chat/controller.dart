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

class ChatController extends GetxController {
  ChatController();

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

  // 历史消息分页参数
  int _oldestOrderSeq = 0;

  final isComplete = false.obs;

  bool isFirst = true;

  final ScrollController scrollController = ScrollController();

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

    loadData();

    WKIM.shared.messageManager.addOnMsgInsertedListener(_onMsgInserted);
    WKIM.shared.messageManager.addOnNewMsgListener(
      "newMsgListener2",
      _onNewMsgListener,
    );

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels == 0) {
      _loadHistoryMessages();
    }
  }

  void _scrollToBottom() {
    // 判断是否可以滚动
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  /// 加载数据
  void loadData() async {
    Future.wait([
          if (userMessage.value.id?.isEmpty == true)
            _getUserMessages(channelId),
      _getSafeReport(),
      _loadHistoryMessages(),
        ])
        .then((v) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isFirst) {
              _scrollToBottom();
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

        messages.addAll(msg.reversed);

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
    if (response.success) {
      userMessage.value = response.result ?? UserMessage();
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

    // 发送消息
    try {
      await WKIM.shared.messageManager.sendMessage(textContent, channel);
      logger.d('消息发送成功: $text');
    } catch (error) {
      logger.d('消息发送失败: $error');
    }
  }

  /// 消息插入数据库监听回调   ===> 发送方
  _onMsgInserted(WKMsg msg) {
    logger.d(
      '_onMsgInserted   消息插入数据库: ${msg.content}, 消息ID: ${msg.messageID}',
    );

    messages.insert(0, msg);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // 此时可以刷新聊天列表 UI
  }

  /// 新消息监听回调  ====> 接收方
  _onNewMsgListener(List<WKMsg> p1) {
    logger.d(
      '_onNewMsgListener   收到新消息: ${p1.map((msg) => msg.content).join(", ")}',
    );
    messages.insertAll(0, p1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void getChannelInfo(String id) async {
    try {
      final data = await WKIM.shared.conversationManager.getWithChannel(
        channelId,
        WKChannelType.personal,
      );
      final channel = await data?.getWkChannel();
    } catch (e) {
      logger.d('获取会话列表失败: $e');
  }
}

  void onLoad() async{
    await Future.delayed(Duration(seconds: 1));
    _loadHistoryMessages();
  }
}