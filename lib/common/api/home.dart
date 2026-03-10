import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/models/home_data_model/home_data_model.dart';

class HomeApi {
  /// 获取推荐列表
  static Future<BaseResponse<HomeDataModel>> getRecommendList(PostsReq req, {required String path}) async {
    final response = await WPHttpService.to.get("/jeecg-boot/api/ym/$path", params: req.toJson());

    return BaseResponse.fromJson(response.data, (data) => HomeDataModel.fromJson(data));
  }

  /// 获取单个匹配用户
  static Future<BaseResponse<UserMessage>> getMatch({String latitude = "0", String longitude = "0"}) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/ym/getMatch",
      params: {"latitude": latitude, "longitude": longitude},
    );

    return BaseResponse.fromJson(response.data, (data) => UserMessage.fromJson(data));
  }
}
