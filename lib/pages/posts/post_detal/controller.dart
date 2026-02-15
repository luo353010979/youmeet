import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class PostDetalController extends GetxController {
  PostDetalController();

  Feed? feed;
  List<FeedComments> comments = [];

  @override
  void onInit() {
    super.onInit();
    feed = Get.arguments?[Constants.paramFeed];
    if (feed != null) {
      fetchComments(feed!.id ?? '');
    }
  }

  /// 同时获取动态详情与评论
  Future<void> fetchPostDetailAndComments(String id) async {
    await Future.wait([fetchPostDetail(id), fetchComments(id)]);
    update(["post_detal"]);
  }

  /// 获取动态详情
  Future<void> fetchPostDetail(String id) async {
    final response = await PostApi.getPostDetail(id);
    if (response.success) {
      feed = response.result;
    }
  }

  /// 获取动态的评论列表
  Future<void> fetchComments(String id) async {
    final response = await PostApi.getCommentsByPostId(trendsId: id);
    if (response.success) {
      comments = response.result.records ?? [];
      update(["post_detal"]);
    }
  }

  /// 评论动态
  void onTapComment(Feed feed, String content) async {
    final commentReq = CommentReq(pid: feed.id, trendsContent: content);
    final response = await PostApi.addComment(commentReq);
    if (response.success) {
      Loading.success("评论成功");
      // 刷新数据
      feed.commentNum = (feed.commentNum ?? 0) + 1;
      fetchComments(feed.id ?? '');
      update(["post_detal"]);
    } else {
      // 处理错误的响应
      print('评论失败: ${response.message}');
    }
  }

  /// 回复评论
  void onReplayComment(FeedComments comment, String content) async {
    final commentReq = CommentReq(pid: comment.id, trendsContent: content);
    final response = await PostApi.addComment(commentReq);
    if (response.success) {
      Loading.success("回复成功");
      // 刷新数据
      fetchComments(comment.trendsId ?? '');
      update(["post_detal"]);
    } else {
      // 处理错误的响应
      print('回复失败: ${response.message}');
    }
  }
}
