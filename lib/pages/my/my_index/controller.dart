import 'package:get/get.dart';

class MyIndexController extends GetxController {
  MyIndexController();

  _initData() {
    update(["my_index"]);
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

  void toProfileView() {
    // Get.toNamed("");
    print("跳转到个人资料页面");
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
