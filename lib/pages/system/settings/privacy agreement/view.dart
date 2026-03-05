import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class PrivacyAgreementPage extends GetView<PrivacyAgreementController> {
  const PrivacyAgreementPage({super.key});

  // 主视图
  Widget _buildView() {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: controller.controller);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyAgreementController>(
      init: PrivacyAgreementController(),
      id: "privacy_agreement",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(title: "隐私协议", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
