import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class HomeIndexPage extends GetView<HomeIndexController> {
  const HomeIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return Column(children: [_buildAppBar(), _buildSlider()]);
  }

  Widget _buildAppBar() {
    return AppBarWidget(
      title: "附近认证",
      centerTitle: false,
      backgroundColor: Colors.transparent,
    );
  }

  /// 顶部推荐滑动栏
  Widget _buildSlider() {
    return Container(
      height: 164.h,
      // color: Colors.amber,
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            top: 24.h,
            child: TextWidget.label("安全交友", size: 16.sp),
          ),

          Positioned(
            left: 16.w,
            top: 52.h,
            child: TextWidget.label("真实可靠", size: 26.sp),
          ),

          // 用户名字
          Positioned(
            right: 76.w,
            top: 52.h,
            child: TextWidget.label("张思雨", size: 18.sp),
          ),

          Positioned(
            right: 17.w,
            top: 5.h,
            child: Container(
              // color: Colors.white,
              child: ImageWidget.img(
                AssetsImages.imgHomeAvaterPng,
                width: 262.w,

                fit: BoxFit.cover,
              ),
            ),
          ),

          // 用户照片
          Positioned(
            right: 30.w,
            top: 76.h,
            child: ImageWidget.img(
              AssetsImages.imgHomeYoumeetPng,
              width: 100.w,
              height: 24.h,
              fit: BoxFit.contain,
            ),
          ),
          
          Positioned(
            right: 75.w,
            top: 108.h,
            child: TextWidget.label("立即查看", color: Color(0xFFDA597F)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(){
    return TabBar(
      tabs: [
      Tab(text: "推荐"),
      Tab(text: "同城"),
      Tab(text: "新用户"),  
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeIndexController>(
      init: HomeIndexController(),
      id: "home_index",
      builder: (_) {
        return Scaffold(
          // appBar: AppBarWidget(title: "附近认证"),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsImages.imgBackgroundDefautPng),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(child: _buildView()),
          ),
        );
      },
    );
  }
}
