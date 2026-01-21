import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PostDetalPage extends GetView<PostDetalController> {
  const PostDetalPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("PostDetalPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetalController>(
      init: PostDetalController(),
      id: "post_detal",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("post_detal")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
