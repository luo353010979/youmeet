import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class EditProfileInfoPage extends GetView<EditProfileInfoController> {
  const EditProfileInfoPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("EditProfileInfoPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileInfoController>(
      init: EditProfileInfoController(),
      id: "edit_profile_info",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("edit_profile_info")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
