import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SettingsIndexPage extends GetView<SettingsIndexController> {
  const SettingsIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("SettingsIndexPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsIndexController>(
      init: SettingsIndexController(),
      id: "settings_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("settings_index")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
