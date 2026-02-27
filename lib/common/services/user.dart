import 'dart:convert';

import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

/// 用户服务
class UserService extends GetxService {
  static UserService get to => Get.find();

  // 用户令牌
  String token = '';

  // 用户的资料
  final _profile = UserMessage().obs;

  /// 用户 profile
  UserMessage get profile => _profile.value;

  /// 是否有令牌 token
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // 读 token
    token = Storage().getString(Constants.storageToken);

    // 读 profile
    var profileOffline = Storage().getString(Constants.storageProfile);
    if (profileOffline.isNotEmpty) {
      _profile(UserMessage.fromJson(jsonDecode(profileOffline)));
    }
  }

  /// 设置令牌
  Future<void> setToken(String value) async {
    await Storage().setString(Constants.storageToken, value);
    token = value;
  }

  /// 获取用户 profile
  Future<void> getProfile() async {
    if (token.isEmpty) return;
    BaseResponse<UserMessage> response = await UserApi.profile();
    var userMessage = response.result;
    _profile(userMessage);
    Storage().setString(
      Constants.storageProfile,
      jsonEncode(userMessage?.toJson()),
    );
  }

  /// 编辑用户 profile
  Future<void> setProfile(UserMessage profile) async {
    if (token.isEmpty) return;
    await UserApi.editProfile(profile);
    _profile(profile);
    Storage().setString(Constants.storageProfile, jsonEncode(profile.toJson()));
  }

  /// 注销
  Future<void> logout() async {
    // if (_isLogin.value) await UserAPIs.logout();
    await Storage().remove(Constants.storageToken);
    _profile(UserMessage());
    token = '';
    Get.offAllNamed(RouteNames.systemLogin);
  }

  /// 检查是否登录
  bool checkIsLogin() {
    return hasToken;
  }

  /// 用户注册
  Future<bool> register(UserRegisterReq data) async {
    try {
      Loading.show();
      BaseResponse<UserModel?> response = await UserApi.register(data);
      if (response.success) {
        UserModel? user = response.result;
        token = user?.token ?? '';
        Storage().setString(Constants.storageToken, token);

        UserMessage userMessage = user?.userMessage ?? UserMessage();
        Storage().setString(
          Constants.storageProfile,
          jsonEncode(userMessage.toJson()),
        );
        _profile(userMessage);
        MsgService.to.init();
        print("注册成功，用户 token: $token");
        return true;
      } else {
        Loading.error(response.message);
        // Get.snackbar("注册失败", response.message);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      Loading.dismiss();
    }
  }

  Future<bool> login(UserLoginReq data) async {
    try {
      Loading.show();
      BaseResponse<UserModel> response = await UserApi.login(data);
      if (response.success) {
        UserModel? user = response.result;
        token = user?.token ?? '';

        Storage().setString(Constants.storageToken, token);

        UserMessage userMessage = user?.userMessage ?? UserMessage();
        Storage().setString(
          Constants.storageProfile,
          jsonEncode(userMessage.toJson()),
        );
        _profile(userMessage);
        MsgService.to.init();
        print("登录成功，用户 token: $token");
        return true;
      } else {
        Loading.error(response.message);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      Loading.dismiss();
    }
  }
}
