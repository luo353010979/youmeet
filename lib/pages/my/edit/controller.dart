import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditController extends GetxController {
  EditController();

  final nicknameController = TextEditingController();

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  onConfirm() {
    // 获取输入的昵称
    String nickname = nicknameController.text.trim();
    Get.back(result: nickname);
  }
}
