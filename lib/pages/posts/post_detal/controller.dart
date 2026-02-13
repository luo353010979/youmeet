import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class PostDetalController extends GetxController {
  PostDetalController();

  Feed? feed;
  List<FeedComments> comments = [];

  @override
  void onInit() {
    super.onInit();
    String id = Get.arguments?[Constants.POST_ID] ?? '';
    if (id.isNotEmpty) {
      fetchPostDetailAndComments(id);
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
    }
  }

  /// 评论
  void onTapComment(Feed record, String content) async {
    final commentReq = CommentReq(id: record.id, trendsContent: content);
    final response = await PostApi.addComment(commentReq);
    if (response.success) {
      Loading.show("评论成功");
      // 刷新数据
      record.commentNum = (record.commentNum ?? 0) + 1;
      update(["posts_index"]);
    } else {
      // 处理错误的响应
      print('评论失败: ${response.message}');
    }
  }
}
