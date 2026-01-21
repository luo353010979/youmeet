import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class RegisterIndexPage extends GetView<RegisterIndexController> {
  const RegisterIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("RegisterIndexPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterIndexController>(
      init: RegisterIndexController(),
      id: "register_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("register_index")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
