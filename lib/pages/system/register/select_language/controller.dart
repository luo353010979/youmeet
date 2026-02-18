import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class SelectLanguageController extends GetxController {
  SelectLanguageController();

  final languages = ["中文", "English"];

  _initData() {
    update(["select_language"]);
  }

  void onTap(String language) {
    var en = Translation.supportedLocales[0];
    var zh = Translation.supportedLocales[1];

    ConfigService.to.setLanguage(
      ConfigService.to.locale.toLanguageTag() == en.toLanguageTag() ? zh : en,
    );

    Get.back(result: language);
  }

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
