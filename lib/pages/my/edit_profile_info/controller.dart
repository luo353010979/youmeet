import 'package:get/get.dart';

class EditProfileInfoController extends GetxController {
  EditProfileInfoController();

  _initData() {
    update(["edit_profile_info"]);
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
