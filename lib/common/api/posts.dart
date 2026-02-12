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

  /// 推荐动态
  static Future<BaseResponse<String>> like(String pid) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/trendsComment/addLike",
      params: {"pid": pid},
    );

    return BaseResponse.fromJson(response.data, (data) => data.toString());
  }

  /// 根据ID查询动态详情
  static Future<BaseResponse<Record>> getPostDetail(String id) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/trends/queryById",
      params: {"id": id},
    );

    return BaseResponse.fromJson(
      response.data,
      (data) => Record.fromJson(data),
    );
  }
}
