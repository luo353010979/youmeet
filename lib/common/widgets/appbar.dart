import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:youmeet/common/index.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final double height;

  const AppBarWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      leading: leading ?? _buildDefaultLeading(context),
      actions: actions,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      toolbarHeight: height,
    );
  }

  Widget? _buildDefaultLeading(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      return IconButton(
        onPressed: () => Get.back(),
        icon: ImageWidget.img(AssetsImages.icAppbarBackPng),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
