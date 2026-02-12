import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class PostDetalController extends GetxController {
  PostDetalController();

  Record? postDetail;

  @override
  void onInit() {
    super.onInit();
    String id = Get.arguments?[Constants.POST_ID] ?? '';
    if (id.isNotEmpty) {
      fetchPostDetail(id);
    }
  }

  Future<void> fetchPostDetail(String id) async {
    final response = await PostApi.getPostDetail(id);
    if (response.success) {
      postDetail = response.result;
      update(["post_detal"]);
    }
  }
}
