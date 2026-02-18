import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class MsgIndexPage extends GetView<MsgIndexController> {
  const MsgIndexPage({super.key});

  /// 搜索框
  Widget _buildSearchBar() {
    return InputWidget(
      prefix: IconWidget.svg(AssetsSvgs.icMsgSearchSvg),
      placeholder: LocaleKeys.search.tr,
    ).paddingSymmetric(horizontal: 16.w, vertical: 10.h);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[_buildSearchBar(), _buildMsgList().expanded()].toColumn();
  }

  Widget _buildMsgList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppSpace.page.w),
      itemCount: 5,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTileWidget(
          padding: EdgeInsets.zero,
          leading: ImageWidget.img(AssetsImages.imgMsgAvaterPng),
          title: TextWidget.label('昵称 $index'),
          subtitle: TextWidget.muted('这是消息的简要内容预览。'),
          backgroundColor: Colors.transparent,
          trailing: [
            <Widget>[
              TextWidget.muted("12:34"),
              Badge.count(count: 1),
            ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
          ],
          onTap: () {
            // 点击消息项的处理逻辑
          },
        ).tight(height: 60.h);
      },
      separatorBuilder: (context, index) => Divider(height: 1.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MsgIndexController>(
      init: Get.find<MsgIndexController>(),
      id: "msg_index",
      builder: (_) {
        return ScaffoldWidget(
          appBar: AppBarWidget(
            title: LocaleKeys.message.tr,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            actions: [
              IconWidget.svg(
                AssetsSvgs.icMsgSettingSvg,
                onTap: () {
                  print("消息设置");
                },
              ).paddingOnly(right: 16),
            ],
          ),
          child: _buildView(context),
        );
      },
    );
  }
}
