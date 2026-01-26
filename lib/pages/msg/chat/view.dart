import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      ListView.separated(
        padding: EdgeInsets.all(16.w),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCard();
          } else {
            return TextWidget.label(controller.messages[index]);
          }
        },

        separatorBuilder: (context, index) => SizedBox(height: 10.h),
      ).expanded(),

      <Widget>[
        IconButton(
          onPressed: () {},
          icon: ImageWidget.img(AssetsImages.imgMsgMicophonePng, width: 28.r),
        ),

        InputWidget(
          placeholder: "请输入消息内容",
          borderRadius: BorderRadius.circular(8.r),
        ).expanded(),

        IconButton(
          onPressed: () {},
          icon: IconWidget.svg(AssetsSvgs.icMsgCameraSvg, size: 24.r),
        ),

        IconButton(
          onPressed: () {},
          icon: IconWidget.svg(AssetsSvgs.icMsgAddSvg, size: 24.r),
        ),
      ].toRow().tight(height: 60.h),
    ].toColumnSpace(space: 10.h);
  }

  Widget _buildCard() {
    return <Widget>[_buildUserInfoCard(), _buildUploadCard()].toColumnSpace();
  }

  Widget _buildUserInfoCard() {
    return Card(
      elevation: 4,
      child: <Widget>[
        ListTileWidget(
          padding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 22.r,
            child: ImageWidget.img(AssetsImages.imgMsgAvaterPng),
          ),
          title: TextWidget.body('张思雨', weight: FontWeight.bold),
          trailing: [
            TextWidget.label(
                  '申请报告',
                  weight: FontWeight.bold,
                  color: Colors.white,
                )
                .alignCenter()
                .tight(width: 77.w, height: 26.h)
                .decorated(
                  image: DecorationImage(
                    image: AssetImage(AssetsImages.imgMsgBgPng),
                    fit: BoxFit.cover,
                  ),
                ),
          ],
        ).tight(height: 44.h),

        SizedBox(height: 8.h),

        controller.types
            .map((type) {
              return IconWidget.svg(
                    type.icon,
                    size: 32,
                    text: type.title,
                    isVertical: true,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )
                  .tight(width: 95.w, height: 71.h)
                  .decorated(
                    color: Color(0xFFF4F3F3),
                    borderRadius: BorderRadius.circular(8),
                  );
            })
            .toList()
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .expanded(),
      ].toColumn().paddingSymmetric(horizontal: 14.w, vertical: 10.h),
    ).tight(width: 343.w, height: 169.h);
  }

  Widget _buildUploadCard() {
    return Card(
      elevation: 4,
      child:
          <Widget>[
                TextWidget.body("请上传您的安全报告", weight: FontWeight.bold),

                controller.types
                    .map(
                      (type) =>
                          <Widget>[
                                ImageWidget.img(
                                  AssetsImages.imgMsgUploadPng,
                                  width: 32.r,
                                  height: 30.r,
                                ),

                                TextWidget.label(
                                  type.title,
                                  weight: FontWeight.bold,
                                ),
                              ]
                              .toColumnSpace(
                                mainAxisAlignment: MainAxisAlignment.center,
                                space: 5.h,
                              )
                              .tight(width: 95.w, height: 71.h)
                              .decorated(
                                color: Color(0xFFF4F3F3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                    )
                    .toList()
                    .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

                ButtonWidget.primary(
                  "完成",
                  height: 32.h,
                  onTap: controller.onComplete,
                ),
              ]
              .toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingSymmetric(horizontal: 14.w, vertical: 10.h),
    ).tight(width: 343.w, height: 165.h);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      id: "chat",
      builder: (_) {
        return ScaffoldWidget(
          useSafeArea: true,
          appBar: AppBarWidget(
            title: "昵称",
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: controller.onMorePressed,
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          child: _buildView(context),
        );
      },
    );
  }
}
