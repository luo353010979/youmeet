import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/home/home_index/widgets/home_item.dart';
import 'package:youmeet/pages/home/home_index/widgets/tips.dart';

import 'index.dart';

class HomeIndexPage extends GetView<HomeIndexController> {
  const HomeIndexPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return Column(
      children: [_buildSlider(), _buildTabBar(context), _buildPageView()],
    );
  }

  /// 顶部推荐滑动栏
  Widget _buildSlider() {
    return <Widget>[
      TextWidget.label(
        LocaleKeys.safeDating.tr,
        size: 16,
        weight: FontWeight.w900,
      ).positioned(left: 16.w, top: 24.h),

      TextWidget.label(
        LocaleKeys.reliable.tr,
        size: 26,
        weight: FontWeight.bold,
      ).positioned(left: 16.w, top: 52.h),

      TextWidget.label(
        "张思雨",
        size: 18,
        weight: FontWeight.w900,
      ).positioned(left: 245.w, top: 52.h),

      TextWidget.muted(
        LocaleKeys.commonNext.tr,
      ).positioned(left: 20.w, top: 107.h),

      ImageWidget.img(
        AssetsImages.imgHomeAvaterPng,
        width: 264.w,
        height: 148.h,
        fit: BoxFit.contain,
      ).positioned(right: 17.w, bottom: 12.h),
      ImageWidget.img(
        AssetsImages.imgHomeYoumeetPng,
        width: 111.w,
        height: 24.h,
        fit: BoxFit.contain,
      ).positioned(top: 76.h, left: 246.w),

      TextWidget.label(
        LocaleKeys.viewNow.tr,
        color: Color(0xFFDA597F),
        weight: FontWeight.w900,
      ).positioned(left: 247.w, top: 108.5.h),
    ].toStack().tight(height: 164.h);
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
