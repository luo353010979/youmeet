import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';

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
    List<String> keys = [];
    final token = UserService.to.token;
    String baseUrl = "http://t.pic.mooneyu.com/";

    await UploadService.to.requestQiniuToken();

    await for (final key in UploadService.uploadImagesStream(imagePaths, token)) {
      keys.add("$baseUrl$key");
    }

    Feed feed = Feed(content: content, pic: keys.join(","));

    final response = await UserApi.sendFeed(feed);
    if (response.success) {
      Loading.success("发布成功");
      Future.delayed(Duration(seconds: 1), () {
        Get.back();
      });
    } else {
      logger.d('发布动态失败: ${response.message}');
    }
  }

  /// 构建图片选择网格
  void setImagePaths(List<String> paths) {
    imagePaths = paths;
    logger.d(paths);
  }
}
