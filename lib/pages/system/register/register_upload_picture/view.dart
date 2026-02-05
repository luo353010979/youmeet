import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class RegisterUploadPicturePage
    extends GetView<RegisterUploadPictureController> {
  const RegisterUploadPicturePage({super.key});

  // 主视图
  Widget _buildView() {
    return Center(
      child: <Widget>[
        _takePhotoWidget(),
        15.verticalSpace,
        _buildImageWidget(),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.center),
    );
  }

  Widget _takePhotoWidget() {
    return Card(
      child:
          <Widget>[
                TextWidget.body("真人身份验证", weight: FontWeight.bold),
                24.verticalSpace,
                TextWidget.muted("请做出与示例图片中相同的手势。同时，确保您的面部和上半身完全露出。"),
                103.verticalSpace,
                ButtonWidget.primary(
                  width: 180.w,
                  height: 32.h,
                  "拍照",
                  elevation: 0,
                  borderRadius: 50,
                  onTap: () {},
                ),
              ]
              .toColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              )
              .paddingHorizontal(32.w),
    ).tight(width: 320.w, height: 436.h);
  }

  Widget _buildImageWidget() {
    return Container(width: 320.w, height: 220.h, color: Colors.grey[300]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterUploadPictureController>(
      init: RegisterUploadPictureController(),
      id: "register_upload_picture",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(title: "实名认证", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
