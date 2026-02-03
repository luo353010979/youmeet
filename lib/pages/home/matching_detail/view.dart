import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class MatchingDetailPage extends GetView<MatchingDetailController> {
  const MatchingDetailPage({super.key});

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      slivers: [
        // 沉浸式头部图片
        SliverAppBar(
          expandedHeight: 385.h,
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: GetBuilder<MatchingDetailController>(
            id: "matching_appbar",
            builder: (_) {
              return TextWidget.body(
                "匹配详情",
                weight: FontWeight.bold,
                color: controller.isAppBarExpanded
                    ? Colors.transparent
                    : Colors.black,
              );
            },
          ),
          leading: GetBuilder<MatchingDetailController>(
            id: "matching_appbar",
            builder: (_) {
              return IconButton(
                icon: IconWidget.svg(
                  AssetsSvgs.icAppbarBackSvg,
                  color: controller.isAppBarExpanded
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => Get.back(),
              );
            },
          ),
          flexibleSpace: FlexibleSpaceBar(background: _buildBannerCarousel()),
        ),

        // 其他内容
        _buildAvatar(),
        _buildBasicInfo(),
        _buildHobbies(),
      ],
    );
  }

  // 轮播图
  Widget _buildBannerCarousel() {
    return Stack(
      children: [
        // 轮播图
        PageView.builder(
          controller: controller.pageController,
          itemCount: controller.bannerImages.length,
          onPageChanged: (index) {
            controller.updateBannerIndex(index);
          },
          itemBuilder: (context, index) {
            return ImageWidget.img(
              controller.bannerImages[index],
              width: double.infinity,
              height: 385.h,
              fit: BoxFit.cover,
            );
          },
        ),
        // 指示器
        Positioned(
          bottom: 100.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.bannerImages.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: controller.currentIndex == index ? 20.w : 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: controller.currentIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 头像及信息
  Widget _buildAvatar() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ListTileWidget(
        leading: ImageWidget.img(
          AssetsImages.imgMsgAvaterPng,
          width: 68.w,
          height: 68.w,
          fit: BoxFit.contain,
        ),
        titleSubtitleSpace: 12.h,
        title: <Widget>[
          TextWidget.body("星星点灯", weight: FontWeight.bold),

          TextWidget.label("● 在线", color: Color(0xFF92D21A), size: 10),

          IconWidget.svg(
                AssetsSvgs.icMyGirlSvg,
                text: "22岁",
                size: 10.r,
                fontSize: 10,
                space: 2.w,
                fit: BoxFit.cover,
              )
              .alignCenter()
              .tight(width: 49.w, height: 18.h)
              .decorated(
                color: Color(0x26F2A3D6),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Color(0xFFFFA2DE)),
              ),
        ].toRowSpace(space: 12.w),
        subtitle: <Widget>[
          TextWidget.label("唱歌", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFFFE86D8),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("跳", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFF948DFF),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("rap", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFFFFC42E),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("篮球", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFF04C947),
                borderRadius: BorderRadius.circular(30),
              ),
        ].toWrap(spacing: 8.w),
      ),
    ).tight(height: 84.h).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
  }

  /// 基本信息
  Widget _buildBasicInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 82 / 53,
        padding: EdgeInsets.all(16.w),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("身高", size: 10),
            valueText: TextWidget.label("165cm", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("体重", size: 10),
            valueText: TextWidget.label("50kg", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("年龄", size: 10),
            valueText: TextWidget.label("22岁", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("职业", size: 10),
            valueText: TextWidget.label("软件工程师", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("学历", size: 10),
            valueText: TextWidget.label("本科", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("收入", size: 10),
            valueText: TextWidget.label("10万-20万", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("婚姻状况", size: 10),
            valueText: TextWidget.label("未婚", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.h,
            keyText: TextWidget.muted("有无子女", size: 10),
            valueText: TextWidget.label("无", weight: FontWeight.bold),
          ),
        ],
      ),
    ).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
  }

  /// 兴趣爱好
  Widget _buildHobbies() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: <Widget>[
        <Widget>[
          TextWidget.label("唱歌", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFFFE86D8),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("跳", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFF948DFF),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("rap", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFFFFC42E),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("篮球", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.h)
              .decorated(
                color: Color(0xFF04C947),
                borderRadius: BorderRadius.circular(30),
              ),
        ].toWrap(spacing: 8.w),
      ].toColumn(),
    ).tight(height: 500.h).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchingDetailController>(
      init: MatchingDetailController(),
      id: "matching_detail",
      builder: (_) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent, // 状态栏透明
            statusBarIconBrightness: Brightness.light, // 状态栏图标为白色
          ),
          child: Scaffold(
            backgroundColor: Color(0xFFEEF1F6),
            extendBodyBehindAppBar: true, // 让内容延伸到状态栏
            body: _buildView(),
          ),
        );
      },
    );
  }
}
