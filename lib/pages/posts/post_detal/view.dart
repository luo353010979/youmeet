import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class PostDetalPage extends GetView<PostDetalController> {
  const PostDetalPage({super.key});

  Widget _buildPostItem() {
    Feed? feed = controller.feed;
    List<String> images = feed?.pic?.split(",") ?? [];

    return <Widget>[
      ListTileWidget(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        leading: ImageWidget.img(
          "http://${feed?.portrait ?? ''}",
          width: 36.r,
          height: 36.r,
          radius: 50,
          fit: BoxFit.cover,
        ),
        title: TextWidget.body(feed?.name ?? "", weight: FontWeight.w500),
        subtitle: TextWidget.muted(feed?.createTime ?? ""),
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
        feed?.content ?? "",
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
            print("点击了图片 ${index + 1}");
          });
        }),
      ),

      <Widget>[
        // LikeWidget(),
        // TextWidget.muted("等16个人赞过"),
        Spacer(),
        IconWidget.svg(
          AssetsSvgs.icPostsLikeDefautSvg,
          text: "${feed?.likeNum ?? "0"}",
        ).paddingRight(16.w),
        IconWidget.svg(
          AssetsSvgs.icPostsCommentSvg,
          text: "${feed?.commentNum ?? "0"}",
        ),
      ].toRow().paddingTop(12.h),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildCommentList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.comments.length,
      itemBuilder: (context, index) {
        final comment = controller.comments[index];
        return CommentWidget(comment: comment);
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
        16.verticalSpace,
        _buildCommentList(),
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
