import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class AboutUsPage extends GetView<AboutUsController> {
  const AboutUsPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(child: Text("AboutUsPage"));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(
      init: AboutUsController(),
      id: "about_us",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(title: "关于我们", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
