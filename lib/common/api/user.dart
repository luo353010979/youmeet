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
}
