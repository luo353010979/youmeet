import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class PostsIndexPage extends GetView<PostsIndexController> {
  const PostsIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        _buildPostCard(),
        Container(
          height: 2.h,
          color: Colors.grey[200],
        ).paddingHorizontal(AppSpace.page.w).sliverToBoxAdapter(),
        _buildHotTopic(),

        Container(height: 4.h, color: Colors.grey[200]).sliverToBoxAdapter(),

        _buildPostList(),
      ],
    );
  }

  /// 发帖
  Widget _buildPostCard() {
    List<KeyValueModel<String>> list = [
      KeyValueModel(key: "发帖", value: "分享美好倾吐焦虑"),
    ];

    return <Widget>[
          for (final i in list)
            <Widget>[
                  TextWidget.body(i.key, weight: FontWeight.bold),
                  TextWidget.muted(i.value),
                ]
                .toColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                )
                .paddingLeft(AppSpace.page)
                .tight(width: 163.5.w, height: 80.h)
                .backgroundColor(Color(0xFFFFE1F5)),
        ]
        .toRow()
        .paddingSymmetric(horizontal: AppSpace.page)
        .marginOnly(top: 10.h, bottom: 10.h)
        .sliverToBoxAdapter();
  }

  // view.dart 热门话题部分
  Widget _buildHotTopic() {
    return GetBuilder<PostsIndexController>(
      id: "subject_hot_topic",
      builder: (_) {
        return <Widget>[
              TextWidget.body(
                "热门话题",
                weight: FontWeight.bold,
              ).paddingOnly(left: AppSpace.page, top: 10.h, bottom: 10.h),
              ExpandableNotifier(
                controller: controller.expandController,
                child: Expandable(
                  collapsed: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppSpace.page.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      if (index < 3) {
                        return ListTileWidget(
                          leading: IconWidget.svg(
                            "assets/svgs/ic_posts_hot${index + 1}.svg",
                          ).paddingTop(4),
                          title: TextWidget.label(
                            item.key,
                            weight: FontWeight.bold,
                          ),

                          crossAxisAlignment: CrossAxisAlignment.start,
                          subtitle: TextWidget.label(item.value),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ).tight(height: 42.h);
                      }
                      return ButtonWidget.text(
                        backgroundColor: Colors.transparent,
                        "展开",
                        textColor: Color(0xFF999999),
                        icon: IconWidget.svg(
                          AssetsSvgs.icArrowDownSvg,
                          size: 16.r,
                        ),
                        onTap: () => controller.expanded(),
                      ).tight(height: 42.h);
                    },
                  ),
                  expanded: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppSpace.page.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.items.length) {
                        return ButtonWidget.text(
                          backgroundColor: Colors.transparent,
                          "收起",
                          textColor: Color(0xFF999999),
                          icon: IconWidget.svg(
                            AssetsSvgs.icArrowDownSvg,
                            size: 16.r,
                          ),
                          onTap: () => controller.expanded(),
                        ).tight(height: 42.h);
                      }
                      final item = controller.items[index];

                      if (index < 3) {
                        return ListTileWidget(
                          leading: IconWidget.svg(
                            "assets/svgs/ic_posts_hot${index + 1}.svg",
                          ).paddingTop(4),
                          title: TextWidget.label(
                            item.key,
                            weight: FontWeight.bold,
                          ),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          subtitle: TextWidget.label(item.value),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ).tight(height: 42.h);
                      } else {
                        return ListTileWidget(
                          padding: EdgeInsets.zero,
                          leading: SizedBox(width: 13.28.w),
                          title: TextWidget.label(
                            item.key,
                            weight: FontWeight.bold,
                          ),
                          subtitle: TextWidget.label(item.value),
                          backgroundColor: Colors.transparent,
                        ).tight(height: 42.h);
                      }
                    },
                  ),
                ),
              ),
            ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .sliverToBoxAdapter();
      },
    );
  }

  Widget _buildPostList() {
    return <Widget>[
          TextWidget.body(
            "看看大家",
            weight: FontWeight.bold,
          ).alignment(Alignment.centerLeft).tight(height: 42.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildPostItem();
            },
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
          ),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingHorizontal(16.w)
        .sliverToBoxAdapter();
  }

  Widget _buildPostItem() {
    return <Widget>[
      ListTileWidget(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        leading: ImageWidget.img(AssetsImages.imgMsgAvaterPng),
        title: TextWidget.body("用户名"),
        subtitle: TextWidget.muted("10分钟前 美国"),
        trailing: [
          ButtonWidget.outline(
            "关注",
            fontSize: 12.sp,
            textWeight: FontWeight.bold,
            icon: IconWidget.svg(AssetsSvgs.icPostsAddSvg),
            backgroundColor: Color(0x26F2A3D6),
            textColor: Color(0xFFFFA2DE),
            borderColor: Color(0xFFFFA2DE),
            borderRadius: 50,
            reverse: true,
            onTap: () {
              print("点击了关注");
            },
          ).tight(width: 76.w, height: 24.h),
        ],
      ),

      TextWidget.label(
        "我亲爱的朋友 花自向阳开 人终往前走，不要站在雾里 不要执着没有意义的人和事，不要像风，也不要像云，要像你自己。",
        weight: FontWeight.bold,
      ).paddingVertical(8.h),

      GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 6.w,
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(3, (index) {
          return TextWidget.label("图片 ${index + 1}")
              .alignCenter()
              // .tight(width: 110.w, height: 110.h)
              .decorated(
                borderRadius: BorderRadius.circular(8.r),
                color: Color(0x26F2A3D6),
              )
              .onTap(() {
                print("点击了图片 ${index + 1}");
              });
        }),
      ),
    ].toColumn().onTap(() => controller.toDetail());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsIndexController>(
      init: Get.find<PostsIndexController>(),
      id: "posts_index",
      builder: (_) {
        return ScaffoldWidget(
          useSafeArea: true,
          appBar: AppBarWidget(
            title: "圈子",
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: IconWidget.svg(AssetsSvgs.icPostsSearchSvg),
              ),
              IconButton(
                onPressed: () {},
                icon: IconWidget.svg(AssetsSvgs.icPostsMoreSvg),
              ),
            ],
          ),
          child: _buildView(),
        );
      },
    );
  }
}
