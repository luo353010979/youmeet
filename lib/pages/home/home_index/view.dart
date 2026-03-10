import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/home/home_index/widgets/home_item.dart';
import 'package:youmeet/pages/home/home_index/widgets/home_slider.dart';
import 'package:youmeet/pages/home/home_index/widgets/tips.dart';

import 'index.dart';

class HomeIndexPage extends GetView<HomeIndexController> {
  const HomeIndexPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    final avatars = controller.recommendList
        .map((e) => e.portrait ?? '')
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    if (avatars.isEmpty &&
        (UserService.to.profile.portrait?.isNotEmpty ?? false)) {
      avatars.add(UserService.to.profile.portrait!);
    }

    return Column(
      children: [
        HomeSliderWidget(avatars: avatars),
        _buildTabBar(context),
        _buildPageView(),
      ],
    );
  }

  /// TabBar
  Widget _buildTabBar(BuildContext context) {
    return TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          // 左对齐
          dividerColor: Colors.transparent,
          // 隐藏底部分割线
          controller: controller.tabController,
          indicator: BoxDecoration(),
          labelPadding: EdgeInsets.only(right: 20.w),
          labelColor: context.colors.scheme.tertiary,
          unselectedLabelColor: Color(0xFF999999),
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            color: context.colors.scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          tabs: controller.tabs.map((tab) => Tab(text: tab)).toList(),
        )
        .tight(height: 25.h)
        .paddingLeft(16.w)
        .marginOnly(bottom: 10.h)
        .alignLeft();
  }

  /// 页面视图
  Widget _buildPageView() {
    return TabBarView(
      controller: controller.tabController,
      children: controller.tabs.asMap().entries.map((entry) {
        final index = entry.key;
        return KeepAliveWrapper(
          child: EasyRefresh(
            refreshOnStart: true,
            controller: controller.refreshController,
            onRefresh: () => controller.onRefresh(index),
            onLoad: () => controller.onLoadMore(index),
            child: _buildListView(index),
          ),
        );
      }).toList(),
    ).expanded();
  }

  /// 列表视图
  Widget _buildListView(int tabIndex) {
    final currentList = controller.listByTabIndex(tabIndex);
    const fixedHeaderCount = 2;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpace.page),
      itemCount: currentList.length + fixedHeaderCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return TipsWidget();
        } else if (index == 1) {
          return TextWidget.body(
            LocaleKeys.highlyTrustedMatch.tr,
            weight: FontWeight.bold,
          ).paddingBottom(10.h);
        } else {
          UserMessage user = currentList[index - fixedHeaderCount];
          return HomeItem(data: user);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeIndexController>(
      init: Get.find<HomeIndexController>(),
      id: "home_index",
      builder: (_) {
        return ScaffoldWidget(
          appBar: AppBarWidget(
            title: LocaleKeys.certification.tr,
            centerTitle: false,
          ),
          child: _buildView(context),
        );
      },
    );
  }
}
