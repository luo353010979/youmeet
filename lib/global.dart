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
    Get.put<WPHttpService>(WPHttpService());
    Get.put<UploadService>(UploadService());
    Get.put<UserService>(UserService());
    Get.put<MsgService>(MsgService());

    // 初始化配置
    await ConfigService.to.init();
  }
}
