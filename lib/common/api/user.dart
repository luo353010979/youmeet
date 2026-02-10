import 'package:youmeet/common/index.dart';

class UserApi {
  /// 用户注册
  static Future<BaseResponse<UserModel>> register(UserRegisterReq data) async {
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/txs/registered",
      data: data.toJson(),
    );

    return BaseResponse.fromJson(
      response.data,
      (data) => UserModel.fromJson(data),
    );
  }

  /// 用户登录
  static Future<BaseResponse<UserModel>> login(UserLoginReq data) async {
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/txs/login",
      data: data.toJson(),
    );

    return BaseResponse.fromJson(
      response.data,
      (data) => UserModel.fromJson(data),
    );
  }

  /// 获取用户信息
  static Future<BaseResponse<UserMessage>> profile({String? id}) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/userUp/getUserMessage",
      params: {"id": id},
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => UserMessage.fromJson(data),
    );
  }

  /// 编辑用户信息
  static Future<BaseResponse<String>> editProfile(
    UserMessage userMessage,
  ) async {
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/userUp/edit",
      data: userMessage.toJson(),
    );
    return BaseResponse.fromJson(response.data, (data) => data as String);
  }

  /// 用户动态
  static Future<BaseResponse<MyFeedModel>> getMyFeed({
    String? userId,
  }) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/trends/myPageList",
      params: {"userId": userId},
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => MyFeedModel.fromJson(data),
    );
  }
}
