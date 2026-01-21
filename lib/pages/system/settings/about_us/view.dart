import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class AboutUsPage extends GetView<AboutUsController> {
  const AboutUsPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("AboutUsPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(
      init: AboutUsController(),
      id: "about_us",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("about_us")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
