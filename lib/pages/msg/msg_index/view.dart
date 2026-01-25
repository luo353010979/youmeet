import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class MsgIndexPage extends GetView<MsgIndexController> {
  const MsgIndexPage({super.key});

  Widget _buildAppBar() {
    return AppBarWidget(
      title: "消息",
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
    );
  }

  /// 搜索框
  Widget _buildSearchBar() {
    return InputWidget(
      prefix: IconWidget.svg(AssetsSvgs.icMsgSearchSvg),
      placeholder: "请输入关键字搜索",
    ).paddingHorizontal(16.w);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      _buildAppBar(),
      _buildSearchBar(),
      _buildMsgList().expanded(),
    ].toColumn();
  }

  Widget _buildMsgList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppSpace.page.w),
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTileWidget(
          leading: CircleAvatar(backgroundColor: Colors.grey, radius: 24.r),
          title: TextWidget.label('昵称 $index'),
          subtitle: TextWidget.muted('这是消息的简要内容预览。'),
          backgroundColor: Colors.transparent,
          trailing: [
            <Widget>[
              TextWidget.muted("12:34"),
              Badge.count(count: 1),
            ].toColumnSpace(
              space: 5.h,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
          onTap: () {
            // 点击消息项的处理逻辑
          },
        ).tight(height: 74.h);
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
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsImages.imgBackgroundDefautPng),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(child: _buildView(context)),
          ),
        );
      },
    );
  }
}
