import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class PostsIndexController extends GetxController {
  PostsIndexController();

  var items = List.generate(8, (index) {
    return KeyValueModel(key: '# 热门话题 $index', value: '这是热门话题描述 $index');
  }).obs;

  final expandController = ExpandableController();

  _initData() {
    update(["posts_index"]);
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

  void toDetail() {
    Get.toNamed(RouteNames.postsPostDetal);
  }
}
