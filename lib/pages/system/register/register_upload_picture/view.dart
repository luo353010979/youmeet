import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class RegisterUploadPicturePage extends GetView<RegisterUploadPictureController> {
  const RegisterUploadPicturePage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("RegisterUploadPicturePage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterUploadPictureController>(
      init: RegisterUploadPictureController(),
      id: "register_upload_picture",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("register_upload_picture")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
