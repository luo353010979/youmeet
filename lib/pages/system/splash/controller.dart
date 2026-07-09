import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class SplashController extends GetxController {
  SplashController();

  /// 跳转页面
  _jumpToPage() {
    // 延迟1秒
    Future.delayed(const Duration(seconds: 2)).then((_) {
      // 引导页暂时移除，直接按登录态跳转；后续需要时恢复 isAlreadyOpen 判断跳欢迎页
      if (UserService.to.hasToken) {
        Get.offAllNamed(RouteNames.systemMain);
      } else {
        Get.offAllNamed(RouteNames.systemLogin);
      }
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
