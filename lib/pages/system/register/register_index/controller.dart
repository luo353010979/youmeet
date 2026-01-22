import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterIndexController extends GetxController {
  RegisterIndexController();

  final phoneController = TextEditingController();

  final codeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  _initData() {
    update(["register_index"]);
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
}
