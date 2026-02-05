import 'package:get/get.dart';

import '../index.dart';

/// 用户服务
class UserService extends GetxService {
  static UserService get to => Get.find();

  // 是否登录
  final _isLogin = false.obs;

  // 用户令牌
  String token = '';

  // 用户的资料
  // final _profile = UserProfileModel().obs;

  /// 是否登录
  bool get isLogin => _isLogin.value;

  /// 用户 profile
  // UserProfileModel get profile => _profile.value;

  /// 是否有令牌 token
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // 读 token
    token = Storage().getString(Constants.storageToken);

    // 测试使用固定token
    if (token.isEmpty) {
      token =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3NzE2OTU2OTYsInVzZXJuYW1lIjoiNzc0MTM4Nzc1NDgyNzk4MDgwIn0.3aiFKwKtgc5_rssHUUZLc1AvEggPTjKhh0Ky5-c-KIM';
    }

    // 读 profile
    // var profileOffline = Storage().getString(Constants.storageProfile);
    // if (profileOffline.isNotEmpty) {
    //   //_profile(UserProfileModel.fromJson(jsonDecode(profileOffline)));
    // }
  }

  /// 设置令牌
  Future<void> setToken(String value) async {
    await Storage().setString(Constants.storageToken, value);
    token = value;
  }

  /// 获取用户 profile
  // Future<void> getProfile() async {
  //   if (token.isEmpty) return;
  //   UserProfileModel result = await UserApi.profile();
  //   _profile(result);
  //   _isLogin.value = true;

  //   Storage().setString(Constants.storageProfile, jsonEncode(result));
  // }

  /// 设置用户 profile
  // Future<void> setProfile(UserProfileModel profile) async {
  //   if (token.isEmpty) return;
  //   _isLogin.value = true;
  //   _profile(profile);
  //   Storage().setString(Constants.storageProfile, jsonEncode(profile));
  // }

  /// 注销
  // Future<void> logout() async {
  //   // if (_isLogin.value) await UserAPIs.logout();
  //   await Storage().remove(Constants.storageToken);
  //   _profile(UserProfileModel());
  //   _isLogin.value = false;
  //   token = '';
  // }

  /// 检查是否登录
  Future<bool> checkIsLogin() async {
    if (_isLogin.value == false) {
      await Get.toNamed(RouteNames.systemLogin);
      return false;
    }
    return true;
  }

  /// 用户注册
  Future<bool> register(UserRegisterReq data) async {
    try {
      Loading.show();
      BaseResponse<UserModel> response = await UserApi.register(data);
      if (response.success ?? false) {
        UserModel user = response.result!;
        token = user.token ?? '';
        await Storage().setString(Constants.storageToken, token);
        print("注册成功，用户 token: $token");
        return true;
      } else {
        Loading.error(response.message ?? '注册失败');
        throw Exception(response.message ?? 'Registration failed');
      }
    } catch (e) {
      rethrow;
    } finally {
      Loading.dismiss();
    }
  }

  Future<bool> login(UserLoginReq data) async {
    try {
      Loading.show();
      BaseResponse<UserModel> response = await UserApi.login(data);
      if (response.success ?? false) {
        UserModel user = response.result!;
        token = user.token ?? '';
        await Storage().setString(Constants.storageToken, token);
        print("登录成功，用户 token: $token");
        return true;
      } else {
        Loading.error(response.message ?? '登录失败');
        throw Exception(response.message ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    } finally {
      Loading.dismiss();
    }
  }
}
