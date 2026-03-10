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

  /// 点赞、取消点赞
  static Future<BaseResponse<String>> like(String pid) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/trendsComment/addLike",
      params: {"pid": pid},
    );

    return BaseResponse.fromJson(response.data, (data) => data.toString());
  }

  /// 根据ID查询动态详情
  static Future<BaseResponse<Feed>> getPostDetail(String id) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/trends/queryById",
      params: {"id": id},
    );

    return BaseResponse.fromJson(response.data, (data) => Feed.fromJson(data));
  }

  /// 根据动态ID查询评论列表
  static Future<BaseResponse<CommentModel>> getCommentsByPostId({
    required String trendsId,
  }) async {
    final response = await WPHttpService.to.get(
      "/jeecg-boot/api/trendsComment/getCommentsById",
      params: {"trendsId": trendsId},
    );

    return BaseResponse.fromJson(
      response.data,
      (data) => CommentModel.fromJson(data),
    );
  }

  /// 发送评论
  static Future<BaseResponse<String>> addComment(CommentReq data) async {
    final response = await WPHttpService.to.post(
      "/jeecg-boot/api/trendsComment/add",
      data: data.toJson(),
    );

    return BaseResponse.fromJson(response.data, (data) => data.toString());
  }
}
