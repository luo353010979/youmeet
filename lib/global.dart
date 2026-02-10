import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/services/upload.dart';

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

    // 初始化配置
    await ConfigService.to.init();
    await UploadService.to.init();
  }
}
