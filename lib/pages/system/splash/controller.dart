import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class SplashController extends GetxController {
  SplashController();

  /// 跳转页面
  _jumpToPage() {
    // 延迟1秒
    Future.delayed(const Duration(seconds: 1)).then((_) {
      // // 是否已打开
      // if (ConfigService.to.isAlreadyOpen) {
      //   // 跳转首页
      //   Get.offAllNamed(RouteNames.systemMain);
      // } else {
      //   // 跳转欢迎页
      //   Get.offAllNamed(RouteNames.systemWelcome);
      // }

      Get.toNamed(RouteNames.systemLogin);
    });
  }

  @override
  void onInit() {
    super.onInit();

    // 设置系统样式
    AppTheme.setSystemStyle();
  }

  @override
  void onReady() {
    super.onReady();
    _jumpToPage();
  }
}
