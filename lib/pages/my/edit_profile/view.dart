import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("EditProfilePage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      id: "edit_profile",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("edit_profile")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
