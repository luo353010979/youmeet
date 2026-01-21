import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/routers/observers.dart';
import 'package:youmeet/pages/index.dart';

class RoutePages {
  static List<String> history = [];
  static RouteObservers observers = RouteObservers();
  // 列表
  static List<GetPage> list = [
    GetPage(name: RouteNames.msgChat, page: () => const ChatPage()),
    GetPage(name: RouteNames.systemLogin, page: () => const LoginPage()),
    GetPage(name: RouteNames.systemRegister, page: () => const RegisterPage()),
    GetPage(name: RouteNames.systemSplash, page: () => const SplashPage()),
    GetPage(name: RouteNames.systemWelcome, page: () => const WelcomePage()),
  ];
}
