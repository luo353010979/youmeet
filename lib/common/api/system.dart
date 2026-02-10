import 'package:youmeet/common/index.dart';

class SystemApi {
  /// 获取国家列表
  static Future<BaseResponse<List<CountryModel>>> requestCountryList() async {
    final response = await WPHttpService.to.get(
      '/jeecg-boot/api/login/getCountyInfo',
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => (data as List).map((e) => CountryModel.fromJson(e)).toList(),
    );
  }

  /// 获取七牛云上传 token
  static Future<BaseResponse<QiNiuTokenModel>> requestQiniuToken() async {
    final response = await WPHttpService.to.get(
      '/jeecg-boot/api/trends/getToken',
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => QiNiuTokenModel.fromJson(data),
    );
  }
}
