import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    this.onReply,
    this.onLike,
  });

  final FeedComments comment;
  final void Function(FeedComments comment, String content)? onReply;
  final void Function()? onLike;

  @override
  Widget build(BuildContext context) {
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
                      onReply?.call(comment, str);
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
          onTap: onLike,
        ),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.start),

      _buildReplyItem(comment.comments ?? []).paddingLeft(40.w),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

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
                          onReply?.call(reply, str);
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
              onTap: onLike,
            ),
          ].toRow(crossAxisAlignment: CrossAxisAlignment.start),

          // 10.verticalSpace,
          if (reply.comments != null && reply.comments!.isNotEmpty)
            _buildReplyItem(reply.comments?.reversed.toList() ?? []),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
      },
    );
  }
}
