import 'package:get/get.dart';

class PostDetalController extends GetxController {
  PostDetalController();

  _initData() {
    update(["post_detal"]);
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
