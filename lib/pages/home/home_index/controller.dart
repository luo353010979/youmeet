import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class HomeIndexController extends GetxController
    with GetTickerProviderStateMixin {
  HomeIndexController();

  int tabIndex = 0;
  final List<String> tabs = [
    LocaleKeys.tab_1.tr,
    LocaleKeys.tab_2.tr,
    LocaleKeys.tab_3.tr,
  ];
  late TabController tabController;
  final refreshController = EasyRefreshController(
    // controlFinishRefresh: true,
    // controlFinishLoad: true,
  );

  List<UserMessage> recommendList = [];
  List<UserMessage> nearByList = [];
  List<UserMessage> newList = [];

  List<UserMessage> listByTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return recommendList;
      case 1:
        return nearByList;
      case 2:
        return newList;
      default:
        return recommendList;
    }
  }

  _initData() {
    update(["home_index"]);
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
    tabController.dispose();
  }

  /// 打招呼
  toChatPage() {
    Get.toNamed(RouteNames.msgChat);
  }

  /// 获取推荐列表
  void getRecommendList(String path) async {
    final req = PostsReq(
      latitude: "104.04153466504094",
      longitude: "30.49953949825128",
    );
    final response = await HomeApi.getRecommendList(req, path: path);
    if (response.success) {
      switch (path) {
        case "recommendList":
          recommendList = response.result?.records ?? [];
          break;
        case "nearByList":
          nearByList = response.result?.records ?? [];
          break;
        case "newList":
          newList = response.result?.records ?? [];
          break;
        default:
      }
      update(["home_index"]);
    } else {
      // 处理错误
    }
  }

  String _pathByTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return "recommendList";
      case 1:
        return "nearByList";
      case 2:
        return "newList";
      default:
        return "recommendList";
    }
  }

  void onRefresh([int? index]) async {
    final currentIndex = index ?? tabController.index;
    final path = _pathByTabIndex(currentIndex);
    getRecommendList(path);
  }

  void onLoadMore([int? index]) async {
    final currentIndex = index ?? tabController.index;
    final path = _pathByTabIndex(currentIndex);
    getRecommendList(path);
  }
}
