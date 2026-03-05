import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:easy_refresh/easy_refresh.dart';
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
    return controller.conversations.isEmpty
        ? const Center(child: Text('暂无消息'))
        : EasyRefresh(
            controller: controller.refreshController,
            // onRefresh: controller.onRefresh,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: AppSpace.page.w),
              itemCount: controller.conversations.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final conversation = controller.conversations[index];
                final item = controller.getParsedConversation(conversation);
                return _buildConversationItem(conversation, item);
              },
              separatorBuilder: (context, index) => Divider(height: 1.h),
            ),
          );
  }

  /// 构建会话列表项
  Widget _buildConversationItem(
    WKUIConversationMsg conversation,
    MsgConversation? item,
  ) {
    String title = item?.title ?? '未知';
    String avatar = item?.avatar.isNotEmpty == true
        ? 'http://${item?.avatar}'
        : '';
    String lastMessage = item?.lastMessage ?? '';
    int unreadCount = conversation.unreadCount;

    // 格式化时间
    String timeStr = formatTimestamp(conversation.lastMsgTimestamp);

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
      onTap: () {
        WKIM.shared.conversationManager.updateRedDot(conversation.channelID, conversation.channelType, 0);
        Get.toNamed(
          RouteNames.msgChat,
          arguments: {"conversation": conversation, "item": item},
        );
      },
    );
  }

  /// 格式化时间戳
  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    // 今天
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    // 昨天
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return '昨天';
    }

    // 本周
    if (now.difference(dateTime).inDays < 7) {
      return '周${dateTime.weekday}';
    }

    // 其他：显示日期
    return '${dateTime.month}/${dateTime.day}';
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
