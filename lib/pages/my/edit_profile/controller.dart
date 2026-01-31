import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/values/index.dart';

class EditProfileController extends GetxController {
  EditProfileController();

  String userAvatar = AssetsImages.imgMsgAvaterPng;
  List<String> selectedImages = []; // 存储多张图片路径
  final ImagePicker _picker = ImagePicker();

  _initData() {
    update(["edit_profile"]);
  }

  // 选择单张图片
  void pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('选中图片: ${pickedFile.path}');
        userAvatar = pickedFile.path;
        update(["edit_profile"]);
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
