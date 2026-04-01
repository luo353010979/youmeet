import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:youmeet/common/index.dart';

class HomeIndexController extends GetxController
    with GetTickerProviderStateMixin {
  HomeIndexController();

  int tabIndex = 0;
  final List<String> tabs = [
    LocaleKeys.tab_1.tr,
    /*LocaleKeys.tab_2.tr,*/ LocaleKeys.tab_3.tr,
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

  List<UserMessage> matchList = [UserService.to.profile];
  PageController pageController = PageController();
  bool _isLoadingMatch = false;
  final int _matchPreloadThreshold = 1; // 距离末尾1项时触发（即倒数第2项开始预加载）
  int _lastPreloadTriggerListLength = -1;

  
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    pageController.addListener(() {
      final pageIndex = pageController.page?.round() ?? 0;
      if (matchList.isEmpty) return;

      final remaining = (matchList.length - 1) - pageIndex;
      final shouldPreload = remaining <= _matchPreloadThreshold;
      final isNewTrigger = _lastPreloadTriggerListLength != matchList.length;
      if (shouldPreload && isNewTrigger) {
        _lastPreloadTriggerListLength = matchList.length;
        getMatch();
      }
    });
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    getMatch();
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


  /// 单人匹配下一个
  void onNextOne() {
    if (!pageController.hasClients) return;

    final currentPage = pageController.page?.round() ?? 0;
    final hasNextPage = currentPage < matchList.length - 1;

    if (hasNextPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else{
      Loading.toast("没有下一页了");
    }
  }

  /// 获取推荐列表
  void getRecommendList(String path) async {
    final req = PostsReq(
      latitude: "104.04153466504094",
      longitude: "30.49953949825128",
    );
    final response = await HomeApi.getRecommendList(req, path: path);
    
    for (UserMessage item in response.result?.records ?? []) {
      WKChannel channel = WKChannel(item.id ?? "", WKChannelType.personal);
      channel.channelName = item.name ?? '';
      channel.avatar = item.portrait ?? '';
      //更新频道信息
      WKIM.shared.channelManager.addOrUpdateChannel(channel);
    }
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

  var count =0;
  void getMatch() async {
    if (_isLoadingMatch) return;
    _isLoadingMatch = true;

    final response = await HomeApi.getMatch();
    try {
      count++;
      if (response.success) {
        final userMessage = response.result;
        if (userMessage != null) {
          matchList.add(userMessage);
          update(["home_index"]);
        }
      }
    } finally {
      _isLoadingMatch = false;
      print("getMatch called $count times");
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
