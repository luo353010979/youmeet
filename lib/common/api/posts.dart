import 'package:youmeet/common/index.dart';

class PostApi {
  /// 推荐动态
  static Future<BaseResponse<FeedModel>> requestRecommendFeed(
    PostsReq data,
  ) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/homepage/recommendTrends",
      params: data.toJson(),
    );

    return BaseResponse.fromJson(
      response.data,
      (data) => FeedModel.fromJson(data),
    );
  }
}
