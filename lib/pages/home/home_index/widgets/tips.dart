import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class TipsWidget extends StatelessWidget {
  const TipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
          ImageWidget.img(
            "http://${UserService.to.profile.portrait}",  
            radius: 50.r,
            width: 60.w,
            height: 60.w,
            fit: BoxFit.cover,
          ).paddingHorizontal(14.w),

          <Widget>[
            TextWidget.label(
              LocaleKeys.qualification.trParams({'size': '1'}),
              size: 16,
              weight: FontWeight.bold,
            ),

            <Widget>[
              ButtonWidget.primary(
                LocaleKeys.apply.tr,
                width: 92.w,
                height: 25.h,
                fontSize: 12,
                textWeight: FontWeight.bold,
                onTap: () {},
              ),
              ButtonWidget.outline(
                LocaleKeys.improve.tr,
                width: 92.w,
                height: 25.h,
                fontSize: 12,
                borderColor: context.colors.scheme.primary,
                textWeight: FontWeight.bold,
                backgroundColor: Color(0x33FF64C8),
                onTap: () {},
              ),
            ].toRowSpace(space: 8.w),
          ].toColumnSpace(
            space: 8.h,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ]
        .toRow()
        .tight(width: 343.w, height: 95.h)
        .decorated(
          image: DecorationImage(
            image: AssetImage(AssetsImages.imgHomeTipsPng),
            fit: BoxFit.fill,
          ),
        )
        .marginOnly(bottom: 10.h);
  }
}
