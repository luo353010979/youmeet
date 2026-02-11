import 'package:get/get.dart';

class EditProfileController extends GetxController {
  EditProfileController();

  _initData() {
    update(["edit_profile"]);
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
