import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
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

  final msgController = TextEditingController();

  final idController = TextEditingController(text: "774138775482798080");

  // 安全报告数据
  SafeReportModel? report;

  // 编辑报告请求参数
  EditReportReq req = EditReportReq(id: UserService.to.profile.id!);

  String? get displayRealPic {
    if (req.healthPic?.isNotEmpty == true) {
      return req.healthPic;
    }
    return report?.healthPic;
  }

  String? get displayPayTaxesPic {
    if (req.payTaxesPic?.isNotEmpty == true) {
      return req.payTaxesPic;
    }
    return report?.payTaxesPic;
  }

  String? get displayCreditPic {
    if (req.creditPic?.isNotEmpty == true) {
      return req.creditPic;
    }
    return report?.creditPic;
  }

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

  final List<String> messages = [
    "Hello!",
    "How are you?",
    "What's up?",
    "Let's meet up.",
    "See you later!",
  ];

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    getSafeReport();
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

      print("选择图片成功: $imageUrl");
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

  /// 获取安全报告
  Future<void> getSafeReport() async {
    if (idController.text.trim().isEmpty) {
      Loading.error("请输入报告 ID");
      return;
    }

    final response = await UserApi.getSafeReport(
      id: UserService.to.profile.id!,
    );

    if (response.success) {
      report = response.result;
      update(["chat"]);
    }
  }
}
