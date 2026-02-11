import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: <Widget>[
        _buildUserInfo(),
        _buildCounter(),
        _buildMyImage(),
        _buildPostList(),
      ].toColumn().paddingHorizontal(AppSpace.page.w),
    );
  }

  Widget _buildUserInfo() {
    return ListTileWidget(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      isRipple: false,
      leading: ImageWidget.img(
        "http://${controller.userMessage.portrait}",
        width: 54.r,
        height: 54.r,
        fit: BoxFit.cover,
        radius: 50,
      ),
      title: <Widget>[
        TextWidget.h4(
          controller.userMessage.name ?? "",
          weight: FontWeight.bold,
        ).paddingRight(12.w),
        IconWidget.svg(
              AssetsSvgs.icMyGirlSvg,
              text: "${controller.userMessage.age}",
              // fontColor: Get.theme.colorScheme.primary,
              size: 10.r,
              fontSize: 10,
              space: 2.w,
            )
            .alignCenter()
            .tight(width: 49.w, height: 21.h)
            .decorated(
              color: Color(0x26F2A3D6),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFFFA2DE)),
            ),
      ].toRow(),
      subtitle: <Widget>[
        TextWidget.muted(
          "${controller.userMessage.concernedNum}粉丝",
        ).paddingRight(12.w),
        TextWidget.muted("${controller.userMessage.concernNum}关注"),
      ].toRow(),
      onTap: () => controller.toProfileView(),
    ).paddingVertical(16.h);
  }

  Widget _buildCounter() {
    return <Widget>[
          ColumTextWidget(
            keyText: TextWidget.h4("${controller.userMessage.viewedNum}"),
            valueText: TextWidget.muted("看过我", size: 10),
          ),
          SizedBox(width: 1.w, height: 16.h).backgroundColor(Color(0xFFD9D9D9)),
          ColumTextWidget(
            keyText: TextWidget.h4("${controller.userMessage.viewNum}"),
            valueText: TextWidget.muted("我看过", size: 10),
          ),
          SizedBox(width: 1.w, height: 16.h).backgroundColor(Color(0xFFD9D9D9)),
          ColumTextWidget(
            keyText: TextWidget.h4("${controller.userMessage.likeNum}"),
            valueText: TextWidget.muted("我喜欢", size: 10),
          ),
          SizedBox(width: 1.w, height: 16.h).backgroundColor(Color(0xFFD9D9D9)),
          ColumTextWidget(
            keyText: TextWidget.h4("${controller.userMessage.likedNum}"),
            valueText: TextWidget.muted("喜欢我", size: 10),
          ),
        ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceEvenly)
        .paddingBottom(20.h);
  }

  /// 我的形象
  Widget _buildMyImage() {
    return Card(
      child:
          <Widget>[
                TextWidget.body("我的形象", weight: FontWeight.bold),

                <Widget>[
                  TextWidget.label("图片1")
                      .alignCenter()
                      .tight(width: 150.w, height: 150.w)
                      .decorated(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Color(0x26F2A3D6),
                      ),

                  <Widget>[
                        <Widget>[
                          TextWidget.label("图片2")
                              .alignCenter()
                              .tight(width: 71.w, height: 98.w)
                              .decorated(
                                borderRadius: BorderRadius.circular(8.r),
                                color: Color(0x26F2A3D6),
                              ),

                          TextWidget.label("图片3")
                              .alignCenter()
                              .tight(width: 71.w, height: 98.w)
                              .decorated(
                                borderRadius: BorderRadius.circular(8.r),
                                color: Color(0x26F2A3D6),
                              ),
                        ].toRow(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),

                        ImageWidget.img(
                          AssetsImages.imgMyEditPng,
                          width: 150.w,
                          height: 44.w,
                          fit: BoxFit.cover,
                        ).onTap(() {
                          var token = Storage().getString(
                            Constants.storageToken,
                          );
                          print(token);
                        }),
                      ]
                      .toColumn(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      )
                      .tight(width: 150.w, height: 150.w),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ]
              .toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )
              .paddingAll(16.w),
    ).tight(height: 215.w).marginOnly(bottom: 20.h);
  }

  Widget _buildPostList() {
    return Card(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final feed = controller.myFeedList[index];
          return _buildPostItem(feed);
        },

        itemCount: controller.myFeedList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildPostItem(Record feed) {
    List<String> images = feed.pic?.split(",") ?? [];

    return <Widget>[
      ListTileWidget(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        leading: ImageWidget.img(
          "http://${feed.portrait}",
          width: 36.r,
          height: 36.r,
          fit: BoxFit.cover,
          radius: 50,
        ),
        title: TextWidget.body("${feed.name}"),
        subtitle: TextWidget.muted("${feed.createTime}"),
        trailing: [
          ButtonWidget.outline(
            "分享",
            fontSize: 12.sp,
            textWeight: FontWeight.bold,
            icon: IconWidget.svg(AssetsSvgs.icMyShareSvg),
            backgroundColor: Color(0x26F2A3D6),
            textColor: Color(0xFFFFA2DE),
            borderColor: Color(0xFFFFA2DE),
            borderRadius: 50,
            reverse: true,
            onTap: () {
              print("点击了分享");
            },
          ).tight(width: 76.w, height: 24.h),
        ],
      ),

      TextWidget.label(
        "${feed.content}",
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
            width: 110.w,
            height: 110.h,
            fit: BoxFit.cover,
          ).decorated(
            borderRadius: BorderRadius.circular(8.r),
            color: Color(0x26F2A3D6),
          );
        }),
      ),

      <Widget>[
        // LikeWidget(),
        // TextWidget.muted("等${feed.likeNum}个人赞过"),
        Spacer(),
        IconWidget.svg(
          AssetsSvgs.icPostsLikeDefautSvg,
          text: "${feed.likeNum}",
        ).paddingRight(16.w),
        IconWidget.svg(
          AssetsSvgs.icPostsCommentSvg,
          text: "${feed.commentNum}",
        ),
      ].toRow().paddingTop(12.h),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingAll(16.w);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      init: Get.find<MyIndexController>(),
      id: "my_index",
      builder: (_) {
        return ScaffoldWidget(
          useSafeArea: true,
          appBar: AppBarWidget(
            title: "个人中心",
            centerTitle: false,
            actions: [
              IconButton(
                icon: IconWidget.svg(AssetsSvgs.icMsgSettingSvg),
                onPressed: () {
                  Get.toNamed(RouteNames.systemSettingsSettingsIndex);
                },
              ),
            ],
          ),
          child: _buildView(),
        );
      },
    );
  }
}
