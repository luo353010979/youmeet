import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/index.dart';

class RegisterBasicInformationPage extends GetView<RegisterIndexController> {
  const RegisterBasicInformationPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
          32.verticalSpace,

          TextWidget.h3(
            "${LocaleKeys.welcome.tr}\n${LocaleKeys.welcomeDesc.tr}",
            weight: FontWeight.bold,
          ),

          40.verticalSpace,

          _buildAvatarWidget(),

          32.verticalSpace,

          _buildNickNameWidget(),

          28.verticalSpace,

          _buildBirthWidget(),

          28.verticalSpace,

          _buildGenderWidget(),

          Spacer(),

          ButtonWidget.primary(
            LocaleKeys.commonNext.tr,
            textWeight: FontWeight.bold,
            height: 44.h,
            elevation: 0,
            borderRadius: 50,
            onTap: () {
              // 跳转到实名认证
              Get.toNamed(RouteNames.systemRegisterRegisterUploadPicture);
              // controller.onRegister();
            },
          ).tight(height: 44.h).paddingBottom(30.h),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingSymmetric(horizontal: 16.w);
  }

  Widget _buildAvatarWidget() {
    return <Widget>[
      ImageWidget.img(
        controller.req.portrait?.isNotEmpty == true
            ? "http://${controller.req.portrait}"
            : AssetsImages.imgAvatarPng,
        width: 80.r,
        height: 80.r,
        radius: 50,
        fit: BoxFit.cover,
      ),
      ImageWidget.img(
            AssetsImages.imgCameraPng,
            width: 24.r,
            height: 24.r,
            fit: BoxFit.cover,
          )
          .onTap(() {
            controller.pickImage(Constants.avatar);
          })
          .positioned(right: 0, bottom: 0),
    ].toStack();
  }

  Widget _buildNickNameWidget() {
    return <Widget>[
      TextWidget.muted(LocaleKeys.nickname.tr),
      <Widget>[
        ImageWidget.img(
          AssetsImages.imgEditLeftPng,
          width: 8.r,
          height: 24.r,
          fit: BoxFit.cover,
          radius: 0,
        ),

        TextField(
          controller: controller.nikenameController,
          focusNode: controller.nikenameFocusNode,
          onTapUpOutside: (event) {
            controller.nikenameFocusNode.unfocus();
          },
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: LocaleKeys.nickname.tr,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            border: InputBorder.none,
          ),
        ).tight(width: 63.w).paddingHorizontal(10.w),

        ImageWidget.img(
          AssetsImages.imgEditRightPng,
          width: 8.r,
          height: 24.r,
          fit: BoxFit.cover,
          radius: 0,
        ),
      ].toRow(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildBirthWidget() {
    return <Widget>[
      TextWidget.muted(LocaleKeys.birth.tr),
      <Widget>[
        ImageWidget.img(
          AssetsImages.imgEditLeftPng,
          width: 8.r,
          height: 24.r,
          fit: BoxFit.cover,
          radius: 0,
        ),

        TextField(
          controller: controller.birthController,
          focusNode: controller.birthFocusNode,
          onTapUpOutside: (event) {
            controller.birthFocusNode.unfocus();
          },
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: "1990-01-01",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            border: InputBorder.none,
          ),
        ).tight(width: 126.w).paddingHorizontal(10.w),

        ImageWidget.img(
          AssetsImages.imgEditRightPng,
          width: 8.r,
          height: 24.r,
          fit: BoxFit.cover,
          radius: 0,
        ),
      ].toRow(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildGenderWidget() {
    return GetBuilder<RegisterIndexController>(
      id: "gender",
      builder: (_) {
        return <Widget>[
          TextWidget.muted(LocaleKeys.gender.tr),
          <Widget>[
            Container(
              width: 50.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: controller.req.sex == 1
                      ? Get.theme.colorScheme.primary
                      : Colors.white,
                ),

                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: IconWidget.svg(
                  AssetsSvgs.icMyGenderBoySvg,
                  width: 16.w,
                  height: 16.w,
                  fit: BoxFit.contain,
                ),
              ),
            ).onTap(() {
              controller.updateGender(1);
            }),

            Container(
              width: 50.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: controller.req.sex == 2
                      ? Get.theme.colorScheme.primary
                      : Colors.white,
                ),

                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: IconWidget.svg(
                  AssetsSvgs.icMyGirlSvg,
                  width: 16.w,
                  height: 16.w,
                  fit: BoxFit.contain,
                ),
              ),
            ).onTap(() {
              controller.updateGender(2);
            }),
          ].toRowSpace(),
        ].toColumnSpace(crossAxisAlignment: CrossAxisAlignment.start);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterIndexController>(
      id: "register_basic_information",
      builder: (_) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBarWidget(backgroundColor: Colors.transparent),
          // resizeToAvoidBottomInset: true,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsImages.imgBackgroundLoginPng),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(child: _buildView(context)),
          ),
        );
      },
    );
  }
}
