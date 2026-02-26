import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class MatchingDetailController extends GetxController
    with GetTickerProviderStateMixin {
  MatchingDetailController();

  final ScrollController scrollController = ScrollController();

  late TabController tabBarController = TabController(length: 3, vsync: this);

  double _scrollPosition = 0.0;
  final double expandedHeight = 385; // 展开高度阈值，需要与View中的385.h对应
  final double collapsedHeight = kToolbarHeight; // AppBar收起后的高度（56）

  // 轮播图相关
  final PageController pageController = PageController();
  int currentIndex = 0;

  // 图片列表
  List<String> bannerImages = [AssetsImages.imgHomeBgMatchingJpg];

  UserMessage? user;

  // 判断AppBar是否展开
  bool get isAppBarExpanded {
    // 当滚动位置小于 (展开高度 - 收起高度) 时，认为是展开状态
    // 即：当图片区域还有部分可见时为展开状态
    return _scrollPosition < (expandedHeight - collapsedHeight);
  }

  // 更新轮播图索引
  void updateBannerIndex(int index) {
    currentIndex = index;
    update(["matching_appbar"]);
  }

  @override
  void onInit() {
    super.onInit();
    user = Get.arguments;
    if (user?.pic?.isNotEmpty == true) {
      bannerImages = user?.pic?.split(",") ?? [];
    }

    scrollController.addListener(() {
      // 监听滚动事件
      final oldPosition = _scrollPosition;
      _scrollPosition = scrollController.position.pixels;

      // 判断状态是否改变，改变时打印日志并更新UI
      final threshold = expandedHeight - collapsedHeight;
      final wasExpanded = oldPosition < threshold;
      final isNowExpanded = _scrollPosition < threshold;

      if (wasExpanded != isNowExpanded) {
        print(
          'AppBar状态改变: ${isNowExpanded ? "展开" : "收起"}, 滚动位置: $_scrollPosition, 阈值: $threshold',
        );
        update(["matching_appbar"]); // 更新UI
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
