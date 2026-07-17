import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/index.dart';

class RegisterUploadPicturePage extends GetView<RegisterIndexController> {
  const RegisterUploadPicturePage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Center(
        child: <Widget>[
          // 上传/拍照区
          controller.req.realPic != null && controller.req.realPic!.isNotEmpty
              ? _buildRealPicWidget()
              : _takePhotoWidget(),
          15.verticalSpace,
          // 固定示例图：引导用户做出相同手势（图内已含说明文案），与是否已拍照无关
          _buildExampleWidget(),
        ]
            .toColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
            )
            .paddingSymmetric(vertical: 16.h),
      ),
    );
  }

  /// 固定示例图（顶部叠加多语言提示文案）
  Widget _buildExampleWidget() {
    return SizedBox(
      width: 320.w,
      height: 220.h,
      child: Stack(
        children: [
          ImageWidget.img(
            AssetsImages.imgExamplePng,
            width: 320.w,
            height: 220.h,
            fit: BoxFit.cover,
            radius: 8,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 32.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
              ),
              child: TextWidget.label(
                LocaleKeys.realGestureTip.tr,
                size: 12,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
                  onTap: () {
                    controller.pickImage(Constants.realPic);
                  },
                ),
              ]
              .toColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              )
              .paddingHorizontal(32.w),
    ).tight(width: 320.w, height: 436.h);
  }

  Widget _buildRealPicWidget() {
    return ImageWidget.img(
      "http://${controller.req.realPic}",
      width: 320.w,
      height: 436.h,
      fit: BoxFit.cover,
      radius: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterIndexController>(
      id: "register_upload_picture",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(
            title: "实名认证",
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: ButtonWidget.primary(
                    "保存",
                    width: 50.w,
                    height: 25.h,
                    onTap: () {
                      controller.onRegister();
                    },
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
