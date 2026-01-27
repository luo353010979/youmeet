import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class PostsIndexPage extends GetView<PostsIndexController> {
  const PostsIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(child: Text("PostsIndexPage"));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsIndexController>(
      init: Get.find<PostsIndexController>(),
      id: "posts_index",
      builder: (_) {
        return ScaffoldWidget(
          useSafeArea: true,
          appBar: AppBarWidget(
            title: "圈子",
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: IconWidget.svg(AssetsSvgs.icPostsSearchSvg),
              ),
              IconButton(
                onPressed: () {},
                icon: IconWidget.svg(AssetsSvgs.icPostsMoreSvg),
              ),
            ],
          ),
          child: _buildView(),
        );
      },
    );
  }
}
