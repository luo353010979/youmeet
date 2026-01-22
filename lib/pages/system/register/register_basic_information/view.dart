import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class RegisterBasicInformationPage extends GetView<RegisterBasicInformationController> {
  const RegisterBasicInformationPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("RegisterBasicInformationPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterBasicInformationController>(
      init: RegisterBasicInformationController(),
      id: "register_basic_information",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
