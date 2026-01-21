import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PrivacyAgreementPage extends GetView<PrivacyAgreementController> {
  const PrivacyAgreementPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("PrivacyAgreementPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyAgreementController>(
      init: PrivacyAgreementController(),
      id: "privacy_agreement",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("privacy_agreement")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
