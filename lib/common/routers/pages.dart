import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/routers/observers.dart';
import 'package:youmeet/pages/index.dart';

class RoutePages {
  static List<String> history = [];
  static RouteObservers observers = RouteObservers();
  // 列表
  static List<GetPage> list = [

      GetPage(
        name: RouteNames.homeHomeIndex,
        page: () => const HomeIndexPage(),
      ),
      GetPage(
        name: RouteNames.homeMatchingDetail,
        page: () => const MatchingDetailPage(),
      ),
      GetPage(
        name: RouteNames.msgChat,
        page: () => const ChatPage(),
      ),
      GetPage(
        name: RouteNames.msgMsgIndex,
        page: () => const MsgIndexPage(),
      ),
      GetPage(
        name: RouteNames.myEditProfile,
        page: () => const EditProfilePage(),
      ),
      GetPage(
        name: RouteNames.myEditProfileInfo,
        page: () => const EditProfileInfoPage(),
      ),
      GetPage(
        name: RouteNames.myMyIndex,
        page: () => const MyIndexPage(),
      ),
      GetPage(
        name: RouteNames.postsPostsIndex,
        page: () => const PostsIndexPage(),
      ),
      GetPage(
        name: RouteNames.postsPostDetal,
        page: () => const PostDetalPage(),
      ),
      GetPage(
        name: RouteNames.systemLogin,
        page: () => const LoginPage(),
      ),
      GetPage(
        name: RouteNames.systemMain,
        page: () => const MainPage(),
        binding: MainBinding()
      ),
      GetPage(
        name: RouteNames.systemRegisterRegisterBasicInformation,
        page: () => const RegisterBasicInformationPage(),
      ),
      GetPage(
        name: RouteNames.systemRegisterRegisterIndex,
        page: () => const RegisterIndexPage(),
      ),
      GetPage(
        name: RouteNames.systemRegisterRegisterUploadPicture,
        page: () => const RegisterUploadPicturePage(),
      ),
      GetPage(
        name: RouteNames.systemSettingsAboutUs,
        page: () => const AboutUsPage(),
      ),
      GetPage(
        name: RouteNames.systemSettingsPrivacyAgreement,
        page: () => const PrivacyAgreementPage(),
      ),
      GetPage(
        name: RouteNames.systemSettingsSettingsIndex,
        page: () => const SettingsIndexPage(),
      ),
      GetPage(
        name: RouteNames.systemSettingsUserAgreement,
        page: () => const UserAgreementPage(),
      ),
      GetPage(
        name: RouteNames.systemSplash,
        page: () => const SplashPage(),
      ),
      GetPage(
        name: RouteNames.systemWelcome,
        page: () => const WelcomePage(),
      ),
  ];
}
