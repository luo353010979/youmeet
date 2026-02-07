import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';

class MyIndexController extends GetxController {
  MyIndexController();

  late UserMessage userMessage;
  String userAvatar = AssetsImages.imgMsgAvaterPng;
  List<String> selectedImages = []; // 存储多张图片路径
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    userMessage = UserService.to.profile;
  }

  @override
  void onReady() {
    super.onReady();
  }

  void toProfileView() {
    Get.toNamed(RouteNames.myEditProfile);
    // print(userMessage.toJson());
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  // 选择单张图片
  void pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('选中图片: ${pickedFile.path}');
        userAvatar = pickedFile.path;
        update(["edit_profile"]);

        String qiNiuToken = await UploadService.to.getQiNiuToken();

        UploadService.to.upload(
          pickedFile.path,
          qiNiuToken,
          onProgress: (progress) {},
          onStatus: (state) {},
          onDone: (done) {
            print('上传完成: ${done.key}');
            "http://t.pic.mooneyu.com/${done.key}";
          },
        );
      }
    } catch (e) {
      print('选择图片失败: $e');
      Get.snackbar('错误', '选择图片失败，请检查权限设置');
    }
  }

  // 选择多张图片
  void pickMultipleImages({int? maxImages}) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
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
        update(["edit_profile"]);
      }
    } catch (e) {
      print('选择图片失败: $e');
      Get.snackbar('错误', '选择图片失败，请检查权限设置');
    }
  }
}
