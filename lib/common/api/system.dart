import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/models/qiniu_token_model.dart';

class SystemApi {
  /// 获取国家列表
  static Future<BaseResponse<List<CountryModel>>> getCountryList() async {
    final response = await WPHttpService.to.get(
      '/jeecg-boot/api/login/getCountyInfo',
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => (data as List).map((e) => CountryModel.fromJson(e)).toList(),
    );
  }

  /// 获取七牛云上传 token
  static Future<BaseResponse<QiNiuTokenModel>> getQiNiuToken() async {
    final response = await WPHttpService.to.get(
      '/jeecg-boot/api/trends/getToken',
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => QiNiuTokenModel.fromJson(data),
    );
  }
}
