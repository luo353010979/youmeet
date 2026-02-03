import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/widgets/index.dart';

import 'index.dart';

class SelectCountryPage extends GetView<SelectCountryController> {
  const SelectCountryPage({super.key});

  // 主视图
  Widget _buildView() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: BouncingScrollPhysics(),
      itemCount: controller.countryList.length,
      itemBuilder: (context, index) {
        final country = controller.countryList[index];
        return ListTileWidget(
          padding: EdgeInsets.zero,
          leading: ImageWidget.img(
            "http://${country.nationalFlag}",
            width: 40.r,
            height: 30.r,
            fit: BoxFit.cover,
            radius: 0,
          ),
          title: TextWidget.body(country.chinese ?? ""),
          trailing: [TextWidget.body(country.phone ?? "")],
          backgroundColor: Colors.transparent,
          onTap: () {
            Get.back(result: country);
          },
        ).tight(height: 50);
      },
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: Color(0x1A000000)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectCountryController>(
      init: SelectCountryController(),
      id: "select_country",
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(title: "选择国家", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
