import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PostsIndexPage extends GetView<PostsIndexController> {
  const PostsIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("PostsIndexPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsIndexController>(
      init: PostsIndexController(),
      id: "posts_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("posts_index")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
