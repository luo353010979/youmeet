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
        AssetsImages.imgMsgAvaterPng,
        width: 54.r,
        height: 54.r,
        fit: BoxFit.cover,
      ),
      title: <Widget>[
        TextWidget.h4("用户名", weight: FontWeight.bold).paddingRight(12.w),
        IconWidget.svg(
              AssetsSvgs.icMyGirlSvg,
              text: "22岁",
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
        TextWidget.muted("34粉丝").paddingRight(12.w),
        TextWidget.muted("34关注"),
      ].toRow(),
      onTap: () => controller.toProfileView(),
    ).paddingVertical(16.h);
  }

  Widget _buildCounter() {
    return <Widget>[
          ColumTextWidget(keyText: "看过我", valueText: "21"),
          SizedBox(width: 1.w, height: 16.h).backgroundColor(Color(0xFFD9D9D9)),
          ColumTextWidget(keyText: "我看过", valueText: "10"),
          SizedBox(width: 1.w, height: 16.h).backgroundColor(Color(0xFFD9D9D9)),
          ColumTextWidget(keyText: "我喜欢", valueText: "60"),
          SizedBox(width: 1.w, height: 16.h).backgroundColor(Color(0xFFD9D9D9)),
          ColumTextWidget(keyText: "喜欢我", valueText: "18"),
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
                          print("点击了编辑形象");
                        }),
                      ]
                      .toColumn(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      )
                      .tight(width: 150.r, height: 150.r),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ]
              .toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )
              .paddingAll(16.w),
    ).tight(width: 343.w, height: 215.h).marginOnly(bottom: 20.h);
  }

  Widget _buildPostList() {
    return Card(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _buildPostItem();
        },

        itemCount: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
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
    ].toColumn().paddingAll(16.w);
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
                onPressed: () {},
                icon: IconWidget.svg(AssetsSvgs.icMsgSettingSvg),
              ),
            ],
          ),
          child: _buildView(),
        );
      },
    );
  }
}
