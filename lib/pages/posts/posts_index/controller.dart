import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/api/posts.dart';
import 'package:youmeet/common/index.dart';

class PostsIndexController extends GetxController {
  PostsIndexController();

  var items = List.generate(8, (index) {
    return KeyValueModel(key: '# 热门话题 $index', value: '这是热门话题描述 $index');
  }).obs;

  final expandController = ExpandableController();

  List<Record> feedList = [];

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
  }

  /// 跳转到帖子详情
  void toDetailPage() {
    Get.toNamed(RouteNames.postsPostDetal);
  }

  void requestRecommendFeed() async {
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
      feedList = response.result.records ?? [];
      update(["posts_index"]);
    } else {
      // 处理错误的响应
      print('请求推荐动态失败: ${response.message}');
    }
  }
}
