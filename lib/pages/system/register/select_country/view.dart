import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class SelectCountryPage extends GetView<SelectCountryController> {
  const SelectCountryPage({super.key});

  /// 搜索框
  Widget _buildSearch() {
    return InputWidget(
      placeholder: LocaleKeys.searchCountry.tr,
      keyboardType: TextInputType.text,
      onChanged: controller.onSearch,
      prefix: Icon(Icons.search, size: 20.w, color: const Color(0xFF999999)),
      border: Border.all(color: const Color(0x1A000000)),
    ).paddingSymmetric(horizontal: 16.w, vertical: 12.w);
  }

  /// 国家列表
  Widget _buildList() {
    if (controller.countryList.isEmpty) {
      return Center(
        child: TextWidget.muted(LocaleKeys.commonSelectTips.tr),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const BouncingScrollPhysics(),
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
          title: TextWidget.body(controller.countryName(country)),
          trailing: [TextWidget.body(country.phone ?? "")],
          backgroundColor: Colors.transparent,
          onTap: () {
            Get.back(result: country);
          },
        ).tight(height: 50);
      },
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: const Color(0x1A000000)),
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildSearch(),
      Expanded(child: _buildList()),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectCountryController>(
      init: SelectCountryController(),
      id: "select_country",
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            title: LocaleKeys.selectCountry.tr,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
