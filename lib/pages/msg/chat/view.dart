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
      InputWidget(
        controller: controller.idController,
        placeholder: LocaleKeys.content.tr,
        borderRadius: BorderRadius.circular(8.r),
      ),
      _buildMessageList().expanded(),
      _buildInputBar(),
    ].toColumn();
  }

  /// 消息列表
  Widget _buildMessageList() {
    return ListView.separated(
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
    );
  }

  /// 输入栏
  Widget _buildInputBar() {
    return <Widget>[
      IconButton(
        onPressed: () {},
        icon: ImageWidget.img(AssetsImages.imgMsgMicophonePng, width: 28.r),
      ),

      InputWidget(
        controller: controller.msgController,
        placeholder: LocaleKeys.content.tr,
        borderRadius: BorderRadius.circular(8.r),
        onSubmitted: (value) => controller.sendMessage(value),
      ).expanded(),

      IconButton(
        onPressed: () {},
        icon: IconWidget.svg(AssetsSvgs.icMsgCameraSvg, size: 24.r),
      ),

      IconButton(
        onPressed: () {},
        icon: IconWidget.svg(AssetsSvgs.icMsgAddSvg, size: 24.r),
      ),
    ].toRow().tight(height: 60.h);
  }

  /// 恋爱四项报告
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
                  LocaleKeys.report.tr,
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
              return <Widget>[
                    IconWidget.svg(
                      type.icon,
                      size: 32,
                      text: type.title,
                      isVertical: true,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      space: 0,
                    ),
                    ButtonWidget.primary(
                      LocaleKeys.check.tr,
                      width: 64.w,
                      height: 22.h,
                      fontSize: 11,
                      textWeight: FontWeight.w500,
                      textColor: Color(0xFF666666),
                      backgroundColor: Color(0xFFE1E1E1),
                      onTap: () {
                        print("申请查看 ${type.title}");
                      },
                    ),
                  ]
                  .toColumn(mainAxisAlignment: MainAxisAlignment.center)
                  .tight(width: 95.w, height: 97.h)
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
    final realPic = controller.displayRealPic;
    final payTaxesPic = controller.displayPayTaxesPic;
    final creditPic = controller.displayCreditPic;

    return Card(
      elevation: 4,
      child:
          <Widget>[
                TextWidget.body(
                  LocaleKeys.uploadReport.tr,
                  weight: FontWeight.bold,
                ),

                <Widget>[
                  _buildUploadCell(LocaleKeys.loveFourTitle1.tr, 1, realPic),
                  _buildUploadCell(  LocaleKeys.loveFourTitle2.tr, 2,  payTaxesPic ),
                  _buildUploadCell(LocaleKeys.loveFourTitle3.tr, 3, creditPic),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

                ButtonWidget.primary(
                  LocaleKeys.complete.tr,
                  height: 32.h,
                  onTap: controller.onComplete,
                ),
              ]
              .toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingSymmetric(horizontal: 14.w, vertical: 10.h),
    ).tight(width: 343.w, height: 165.h);
  }

  Widget _buildUploadCell(String title, int id, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ImageWidget.img(
        imageUrl,
        width: 95.w,
        height: 71.h,
        fit: BoxFit.cover,
      ).onTap(() {
        controller.pickImage(id);
      });
    }
    
    return _buildUploadItem(title, id);
  }

  Widget _buildUploadItem(String title, int id) {
    return <Widget>[
          ImageWidget.img(
            AssetsImages.imgMsgUploadPng,
            width: 32.r,
            height: 30.r,
          ),

          TextWidget.label(title, weight: FontWeight.bold),
        ]
        .toColumnSpace(mainAxisAlignment: MainAxisAlignment.center, space: 5.h)
        .tight(width: 95.w, height: 71.h)
        .decorated(
          color: Color(0xFFF4F3F3),
          borderRadius: BorderRadius.circular(8),
        )
        .onTap(() {
          controller.pickImage(id);
        });
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
