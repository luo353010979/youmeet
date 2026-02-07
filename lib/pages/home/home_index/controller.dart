import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class HomeIndexController extends GetxController
    with GetTickerProviderStateMixin {
  HomeIndexController();

  int tabIndex = 0;
  final List<String> tabs = ["推荐", "同城", "新用户"];
  late TabController tabController;

  _initData() {
    update(["home_index"]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
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

  /// 打招呼
  toChatPage() {
    Get.toNamed(RouteNames.msgChat);
  }
}
