import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class PostsIndexPage extends GetView<PostsIndexController> {
  const PostsIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return EasyRefresh(
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      child: CustomScrollView(
        slivers: [
          _buildPostCard(),
          Container(
            height: 2.h,
            color: Colors.grey[200],
          ).paddingHorizontal(AppSpace.page.w).sliverToBoxAdapter(),

          // _buildHotTopic(),
          Container(height: 4.h, color: Colors.grey[200]).sliverToBoxAdapter(),

          _buildPostList(),
        ],
      ),
    );
  }

  /// 发帖
  Widget _buildPostCard() {
    List<KeyValueModel<String>> list = [
      KeyValueModel(key: "发帖", value: "分享美好倾吐焦虑"),
      // KeyValueModel(key: "开播", value: "分享美好倾吐焦虑"),
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
                .backgroundImage(
                  DecorationImage(
                    image: AssetImage(AssetsImages.imgPost_1Png),
                    fit: BoxFit.cover,
                  ),
                )
                .onTap(() {
                  Get.toNamed(RouteNames.mySendFeed);
                }),
        ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
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
            itemCount: controller.feedList.length,
            itemBuilder: (context, index) {
              final feed = controller.feedList[index];
              return _buildPostItem(feed);
            },
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
          ),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingHorizontal(16.w)
        .sliverToBoxAdapter();
  }

  Widget _buildPostItem(Feed feed) {
    List<String> images = feed.pic?.split(",") ?? [];

    return <Widget>[
          ListTileWidget(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            leading: ImageWidget.img(
              "http://${feed.portrait}",
              width: 36.r,
              height: 36.r,
              radius: 50,
              fit: BoxFit.cover,
            ),
            title: TextWidget.body(feed.name ?? ""),
            subtitle: TextWidget.muted(feed.createTime ?? ""),
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
                  logger.d("点击了关注");
                },
              ).tight(width: 76.w, height: 24.h),
            ],
          ),

          TextWidget.label(
            feed.content ?? "",
            weight: FontWeight.bold,
          ).paddingVertical(8.h),

          GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 6.h,
            crossAxisSpacing: 6.w,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(images.length, (index) {
              return ImageWidget.img(
                images[index],
                fit: BoxFit.cover,
                radius: 10,
              ).onTap(() {
                logger.d("点击了图片 ${index + 1}");
              });
            }),
          ),
          // 评论点赞
          // <Widget>[
          //   // LikeWidget(),
          //   // TextWidget.muted("等${feed.likeNum ?? 0}个人赞过"),
          //   Spacer(),
          //   IconWidget.svg(
          //     feed.isLike == 0
          //         ? AssetsSvgs.icPostsLikeDefautSvg
          //         : AssetsSvgs.icPostsLikeActiveSvg,
          //     size: 16.r,
          //     text: "${feed.likeNum ?? 0}",

          //     onTap: () {
          //       /// 点赞/取消点赞
          //       controller.onTapLike(feed);
          //     },
          //   ).paddingRight(16.w),
          //   IconWidget.svg(
          //     AssetsSvgs.icPostsCommentSvg,
          //     size: 16.r,
          //     text: "${feed.commentNum ?? 0}",
          //     onTap: () async {
          //       final str = await Get.bottomSheet(
          //         InputCommentWidget(),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.vertical(
          //             top: Radius.circular(16.r),
          //           ),
          //         ),
          //       );
          //       if (str != null && str is String && str.isNotEmpty) {
          //         // 这里可以调用接口提交评论内容
          //         controller.onTapComment(feed, str);
          //       }
          //     },
          //   ),
          // ].toRow().paddingTop(12.h),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .onTap(() => controller.toDetailPage(feed));
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
                onPressed: () {
                  print(UserService.to.token);
                  print(UserService.to.profile.id);
                },
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
