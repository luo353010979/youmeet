import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:youmeet/common/index.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, required this.comment});

  final FeedComments comment;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 头像
      <Widget>[
        ImageWidget.img(
          "http://${widget.comment.portrait ?? ''}",
          width: 32.r,
          height: 32.r,
          radius: 50,
          fit: BoxFit.cover,
        ),

        // 用户名和评论内容
        <Widget>[
              TextWidget.muted(widget.comment.name ?? ""),
              TextWidget.label(
                widget.comment.trendsContent ?? "",
              ).paddingVertical(4.h),

              // 时间和回复
              <Widget>[
                TextWidget.muted(
                  widget.comment.createTime ?? "",
                ).paddingRight(16.w),
                ButtonWidget.text(
                  "回复",
                  fontSize: 10.sp,
                  onTap: () {
                    print("点击了回复");
                  },
                ).tight(width: 32.w, height: 14.h),
              ].toRow().paddingBottom(12.h),
            ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .paddingHorizontal(8.w)
            .expanded(),

        // 点赞
        IconWidget.svg(
          widget.comment.isLike == 1
              ? AssetsSvgs.icLikeActiveSvg
              : AssetsSvgs.icLikeDefautSvg,
          text: "${widget.comment.likeNum ?? 0}",
          fontSize: 10,
        ),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.start),

      _buildReplyItem(widget.comment.comments ?? []).paddingLeft(40.w),
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
                      onTap: () {
                        print("点击了回复");
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
