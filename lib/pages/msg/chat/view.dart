import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("ChatPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      id: "chat",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("chat")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
