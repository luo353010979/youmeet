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
              logger.d("点击了关注");
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
            logger.d("点击了图片 ${index + 1}");
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
        // 最外层评论
        final comment = controller.comments[index];
        return _buildCommentItem(comment);
        // return CommentWidget(
        //   comment: comment,
        //   onReply: (comment, str) {
        //     logger.d(comment.toJson());
        //     controller.onReplayComment(comment, str);
        //   },
        //   onLike: () {},
        // );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
    );
  }

  /// 外层评论项
  Widget _buildCommentItem(FeedComments comment) {
    return <Widget>[
      // 头像
      <Widget>[
        ImageWidget.img(
          "http://${comment.portrait ?? ''}",
          width: 32.r,
          height: 32.r,
          radius: 50,
          fit: BoxFit.cover,
        ),

        // 用户名和评论内容
        <Widget>[
              TextWidget.muted(comment.name ?? ""),
              TextWidget.label(
                comment.trendsContent ?? "",
              ).paddingVertical(4.h),

              // 时间和回复
              <Widget>[
                TextWidget.muted(comment.createTime ?? "").paddingRight(16.w),
                ButtonWidget.text(
                  "回复",
                  fontSize: 10.sp,
                  onTap: () async {
                    final str = await Get.bottomSheet(
                      InputCommentWidget(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                    );
                    if (str != null && str is String && str.isNotEmpty) {
                      // 这里可以调用接口提交评论内容
                      controller.onReplayComment(comment, str);
                    }
                  },
                ).tight(width: 32.w, height: 14.h),
              ].toRow().paddingBottom(12.h),
            ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .paddingHorizontal(8.w)
            .expanded(),

        // 点赞
        IconWidget.svg(
          comment.isLike == 1
              ? AssetsSvgs.icLikeActiveSvg
              : AssetsSvgs.icLikeDefautSvg,
          text: "${comment.likeNum ?? 0}",
          fontSize: 10,
          onTap: () {},
        ),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.start),

      _buildReplyItem(comment.comments ?? []).paddingLeft(40.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  /// 回复评论项
  Widget _buildReplyItem(List<FeedComments> replies) {
    return ListView.builder(
      // padding: EdgeInsets.only(left: 40.w),
      itemCount: replies.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final reply = replies[index];
        return <Widget>[
          // 头像
          <Widget>[
            ImageWidget.img(
              "http://${reply.portrait ?? ''}",
              width: 16.r,
              height: 16.r,
              radius: 50,
              fit: BoxFit.cover,
            ),

            // 用户名和评论内容
            <Widget>[
                  TextWidget.muted(reply.name ?? ""),
                  TextWidget.label(
                    reply.trendsContent ?? "",
                  ).paddingVertical(4.h),

                  // 时间和回复
                  <Widget>[
                    TextWidget.muted(reply.createTime ?? "").paddingRight(16.w),
                    ButtonWidget.text(
                      "回复",
                      fontSize: 10.sp,
                      onTap: () async {
                        final str = await Get.bottomSheet(
                          InputCommentWidget(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.r),
                            ),
                          ),
                        );
                        if (str != null && str is String && str.isNotEmpty) {
                          // 这里可以调用接口提交评论内容
                          controller.onReplayComment(reply, str);
                        }
                      },
                    ).tight(width: 32.w, height: 14.h),
                  ].toRow().paddingBottom(12.h),
                ]
                .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                .padding(left: 8.w, right: 40.w)
                .expanded(),

            // 点赞
            IconWidget.svg(
              reply.isLike == 1
                  ? AssetsSvgs.icLikeActiveSvg
                  : AssetsSvgs.icLikeDefautSvg,
              text: "${reply.likeNum ?? 0}",
              fontSize: 10,
              onTap: () {},
            ),
          ].toRow(crossAxisAlignment: CrossAxisAlignment.start),

          // 10.verticalSpace,
          if (reply.comments != null && reply.comments!.isNotEmpty)
            _buildReplyItem(reply.comments?.reversed.toList() ?? []),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
      },
    );
  }

  Widget _buildButton() {
    return ButtonWidget.outline(
      "发表评论",
      fontSize: 14.sp,
      textWeight: FontWeight.bold,
      borderRadius: 50,
      width: 100.w,
      elevation: 0,
      onTap: () async {
        final str = await Get.bottomSheet(
          InputCommentWidget(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
        );
        if (str != null && str is String && str.isNotEmpty) {
          // 这里可以调用接口提交评论内容
          controller.onTapComment(controller.feed!, str);
        }
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      child: <Widget>[
        _buildPostItem(),
        16.verticalSpace,
        GetBuilder<PostDetalController>(
          id: "post_detal",
          builder: (_) {
            return controller.comments.isEmpty
                ? _buildButton()
                : _buildCommentList();
          },
        ),
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
