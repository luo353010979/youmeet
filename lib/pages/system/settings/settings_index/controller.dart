import 'package:get/get.dart';

class SettingsIndexController extends GetxController {
  SettingsIndexController();

  bool value1 = true;
  bool value2 = true;
  bool value3 = true;
  bool value4 = false;

  void onChanged1(bool newValue) {
    value1 = newValue;
    update(["settings_index"]);
  }

  void onChanged2(bool newValue) {
    value2 = newValue;
    update(["settings_index"]);
  }

  void onChanged3(bool newValue) {
    value3 = newValue;
    update(["settings_index"]);
  }

  void onChanged4(bool newValue) {
    value4 = newValue;
    update(["settings_index"]);
  }

  _initData() {
    update(["settings_index"]);
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
