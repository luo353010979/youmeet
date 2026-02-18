import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class SelectLanguagePage extends GetView<SelectLanguageController> {
  const SelectLanguagePage({super.key});

  // 主视图
  Widget _buildView() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.languages.length,
      itemBuilder: (context, index) {
        final language = controller.languages[index];
        return ListTileWidget(
          title: TextWidget.label(language),
          onTap: () => controller.onTap(language),
        ).tight(height: 50.w);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectLanguageController>(
      init: SelectLanguageController(),
      id: "select_language",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(
            title: LocaleKeys.selectLanguage.tr,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
