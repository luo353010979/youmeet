import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import '../index.dart';

/// 列表项
class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.leadingSpace,
    this.trailing,
    this.trailingSpace,
    this.titleSubtitleSpace,
    this.padding,
    this.crossAxisAlignment,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.borderWidth,
    this.elevation,
    this.backgroundColor,
    this.isRipple = true,
  });

  /// 标题
  final Widget? title;

  /// 子标题
  final Widget? subtitle;

  /// 左侧图标
  final Widget? leading;

  /// 左侧图标间距
  final double? leadingSpace;

  /// 右侧图标
  final List<Widget>? trailing;

  final double? titleSubtitleSpace;

  /// 右侧图标间距
  final double? trailingSpace;

  /// padding 边框间距
  final EdgeInsetsGeometry? padding;

  /// cross 对齐方式
  final CrossAxisAlignment? crossAxisAlignment;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  /// 圆角
  final double? borderRadius;

  /// 边框
  final double? borderWidth;

  /// 阴影
  final double? elevation;

  /// 背景色
  final Color? backgroundColor;

  /// 是否涟漪效果
  final bool? isRipple;

  // 主视图
  Widget _buildView(BuildContext context) {
    List<Widget> ws = [];

    // 左侧图标
    if (leading != null) {
      ws.add(leading!);
      // 左侧间距
      ws.add(SizedBox(width: leadingSpace ?? AppSpace.column));
    }

    // 标题，子标题
    if (title != null || subtitle != null) {
      var titleList = [
        if (title != null) title!,
        if (subtitle != null) subtitle!,
      ];
      ws.add(
        titleList.length == 1
            ? titleList.first.expanded()
            : titleList
                  .toColumnSpace(
                    crossAxisAlignment:
                        crossAxisAlignment ?? CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    space: titleSubtitleSpace ?? 0,
                  )
                  .expanded(),
      );
    }

    // 左侧图标
    if (trailing != null) {
      // 右侧间距
      if (trailingSpace != null) {
        ws.add(SizedBox(width: trailingSpace));
      }

      // 右侧图标
      ws.add(
        trailing!.length == 1
            ? trailing!.first
            : trailing!.toRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
              ),
      );
    }

    // 背景、圆角、边框
    Widget child = ws
        .toRow(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        )
        .padding(
          horizontal: padding?.horizontal ?? AppPadding.listTile.horizontal,
          vertical: padding?.vertical ?? AppPadding.listTile.vertical,
        );

    // 涟漪, 点击事件
    if (onTap != null && isRipple == true) {
      child = child.ripple();
    }

    // 背景、圆角、边框
    if (borderWidth != null && borderWidth! > 0) {
      child = child.decorated(
        color: backgroundColor ?? context.colors.scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.listTile),
        border: Border.all(
          color: context.colors.primary,
          width: borderWidth ?? AppBorder.listTile,
        ),
      );
    } else {
      child = child.decorated(
        color: backgroundColor ?? context.colors.scheme.surface,
      );
    }

    // 裁切圆形, 点击事件，把涟漪一起切成圆形
    if (onTap != null) {
      child = child.clipRRect(all: borderRadius ?? AppRadius.listTile);
    }

    // 阴影
    if (elevation != null && elevation! > 0) {
      child = child.elevation(
        elevation ?? AppElevation.listTile,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.listTile),
        shadowColor: context.colors.shadow,
      );
    }

    // 点击事件
    if (onTap != null || onLongPress != null) {
      child = child.gestures(onTap: onTap, onLongPress: onLongPress);
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}
