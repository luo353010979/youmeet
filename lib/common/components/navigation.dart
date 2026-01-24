import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 导航栏数据模型
class NavigationItemModel {
  final String label;
  final String icon;
  final String? activeIcon; // 选中状态的图标
  final int count;

  NavigationItemModel({
    required this.label,
    required this.icon,
    this.activeIcon, // 可选参数，如果不传则使用默认图标
    this.count = 0,
  });
}

/// 导航栏
class BuildNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavigationItemModel> items;
  final Function(int) onTap;

  const BuildNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var ws = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      var isActive = i == currentIndex;
      var color = isActive ? Color(0xFF272D36) : Color(0xFFADB9CD);
      var item = items[i];
      // 根据是否选中来决定使用哪个图标
      var displayIcon = isActive && item.activeIcon != null
          ? item.activeIcon!
          : item.icon;

      ws.add(
        <Widget>[
              // 图标
              IconWidget.svg(
                displayIcon,
                width: 24,
                height: 24,
                // color: color,
                // badgeString: item.count > 0 ? item.count.toString() : null,
              ).paddingBottom(2),
              // 文字
              TextWidget.label(item.label.tr, color: color),
            ]
            .toColumn(
              mainAxisAlignment: MainAxisAlignment.center, // 居中
              mainAxisSize: MainAxisSize.max, // 最大
            )
            .onTap(() => onTap(i))
            .expanded(),
      );
    }
    return BottomAppBar(
      color: context.colors.scheme.surface,
      elevation: 2,
      child: ws
          .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .height(kBottomNavigationBarHeight),
    );
  }
}
