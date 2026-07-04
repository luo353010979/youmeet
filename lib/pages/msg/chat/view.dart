import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return Obx(() {
      return CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          if (controller.isComplete.value) _buildUserInfoCard(),
          if (controller.isComplete.value) _buildUploadCard(),
          _buildMessageList(),
        ],
      );
    });
  }

  /// 消息列表
  Widget _buildMessageList() {
    return Obx(() {
      // 在 Obx 同步作用域内读取，注册依赖：
      // itemBuilder 是延迟回调，Obx 不会追踪其中读到的可观察量，
      // 所以对方头像必须在这里读出来再传进去，加载完成后列表才会重建。
      final peerPortrait = controller.userMessage.value.portrait ?? "";
      return EasyRefresh(
        controller: controller.refreshController,
        onLoad: controller.onLoad,
        child: ListView.separated(
          padding: EdgeInsets.all(16.w),
          shrinkWrap: true,
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            return msgWidget(message, peerPortrait);
          },
          separatorBuilder: (context, index) => SizedBox(height: 24.w),
        ),
      ).sliverToBoxAdapter();
    });
  }

  Widget msgWidget(WKMsg message, String peerPortrait) {
    // 用 fromUID 判断是不是自己发的（可靠，getFrom() 常为空）
    final isSelf = message.fromUID == UserService.to.profile.id;
    // 自己的消息用自己的头像，对方的用聊天对象头像
    final portrait = isSelf
        ? (UserService.to.profile.portrait ?? "")
        : peerPortrait;
    final content = message.messageContent?.content ?? "";

    return <Widget>[
      _avatarWidget(portrait).onTap(() {
        // 只有点对方头像才进对方资料页
        if (!isSelf) {
          Get.toNamed(
            RouteNames.homeMatchingDetail,
            arguments: MsgService.to.userMap[message.channelID],
          );
        }
      }),
      10.horizontalSpace,
      TextWidget.label(
            content,
            weight: FontWeight.bold,
            color: isSelf ? Colors.white : null,
          )
          .padding(horizontal: 12.w, vertical: 8.w)
          .backgroundColor(isSelf ? const Color(0xFFF2A3D6) : Colors.white)
          .clipRRect(all: 8)
          .constrained(maxWidth: 220.w),
    ].toRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      // 自己靠右，对方靠左
      textDirection: isSelf ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  /// 头像 URL 兜底：portrait 为空/null 时返回空串，避免拼出 http://null 去发起请求
  String _avatarUrl(String? portrait) {
    if (portrait == null || portrait.isEmpty) return "";
    if (portrait.startsWith("http")) return portrait;
    return "http://$portrait";
  }

  /// 头像组件：无有效地址时直接显示占位图标，不发起网络请求
  Widget _avatarWidget(String? portrait, {double size = 40}) {
    final fallback = Icon(
      Icons.account_circle,
      size: size.w,
      color: const Color(0xFFCCCCCC),
    );
    final url = _avatarUrl(portrait);
    if (url.isEmpty) {
      return SizedBox(width: size.w, height: size.w, child: fallback);
    }
    return ImageWidget.img(
      url,
      width: size.w,
      height: size.w,
      fit: BoxFit.cover,
      radius: size / 2,
      errorWidget: fallback,
    );
  }

  /// 输入栏
  Widget _buildInputBar() {
    return <Widget>[
          // IconButton(
          //   onPressed: () {},
          //   icon: ImageWidget.img(AssetsImages.imgMsgMicophonePng, width: 28.r),
          // ),
          InputWidget(
            placeholder: LocaleKeys.content.tr,
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(color: Color(0xFFF1F1F1), width: 1),
            onSubmitted: (value) => controller.sendMessage(value),
          ).tight(width: 300.w, height: 44.w),

          // IconButton(
          //   onPressed: () {},
          //   icon: IconWidget.svg(AssetsSvgs.icMsgCameraSvg, size: 24.r),
          // ),
          IconWidget.svg(AssetsSvgs.icMsgAddSvg, size: 24.r, fit: BoxFit.cover),
        ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingHorizontal(16.w)
        .constrained(height: 60.w)
        .backgroundColor(Colors.white);
  }

  Widget _buildUserInfoCard() {
    return Obx(() {
      final user = controller.userMessage.value;
      return Card(
        elevation: 4,
        child: <Widget>[
          ListTileWidget(
            padding: EdgeInsets.zero,
            leading: _avatarWidget(user.portrait),
            title: TextWidget.body(user.name ?? "", weight: FontWeight.bold),
            trailing: [
              Container(
                width: 77.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetsImages.imgMsgBgPng),
                    fit: BoxFit.cover,
                  ),
                ),
                child: TextWidget.label(
                  LocaleKeys.report.tr,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ).tight(height: 44.w),

          SizedBox(height: 8.w),

          controller.types
              .map((type) {
                return <Widget>[
                      IconWidget.svg(
                        type.icon,
                        size: 26,
                        text: type.title,
                        isVertical: true,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        space: 0,
                      ),
                      4.verticalSpace,
                      ButtonWidget.primary(
                        LocaleKeys.check.tr,
                        width: 64.w,
                        height: 22.w,
                        fontSize: 11,
                        textWeight: FontWeight.w500,
                        textColor: Color(0xFF666666),
                        backgroundColor: Color(0xFFE1E1E1),
                        onTap: () {
                          logger.d("申请查看 ${type.title}");
                        },
                      ),
                    ]
                    .toColumn(mainAxisAlignment: MainAxisAlignment.center)
                    .tight(width: 95.w, height: 97.w)
                    .decorated(
                      color: Color(0xFFF4F3F3),
                      borderRadius: BorderRadius.circular(8),
                    );
              })
              .toList()
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .expanded(),
        ].toColumn().paddingSymmetric(horizontal: 14.w, vertical: 10.w),
      ).tight(height: 169.w).paddingHorizontal(14.w).sliverToBoxAdapter();
    });
  }

  Widget _buildUploadCard() {
    final realPic = controller.displayRealPic;
    final payTaxesPic = controller.displayPayTaxesPic;
    final creditPic = controller.displayCreditPic;

    return Card(
          elevation: 4,
          child:
              <Widget>[
                    TextWidget.body(
                      LocaleKeys.uploadReport.tr,
                      weight: FontWeight.bold,
                    ),

                    <Widget>[
                      _buildUploadCell(
                        LocaleKeys.loveFourTitle1.tr,
                        1,
                        realPic,
                      ),
                      _buildUploadCell(
                        LocaleKeys.loveFourTitle2.tr,
                        2,
                        payTaxesPic,
                      ),
                      _buildUploadCell(
                        LocaleKeys.loveFourTitle3.tr,
                        3,
                        creditPic,
                      ),
                    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),

                    ButtonWidget.primary(
                      LocaleKeys.complete.tr,
                      height: 32.w,
                      onTap: controller.onComplete,
                    ),
                  ]
                  .toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .paddingSymmetric(horizontal: 14.w, vertical: 10.w),
        )
        .tight(width: 343.w, height: 165.w)
        .paddingHorizontal(14.w)
        .sliverToBoxAdapter();
  }

  Widget _buildUploadCell(String title, int id, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ImageWidget.img(
        imageUrl,
        width: 95.w,
        height: 71.w,
        fit: BoxFit.cover,
      ).onTap(() {
        controller.pickImage(id);
      });
    }

    return _buildUploadItem(title, id);
  }

  Widget _buildUploadItem(String title, int id) {
    return <Widget>[
          ImageWidget.img(
            AssetsImages.imgMsgUploadPng,
            width: 32.w,
            height: 30.w,
          ),

          TextWidget.label(title, weight: FontWeight.bold),
        ]
        .toColumnSpace(mainAxisAlignment: MainAxisAlignment.center, space: 4.w)
        .tight(width: 95.w, height: 71.w)
        .decorated(
          color: Color(0xFFF4F3F3),
          borderRadius: BorderRadius.circular(8.w),
        )
        .onTap(() {
          controller.pickImage(id);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      id: "chat",
      builder: (_) {
        return ScaffoldWidget(
          useSafeArea: true,
          appBar: AppBarWidget(
            title: controller.userMessage.value.name ?? "",
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
          bottomNavigationBar: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(child: _buildInputBar()),
          ),
          child: Stack(
            children: [
              _buildView(context),
              _buildNewMsgTip(),
            ],
          ),
        );
      },
    );
  }

  /// 底部中间"新消息 ↓"提示气泡：翻看历史时收到新消息才出现，点击回到最新
  Widget _buildNewMsgTip() {
    return Obx(() {
      if (!controller.showNewMsgTip.value) return const SizedBox.shrink();
      return Positioned(
        left: 0,
        right: 0,
        bottom: 16.w,
        child: Center(
          child:
              <Widget>[
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18.w,
                      color: const Color(0xFFF2A3D6),
                    ),
                    4.horizontalSpace,
                    TextWidget.label(
                      "新消息",
                      color: const Color(0xFF666666),
                      weight: FontWeight.w500,
                    ),
                  ]
                  .toRow(mainAxisSize: MainAxisSize.min)
                  .paddingSymmetric(horizontal: 14.w, vertical: 7.w)
                  .decorated(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  )
                  .onTap(() => controller.scrollToBottom()),
        ),
      );
    });
  }
}
