import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/components/comment.dart';
import 'package:youmeet/common/components/like.dart';

import 'index.dart';

class PostDetalPage extends GetView<PostDetalController> {
  const PostDetalPage({super.key});

  Widget _buildPostItem() {
    return <Widget>[
      ListTileWidget(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        leading: ImageWidget.img(AssetsImages.imgMsgAvaterPng),
        title: TextWidget.body("用户名", weight: FontWeight.w500),
        subtitle: TextWidget.muted("05月30日 14:20"),
        trailing: [
          ButtonWidget.primary(
            "关注",
            fontSize: 12.sp,
            textWeight: FontWeight.bold,
            icon: IconWidget.svg(AssetsSvgs.icPostsAddSvg),
            borderRadius: 50,
            elevation: 0,
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

      <Widget>[
        LikeWidget(),
        TextWidget.muted("等16个人赞过"),
        Spacer(),
        IconWidget.svg(
          AssetsSvgs.icPostsLikeDefautSvg,
          text: "1000",
        ).paddingRight(16.w),
        IconWidget.svg(AssetsSvgs.icPostsCommentSvg, text: "1000"),
      ].toRow().paddingTop(12.h),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildCommentItem() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return CommentWidget();
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
    );
  }

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: <Widget>[
        _buildPostItem(),
        _buildCommentItem(),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetalController>(
      init: PostDetalController(),
      id: "post_detal",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(title: "详情", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
