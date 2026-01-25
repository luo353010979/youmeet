import 'package:get/get.dart';
import 'package:youmeet/pages/index.dart';

/// 主界面依赖
class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeIndexController>(() => HomeIndexController());
    Get.lazyPut<MsgIndexController>(() => MsgIndexController());
    Get.lazyPut<PostsIndexController>(() => PostsIndexController());
    Get.lazyPut<MyIndexController>(() => MyIndexController());
  }
}
