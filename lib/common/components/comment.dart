import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:youmeet/common/index.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key});

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
          AssetsImages.imgMsgAvaterPng,
          width: 32.r,
          height: 32.r,
        ),

        // 用户名和评论内容
        <Widget>[
              TextWidget.muted("用户名"),
              TextWidget.label(
                "这是评论内容这是评论内容这是评论内容这是评论内容这是评论内容",
              ).paddingVertical(4.h),

              // 时间和回复
              <Widget>[
                TextWidget.muted("05月30日 14:20").paddingRight(16.w),
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
        IconWidget.svg(AssetsSvgs.icLikeActiveSvg, text: "1000", fontSize: 10),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.start),

      _buildReplyItem(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildReplyItem() {
    return ListView.separated(
      padding: EdgeInsets.only(left: 40.w),
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return <Widget>[
          // 头像
          <Widget>[
            ImageWidget.img(
              AssetsImages.imgMsgAvaterPng,
              width: 16.r,
              height: 16.r,
            ),

            // 用户名和评论内容
            <Widget>[
                  TextWidget.muted("用户名"),
                  TextWidget.label("这是评论内容这是评论").paddingVertical(4.h),

                  // 时间和回复
                  <Widget>[
                    TextWidget.muted("05月30日 14:20").paddingRight(16.w),
                    ButtonWidget.text(
                      "回复",
                      fontSize: 10.sp,
                      onTap: () {
                        print("点击了回复");
                      },
                    ).tight(width: 32.w, height: 14.h),
                  ].toRow(),
                ]
                .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                .paddingHorizontal(8.w)
                .expanded(),

            // 点赞
            IconWidget.svg(
              AssetsSvgs.icLikeActiveSvg,
              text: "1000",
              fontSize: 10,
            ),
          ].toRow(crossAxisAlignment: CrossAxisAlignment.start),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
      },

      separatorBuilder: (context, index) => SizedBox(height: 12.h),
    );
  }
}
