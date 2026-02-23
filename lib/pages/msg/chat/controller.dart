import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class TypeModel {
  final String title;
  final String icon;

  TypeModel({required this.title, required this.icon});
}

class ChatController extends GetxController {
  ChatController();

  final msgController = TextEditingController();

  final idController = TextEditingController(text: "774138775482798080");

  List<TypeModel> types = [
    TypeModel(
      title: LocaleKeys.loveFourTitle1.tr,
      icon: AssetsSvgs.icMsg_01Svg,
    ),
    TypeModel(
      title: LocaleKeys.loveFourTitle2.tr,
      icon: AssetsSvgs.icMsg_02Svg,
    ),
    TypeModel(
      title: LocaleKeys.loveFourTitle3.tr,
      icon: AssetsSvgs.icMsg_03Svg,
    ),
  ];

  final List<String> messages = [
    "Hello!",
    "How are you?",
    "What's up?",
    "Let's meet up.",
    "See you later!",
  ];

  _initData() {
    update(["chat"]);
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  /// 更多按钮点击事件
  void onMorePressed() {}

  onComplete() {}

  // 3.1 发送文本消息
  Future<void> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty) {
      return;
    }

    // 创建文本消息内容
    WKTextContent textContent = WKTextContent(text);

    // 创建频道对象（个人频道）
    String targetUID = idController.text.trim(); // 目标用户ID
    if (targetUID.isEmpty) {
      print('消息发送失败: 目标用户ID为空');
      return;
    }
    int channelType = WKChannelType.personal; // 频道类型：个人
    WKChannel channel = WKChannel(targetUID, channelType);

    // 发送消息
    try {
      await WKIM.shared.messageManager.sendMessage(textContent, channel);
      print('消息已提交发送: $text');
      msgController.clear();
    } catch (error) {
      print('消息发送失败: $error');
    }
  }
}
