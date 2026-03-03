import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class PostsIndexController extends GetxController {
  PostsIndexController();

  var items = List.generate(8, (index) {
    return KeyValueModel(key: '# 热门话题 $index', value: '这是热门话题描述 $index');
  }).obs;

  /// 展开折叠控制器
  final expandController = ExpandableController();

  /// 刷新控制器
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<Feed> feedList = [];

  _initData() {
    requestRecommendFeed();
  }

  void expanded() {
    expandController.expanded = !expandController.expanded;
    update(["subject_hot_topic"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    expandController.dispose();
    refreshController.dispose();
  }

  /// 跳转到帖子详情
  void toDetailPage(Feed feed) {
    Get.toNamed(
      RouteNames.postsPostDetal,
      arguments: {Constants.paramFeed: feed},
    );
  }

  /// 请求推荐动态列表
  Future<void> requestRecommendFeed() async {
    final latitude = ConfigService.to.position?.latitude.toString() ?? "0";
    final longitude = ConfigService.to.position?.longitude.toString() ?? "0";
    final PostsReq postsReq = PostsReq(
      latitude: latitude,
      longitude: longitude,
      isVideo: 0,
      pageNo: 1,
      pageSize: 10,
    );
    final response = await PostApi.requestRecommendFeed(postsReq);
    if (response.success) {
      feedList = response.result?.records ?? [];
      update(["posts_index"]);
    } else {
      // 处理错误的响应
      logger.d('请求推荐动态失败: ${response.message}');
    }
  }

  /// 点赞
  void onTapLike(Feed record) async {
    final response = await PostApi.like(record.id ?? '');
    if (response.success) {
      // 刷新数据
      record.isLike = record.isLike == 0 ? 1 : 0;
      record.likeNum = record.isLike == 1
          ? (record.likeNum ?? 0) + 1
          : (record.likeNum ?? 0) - 1;
      update(["posts_index"]);
    } else {
      // 处理错误的响应
      logger.d('点赞失败: ${response.message}');
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
      logger.d('评论失败: ${response.message}');
    }
  }

  /// 下拉刷新
  void onRefresh() async {
    await requestRecommendFeed();
    refreshController.finishRefresh();
  }
}
