import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(child: Text("MyIndexPage"));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      init: Get.find<MyIndexController>(),
      id: "my_index",
      builder: (_) {
        return ScaffoldWidget(
          useSafeArea: true,
          appBar: AppBarWidget(title: "我的"),
          child: _buildView(),
        );
      },
    );
  }
}
