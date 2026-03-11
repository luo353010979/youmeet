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
          expandedHeight: 385.w,
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
        _buildMatePreference(),
        _buildButton(),
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
              height: 385.w,
              fit: BoxFit.cover,
            );
          },
        ),
        // 指示器
        if (controller.bannerImages.length > 1)
          Positioned(
            bottom: 100.w,
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
          "http://${controller.user?.portrait}",
          width: 68.w,
          height: 68.w,
          radius: 50,
          fit: BoxFit.cover,
        ),
        titleSubtitleSpace: 12.w,
        title: <Widget>[
          TextWidget.body(controller.user?.name ?? "", weight: FontWeight.bold),

          TextWidget.label("● 在线", color: Color(0xFF92D21A), size: 10),

          IconWidget.svg(
                controller.user?.sex == 1
                    ? AssetsSvgs.icMyGenderBoySvg
                    : AssetsSvgs.icMyGirlSvg,
                text: "${controller.user?.age ?? ""}",
                size: 10.r,
                fontSize: 10,
                space: 2.w,
                fit: BoxFit.cover,
              )
              .alignCenter()
              .tight(width: 49.w, height: 18.w)
              .decorated(
                color: Color(
                  controller.user?.sex == 1 ? 0x2616C4FF : 0x26F2A3D6,
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Color(
                    controller.user?.sex == 1 ? 0x2616C4FF : 0x26F2A3D6,
                  ),
                ),
              ),
        ].toRowSpace(space: 12.w),
        subtitle: <Widget>[
          TextWidget.label("唱歌", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFFFE86D8),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("跳", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFF948DFF),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("rap", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFFFFC42E),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("篮球", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFF04C947),
                borderRadius: BorderRadius.circular(30),
              ),
        ].toWrap(spacing: 8.w),
      ),
    ).tight(height: 84.w).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
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
            spacing: 4.w,
            keyText: TextWidget.muted("身高", size: 10),
            valueText: TextWidget.label(
              "${controller.user?.weight ?? "- -"}",
              weight: FontWeight.bold,
            ),
          ),
          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("体重", size: 10),
            valueText: TextWidget.label(
              "${controller.user?.weight ?? "- -"}",
              weight: FontWeight.bold,
            ),
          ),
          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("学历", size: 10),
            valueText: TextWidget.label(
              controller.user?.education ?? "- -",
              weight: FontWeight.bold,
            ),
          ),
          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("职业", size: 10),
            valueText: TextWidget.label(
              controller.user?.job ?? "- -",
              weight: FontWeight.bold,
            ),
          ),

          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("收入", size: 10),
            valueText: TextWidget.label(
              "${controller.user?.income ?? "- -"}",
              weight: FontWeight.bold,
            ),
          ),

          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("家乡", size: 10),
            valueText: TextWidget.label("没有字段", weight: FontWeight.bold),
          ),
          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("购车", size: 10),
            valueText: TextWidget.label(
              parseBuy(controller.user?.buyCar),
              weight: FontWeight.bold,
            ),
          ),
          ColumTextWidget(
            spacing: 4.w,
            keyText: TextWidget.muted("购房", size: 10),
            valueText: TextWidget.label(
              parseBuy(controller.user?.buyHouse),
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
  }

  String parseBuy(int? buy) {
    if (buy == null) return "- -";
    switch (buy) {
      case 0:
        return "未购";
      case 1:
        return "已购";
      default:
        return "- -";
    }
  }

  /// 兴趣爱好
  Widget _buildHobbies() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: <Widget>[
        TextWidget.muted(
          "爱情誓言",
          weight: FontWeight.bold,
        ).paddingOnly(bottom: 8.w),

        TextWidget.label(
          "全世界都是你的影子(假数据没有字段)",
          weight: FontWeight.bold,
        ).paddingOnly(bottom: 12.w),

        TextWidget.muted(
          "兴趣爱好",
          weight: FontWeight.bold,
        ).paddingOnly(bottom: 8.w),

        <Widget>[
          TextWidget.label("唱歌", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFFFE86D8),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("跳", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFF948DFF),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("rap", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFFFFC42E),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("篮球", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFF04C947),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("唱歌", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFFFE86D8),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("跳", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFF948DFF),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("rap", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFFFFC42E),
                borderRadius: BorderRadius.circular(30),
              ),
          TextWidget.label("篮球", size: 12, color: Colors.white)
              .center()
              .tight(width: 40.w, height: 20.w)
              .decorated(
                color: Color(0xFF04C947),
                borderRadius: BorderRadius.circular(30),
              ),
        ].toWrap(spacing: 8.w, runSpacing: 8.w),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(16.w),
    ).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
  }

  /// 择偶意向
  Widget _buildMatePreference() {
    final matePreferences = controller.user?.friendNeedType?.split(",") ?? [];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: <Widget>[
        TextWidget.muted(
          "择偶意向",
          weight: FontWeight.bold,
        ).paddingOnly(bottom: 8.w),

        matePreferences.isEmpty
            ? TextWidget.label(
                "- -",
                weight: FontWeight.bold,
              ).paddingOnly(bottom: 12.w)
            : matePreferences
                  .map(
                    (e) => TextWidget.label(e, size: 12, color: Colors.white)
                        .padding(horizontal: 12.w, vertical: 4.w)
                        .decorated(
                          color: Color(0xFF948DFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                  )
                  .toList()
                  .toWrap(spacing: 8.w, runSpacing: 8.w)
                  .paddingOnly(bottom: 12.w),

        TextWidget.muted(
          "情感史",
          weight: FontWeight.bold,
        ).paddingOnly(bottom: 8.w),

        TextWidget.label(
          "${controller.user?.emotionalExperience ?? "- -"}",
          weight: FontWeight.bold,
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(16.w),
    ).sliverToBoxAdapter().sliverPaddingHorizontal(16.w);
  }

  Widget _buildButton() {
    return ButtonWidget.primary(
      "打招呼",
      icon: IconWidget.svg(AssetsSvgs.icChatSvg, size: 16.w),
      reverse: true,
      backgroundColor: Color(0xFFFF64C8),
      borderRadius: 50,
      elevation: 0,
      onTap: () {},
    ).sliverToBoxAdapter().sliverPadding(
      top: 12.w,
      bottom: 30.w,
      horizontal: 16.w,
    );
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
