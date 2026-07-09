import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class AboutUsController extends GetxController {
  AboutUsController();

  /// 版本号
  String get version => ConfigService.to.version;
}
