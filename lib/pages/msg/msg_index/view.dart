import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/wkim.dart';
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
    return EasyRefresh(
      controller: controller.refreshController,
      // onRefresh: controller.onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpace.page.w),
        itemCount: controller.msgConversation.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final conversation = controller.msgConversation[index];
          return _buildConversationItem(conversation);
        },
        separatorBuilder: (context, index) => Divider(height: 1.h),
      ),
    );
  }

  /// 构建会话列表项
  Widget _buildConversationItem(
    MsgConversation conversation,
  ) {
    final channel = conversation.wkChannel;
    final msg = conversation.wkMsg;

    String title = channel?.channelName ?? '未知';
    String avatar = channel?.avatar.isNotEmpty == true
        ? 'http://${channel?.avatar}'
        : '';
    String lastMessage = msg?.messageContent?.displayText() ?? "";

    int unreadCount = conversation.unreadCount;

    // 格式化时间
    String timeStr = DateUtil.formatDateMs(conversation.lastMsgTimestamp * 1000);

    return ListTileWidget(
      backgroundColor: Colors.transparent,
      leading: ImageWidget.img(
        avatar.isNotEmpty ? avatar : AssetsImages.imgMsgAvaterPng,
        width: 40.w,
        height: 40.w,
        radius: 50,
        fit: BoxFit.cover,
      ),
      title: TextWidget.label(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: TextWidget.muted(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: [
        <Widget>[
          TextWidget.muted(timeStr),
          const SizedBox(height: 4),
          if (unreadCount > 0)
            Badge(
              backgroundColor: Colors.red,
              label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
              textStyle: TextStyle(fontSize: 8, color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            ),
        ].toColumn(),
      ],
      onTap: () => controller.toChatPage(conversation.channelID),
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: [
              IconWidget.svg(
                AssetsSvgs.icMsgSettingSvg,
                onTap: () {},
              ).paddingOnly(right: 16),
            ],
          ),
          child: _buildView(context),
        );
      },
    );
  }
}
