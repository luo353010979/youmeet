import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

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
    Get.toNamed(RouteNames.myEditProfile);
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
