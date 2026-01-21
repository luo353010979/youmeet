import 'package:get/get.dart';

class PostsIndexController extends GetxController {
  PostsIndexController();

  _initData() {
    update(["posts_index"]);
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
