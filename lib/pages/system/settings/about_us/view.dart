import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class AboutUsPage extends GetView<AboutUsController> {
  const AboutUsPage({super.key});

  // 主视图
  Widget _buildView() {
    return Obx(() {
      return ListView.separated(
        reverse: true,
        itemCount: controller.list.length,
        itemBuilder: (context, index) {
          return ListTileWidget(title: TextWidget.label(controller.list[index])).tight(height: 50);
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(
      init: AboutUsController(),
      id: "about_us",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(
            title: "关于我们",
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.all(5),
                child: IconWidget.icon(Icons.add, onTap: controller.add),
              ),
              PopupMenuButton<String>(
                icon: IconWidget.svg(
                  AssetsSvgs.icPostsMoreSvg,
                  color: Colors.black,
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w),
                ),
                onSelected: (value) {
                  if (value == 'logout') {
                    Loading.toast("注销成功");
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: TextWidget.body("注销"),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
