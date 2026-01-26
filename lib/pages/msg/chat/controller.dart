import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class TypeModel {
  final String title;
  final String icon;

  TypeModel({required this.title, required this.icon});
}

class ChatController extends GetxController {
  ChatController();

  List<TypeModel> types = [
    TypeModel(title: "恋爱四项", icon: AssetsSvgs.icMsg_01Svg),
    TypeModel(title: "个人纳税", icon: AssetsSvgs.icMsg_02Svg),
    TypeModel(title: "个人信用", icon: AssetsSvgs.icMsg_03Svg),
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

  onComplete() {
  }
}
