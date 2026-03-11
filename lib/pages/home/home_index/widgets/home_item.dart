import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key, required this.data});

  final UserMessage data;

  @override
  Widget build(BuildContext context) {
    Widget _buildChip(String text) {
      return IconWidget.svg(
            AssetsSvgs.icPassSvg,
            text: text,
            fontColor: Color(0xFF999999),
            size: 14.r,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            space: 2.w,
          )
          .alignCenter()
          .tight(width: 44.w, height: 18.h)
          .decorated(
            color: Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(2),
          );
    }

    return Container(
      width: 343.w,
      height: 134.h,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsImages.imgHomeCardPng),
          fit: BoxFit.cover,
        ),
      ),
      child: <Widget>[
        ImageWidget.img(
          "http://${data.portrait ?? AssetsImages.homePlaceholderPng}",
          width: 90.w,
          height: 120.h,
          fit: BoxFit.cover,
          radius: 10,
        ).paddingLeft(12.w),

        <Widget>[
              <Widget>[
                TextWidget.body(data.name ?? "", weight: FontWeight.bold),
                IconWidget.svg(
                      AssetsSvgs.icWomanSvg,
                      text: "${data.age ?? ""}",
                      fontColor: Colors.white,
                      size: 10.r,
                      fontSize: 10,
                      space: 2.w,
                    )
                    .alignCenter()
                    .tight(width: 35.w, height: 15.h)
                    .decorated(
                      color: Get.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
              ].toRowSpace(space: 6.w),

              <Widget>[
                TextWidget.muted("${data.profile}", weight: FontWeight.bold),
                SizedBox(
                  height: 8.h,
                  child: VerticalDivider(color: Color(0xFFCCCCCC), width: 1.w),
                ),
                TextWidget.muted(
                  "${data.height ?? ""}cm/${data.weight ?? ""}kg",
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 8.h,
                  child: VerticalDivider(color: Color(0xFFCCCCCC), width: 1.w),
                ),
                TextWidget.muted(data.country ?? "", weight: FontWeight.bold),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

              <Widget>[
               if(data.isRealName == 1) _buildChip(LocaleKeys.tag1.tr),
               if(data.isHealth == 1) _buildChip(LocaleKeys.tag2.tr),
               if(data.isPayTaxes == 1) _buildChip(LocaleKeys.tag3.tr),
               if(data.isCredit == 1) _buildChip(LocaleKeys.tag4.tr),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

              <Widget>[
                ButtonWidget.outline(
                  LocaleKeys.viewApplication.tr,
                  width: 86.w,
                  height: 23.h,
                  fontSize: 11,
                  textWeight: FontWeight.bold,
                  borderColor: context.colors.scheme.primary,
                  backgroundColor: Color(0x33FF64C8),
                  onTap: () {},
                ),
                ButtonWidget.primary(
                  LocaleKeys.sayHi.tr,
                  width: 53.w,
                  height: 23.h,
                  fontSize: 11,
                  onTap: () => Get.toNamed(RouteNames.msgChat, arguments: data),
                  textWeight: FontWeight.bold,
                  backgroundColor: Color(0xFFFF64C8),
                ),
              ].toRowSpace(space: 8.w),
            ]
            .toColumnSpace(mainAxisAlignment: MainAxisAlignment.center)
            .paddingSymmetric(horizontal: 16.w)
            .expanded(),
      ].toRow(),
    ).onTap(() => Get.toNamed(RouteNames.homeMatchingDetail, arguments: data));
  }
}
