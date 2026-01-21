import 'package:get/get.dart';

class PrivacyAgreementController extends GetxController {
  PrivacyAgreementController();

  _initData() {
    update(["privacy_agreement"]);
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
