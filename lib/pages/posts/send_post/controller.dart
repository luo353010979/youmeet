import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';

class SendPostController extends GetxController {
  SendPostController();

  final contentController = TextEditingController();
  final contentFocusNode = FocusNode();

  List<String> selectedImages = []; // 存储多张图片路径
  final ImagePicker _picker = ImagePicker();

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

  void pickMultipleImages({int? maxImages}) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        limit: 3,
        // maxWidth: 1920,
        // maxHeight: 1920,
        // imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        // 如果设置了最大数量限制
        if (maxImages != null && pickedFiles.length > maxImages) {
          selectedImages = pickedFiles
              .take(maxImages)
              .map((e) => e.path)
              .toList();
          Get.snackbar('提示', '最多只能选择 $maxImages 张图片');
        } else {
          selectedImages = pickedFiles.map((e) => e.path).toList();
        }

        print('选中 ${selectedImages.length} 张图片');
        print(selectedImages.toString());
        update(["send_feed"]);
      }
    } catch (e) {
      print('选择图片失败: $e');
      Get.snackbar('错误', '选择图片失败，请检查权限设置');
    }
  }

  /// 并发上传所有图片，通过 Stream 实时返回每个上传完成的 key
  Stream<String> uploadImagesStream(List<String> imagePaths, String token) {
    final streamController = StreamController<String>();
    int finished = 0;
    for (final img in imagePaths) {
      UploadService.to.upload(
        img,
        onProgress: (progress) {},
        onStatus: (state) {
          print('上传状态: $state');
        },
        onDone: (done) {
          streamController.add(done.key ?? "");
          print('上传完成: ${done.key}');
          finished++;
          if (finished == imagePaths.length) {
            streamController.close();
          }
        },
      );
    }
    return streamController.stream;
  }

  void sendFeed() async {
    String content = contentController.text;
    List<String> keys = [];
    final token = UserService.to.token;
    String baseUrl = "http://t.pic.mooneyu.com/";

    await for (final key in uploadImagesStream(selectedImages, token)) {
      keys.add("$baseUrl$key");
    }

    Record feed = Record(content: content, pic: keys.join(","));

    await UserApi.sendFeed(feed);
  }
}
