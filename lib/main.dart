import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:youmeet/common/index.dart';

import 'global.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: ConfigService.to.themeMode,
      // debugShowFloatingThemeButton: true, // 调试模式显示切换按钮
      builder: (theme, darkTheme) => ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: false, // 支持分屏尺寸
        minTextAdapt: false, // 是否根据宽度/高度中的最小值来适配文字
        builder: (context, child) => GetMaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: RouteNames.systemSplash,
          getPages: RoutePages.list,
          navigatorObservers: [RoutePages.observers],
          // 多语言
          translations: Translation(), // 词典
          localizationsDelegates: Translation.localizationsDelegates, // 代理
          supportedLocales: Translation.supportedLocales, // 支持的语言种类
          locale: ConfigService.to.locale, // 当前语言种类
          fallbackLocale: Translation.fallbackLocale, // 默认语言种类
          // builder
          builder: (context, widget) {
            widget = EasyLoading.init()(context, widget);

            // 不随系统字体缩放比例
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget,
            );
          },

          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
