import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class UserAgreementPage extends GetView<UserAgreementController> {
  const UserAgreementPage({super.key});

  // 主视图
  Widget _buildView() {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return controller.controller != null ? WebViewWidget(controller: controller.controller) : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserAgreementController>(
      init: UserAgreementController(),
      id: "user_agreement",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(title: "用户协议", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
