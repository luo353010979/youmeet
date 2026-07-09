import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';
import 'package:youmeet/pages/my/my_index/index.dart';

class SendPostController extends GetxController {
  SendPostController();

  final contentController = TextEditingController();
  final contentFocusNode = FocusNode();

  List<String> imagePaths = []; // 存储多张图片路径

  _initData() {
    update(["send_feed"]);
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

  @override
  void onClose() {
    super.onClose();
    contentController.dispose();
    contentFocusNode.dispose();
  }

  /// 发布动态
  void sendFeed() async {
    String content = contentController.text;

    if (content.trim().isEmpty && imagePaths.isEmpty) {
      Loading.error("请输入内容或选择图片");
      return;
    }

    List<String> keys = [];
    final token = UserService.to.token;
    String baseUrl = "http://t.pic.mooneyu.com/";

    try {
      Loading.show();

      await UploadService.to.requestQiniuToken();

      await for (final key in UploadService.uploadImagesStream(
        imagePaths,
        token,
      )) {
        keys.add("$baseUrl$key");
      }

      Feed feed = Feed(content: content, pic: keys.join(","));

      final response = await UserApi.sendFeed(feed);
      if (response.success) {
        Loading.success("发布成功");
        // 通知"我的"页面刷新动态列表
        if (Get.isRegistered<MyIndexController>()) {
          Get.find<MyIndexController>().fetchMyFeedList();
        }
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
        });
      } else {
        logger.d('发布动态失败: ${response.message}');
        Loading.error("发布失败，请重试");
      }
    } catch (e) {
      logger.d('发布动态异常: $e');
      Loading.error("发布失败，请重试");
    }
  }

  /// 构建图片选择网格
  void setImagePaths(List<String> paths) {
    imagePaths = paths;
    logger.d(paths);
  }
}
