import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class WelcomeController extends GetxController {
  WelcomeController();

  /// 当前位置
  int currentIndex = 0;

  /// 欢迎数据
  List<WelcomeModel>? items;

  /// 是否显示 Start
  bool isShowStart = false;

  /// slider 控制器
  CarouselSliderController carouselController = CarouselSliderController();

  /// 初始化数据
  _initData() {
    items = [
      WelcomeModel(
        image: AssetsImages.welcome_1Png,
        title: LocaleKeys.welcomeOneTitle.tr,
        desc: LocaleKeys.welcomeOneDesc.tr,
      ),
      WelcomeModel(
        image: AssetsImages.welcome_2Png,
        title: LocaleKeys.welcomeTwoTitle.tr,
        desc: LocaleKeys.welcomeTwoDesc.tr,
      ),
      WelcomeModel(
        image: AssetsImages.welcome_3Png,
        title: LocaleKeys.welcomeThreeTitle.tr,
        desc: LocaleKeys.welcomeThreeDesc.tr,
      ),
    ];

    update(["slider", 'bar']);
  }

  /// 当前位置发生改变
  void onPageChanged(int index) {
    currentIndex = index;
    isShowStart = currentIndex == 2;
    update(['slider', 'bar']);
  }

  /// 去首页
  void onToMain() {
    /// 跳转首页, 并关闭所有页面
    if (UserService.to.hasToken) {
      Get.offAllNamed(RouteNames.systemMain);
    } else {
      Get.offAllNamed(RouteNames.systemLogin);
    }
  }

  /// 下一个
  void onNext() {
    carouselController.nextPage();
  }

  @override
  void onReady() {
    super.onReady();
    // 设置已打开
    ConfigService().setAlreadyOpen();
    _initData();
  }
}
