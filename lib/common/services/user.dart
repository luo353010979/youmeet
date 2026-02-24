import 'dart:convert';

import 'package:get/get.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../index.dart';

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

  @override
  void onReady() {
    super.onReady();
    initWuKongIM();
  }

  @override
  void onClose() {
    super.onClose();
    WKIM.shared.connectionManager.disconnect(true);
    WKIM.shared.connectionManager.removeOnConnectionStatus(
      'connectionStatusListener',
    );
    WKIM.shared.messageManager.removeNewMsgListener('newMsgListener');
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
        Storage().setJson(
          Constants.storageProfile,
          jsonEncode(userMessage.toJson()),
        );

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
        print("登录成功，用户 token: $token");

        initWuKongIM();
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

  void initWuKongIM() {
    if (token.isEmpty) {
      print("没有 token，无法连接 IM");
      return;
    }

    Options options = Options.newDefault(profile.id ?? '', token);

    options.addr = Constants.wkImAddr;

    // 可选：开启调试模式
    options.debug = true;

    // 初始化 SDK
    WKIM.shared.setup(options);

    print('WuKongIM SDK 初始化完成');

    // 监听连接状态
    WKIM.shared.connectionManager.addOnConnectionStatus(
      'connectionStatusListener',
      (status, reason, connectInfo) {
        switch (status) {
          case WKConnectStatus.connecting:
            print('IM 连接中...');
            break;
          case WKConnectStatus.success:
            print('IM 连接成功，节点ID: ${connectInfo?.nodeId}');
            break;
          case WKConnectStatus.fail:
            print('IM 连接失败，原因: $reason');
            break;
          case WKConnectStatus.noNetwork:
            print('网络异常，无法连接');
            break;
          case WKConnectStatus.kicked:
            print('被踢下线（其他设备登录）');
            break;
          case WKConnectStatus.syncMsg:
            print('正在同步消息...');
            break;
          case WKConnectStatus.syncCompleted:
            print('消息同步完成');
            break;
        }
      },
    );

    setupMessageListeners();

    WKIM.shared.connectionManager.connect();
  }

  void setupMessageListeners() {
    // 监听新消息（消息刚收到，尚未保存到数据库）
    WKIM.shared.messageManager.addOnNewMsgListener('newMsgListener', (
      List<WKMsg> msg,
    ) {
      for (var m in msg) {
        print('收到新消息: ${m.messageID}, 内容: ${m.content}');
      }
    });

    // 监听消息插入数据库（消息已保存，可以刷新 UI）
    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      print('消息已保存到数据库: ${msg.messageID}');

      // 此时可以刷新聊天列表 UI
    });
  }
}
