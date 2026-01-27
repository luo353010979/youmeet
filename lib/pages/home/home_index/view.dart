import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:youmeet/common/index.dart';

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
        "安全交友",
        size: 16,
        weight: FontWeight.w900,
      ).positioned(left: 16.w, top: 24.h),

      TextWidget.label(
        "真实可靠",
        size: 26,
        weight: FontWeight.bold,
      ).positioned(left: 16.w, top: 52.h),

      TextWidget.label(
        "张思雨",
        size: 18,
        weight: FontWeight.w900,
      ).positioned(left: 245.w, top: 52.h),

      TextWidget.muted("下一页").positioned(left: 20.w, top: 107.h),

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
        "立即查看",
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

  /// 审核提示
  Widget _buildTips(BuildContext context) {
    return <Widget>[
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Color(0xFFF5F5F5),
          ).paddingHorizontal(14.w),

          <Widget>[
            TextWidget.label("您安全资质已核验 2 项", size: 16, weight: FontWeight.bold),

            <Widget>[
              ButtonWidget.primary(
                "发起核验申请",
                width: 92.w,
                height: 25.h,
                fontSize: 12,
                textWeight: FontWeight.bold,
                onTap: () {},
              ),
              ButtonWidget.outline(
                "完善我的资质",
                width: 92.w,
                height: 25.h,
                fontSize: 12,
                borderColor: context.colors.scheme.primary,
                textWeight: FontWeight.bold,
                backgroundColor: Color(0x33FF64C8),
                onTap: () {},
              ),
            ].toRowSpace(space: 8.w),
          ].toColumnSpace(
            space: 8.h,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ]
        .toRow()
        .tight(width: 343.w, height: 95.h)
        .decorated(
          image: DecorationImage(
            image: AssetImage(AssetsImages.imgHomeTipsPng),
            fit: BoxFit.fill,
          ),
        )
        .marginOnly(bottom: 10.h);
  }

  /// 页面视图
  Widget _buildPageView() {
    return TabBarView(
      controller: controller.tabController,
      physics: NeverScrollableScrollPhysics(),
      children: controller.tabs.map((tab) {
        return _buildListView();
      }).toList(),
    ).expanded();
  }

  /// 列表视图
  Widget _buildListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: AppSpace.page),
      itemCount: 10,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTips(context);
        } else if (index == 1) {
          return TextWidget.body(
            "高度信任匹配",
            weight: FontWeight.bold,
          ).paddingBottom(10.h);
        } else {
          return _itemCard();
        }
      },
      // separatorBuilder: (context, index) {
      //   return SizedBox(height: 2.h);
      // },
    );
  }

  /// 列表项卡片
  Widget _itemCard() {
    return Container(
      width: 343.w,
      height: 134.h,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsImages.imgHomeCardPng),
          fit: BoxFit.cover,
        ),
      ),
      child: <Widget>[
        Container(
          width: 90.w,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.white, width: 2.w),
            color: Color(0xFFF5F5F5),
          ),
        ).paddingLeft(12.w),

        <Widget>[
              <Widget>[
                TextWidget.body("昵称", weight: FontWeight.bold),
                IconWidget.svg(
                      AssetsSvgs.icWomanSvg,
                      text: "22",
                      fontColor: Colors.white,
                      size: 10.r,
                      fontSize: 10,
                      space: 2.w,
                    )
                    .alignCenter()
                    .tight(width: 35.w, height: 15.h)
                    .decorated(
                      color: Get.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
              ].toRowSpace(space: 6.w),

              <Widget>[
                TextWidget.muted("离异/2孩", weight: FontWeight.bold),
                SizedBox(
                  height: 8.h,
                  child: VerticalDivider(color: Color(0xFFCCCCCC), width: 1.w),
                ),
                TextWidget.muted("165cm/50kg", weight: FontWeight.bold),
                SizedBox(
                  height: 8.h,
                  child: VerticalDivider(color: Color(0xFFCCCCCC), width: 1.w),
                ),
                TextWidget.muted("美国", weight: FontWeight.bold),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

              <Widget>[
                _buildChip("实名"),
                _buildChip("健康"),
                _buildChip("纳税"),
                _buildChip("信用"),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

              <Widget>[
                ButtonWidget.outline(
                  "申请查看报告",
                  width: 86.w,
                  height: 23.h,
                  fontSize: 11,
                  textWeight: FontWeight.bold,
                  borderColor: Get.theme.colorScheme.primary,
                  backgroundColor: Color(0x33FF64C8),
                  onTap: () {},
                ),
                ButtonWidget.primary(
                  "打招呼",
                  width: 53.w,
                  height: 23.h,
                  fontSize: 11,
                  onTap: controller.toChat,
                  textWeight: FontWeight.bold,
                  backgroundColor: Color(0xFFFF64C8),
                ),
              ].toRowSpace(space: 8.w),
            ]
            .toColumnSpace(mainAxisAlignment: MainAxisAlignment.center)
            .paddingSymmetric(horizontal: 16.w)
            .expanded(),
      ].toRow(),
    );
  }

  Widget _buildChip(String text) {
    return IconWidget.svg(
          AssetsSvgs.icPassSvg,
          text: text,
          fontColor: Color(0xFF999999),
          size: 14.r,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          space: 2.w,
        )
        .alignCenter()
        .tight(width: 44.w, height: 18.h)
        .decorated(
          color: Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(2),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeIndexController>(
      init: Get.find<HomeIndexController>(),
      id: "home_index",
      builder: (_) {
        return ScaffoldWidget(
          appBar: AppBarWidget(title: "附近认证", centerTitle: false),
          child: _buildView(context),
        );
      },
    );
  }
}
