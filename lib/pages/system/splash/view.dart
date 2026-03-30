import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'index.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageWidget.img(
            AssetsImages.imgBackgroundLoginPng,
            fit: BoxFit.fill, // 填充整个界面
          ),
        ),

        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              ImageWidget.img(AssetsImages.logoPng, width: 100.w, height: 100.w, fit: BoxFit.cover),
              10.verticalSpaceFromWidth,
              TextWidget.body("YouMeet",weight: FontWeight.bold,),
            ],
          ),
        ),

        Positioned(top: 300, left: 0, right: 0, child: Center(child: TextWidget.h3("启动页占位文本"))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      id: "splash",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
