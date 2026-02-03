import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/index.dart';

class Global {
  static Future<void> init() async {
    // 插件初始化
    WidgetsFlutterBinding.ensureInitialized();

    await Storage().init();
    Loading();

    Get.put<ConfigService>(ConfigService());
    Get.put<WPHttpService>(WPHttpService()); // 用户

    // 初始化配置
    await ConfigService.to.init();
  }
}
