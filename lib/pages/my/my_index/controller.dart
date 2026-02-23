import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';

class MyIndexController extends GetxController {
  MyIndexController();

  late UserMessage userMessage;
  String userAvatar = "t.pic.mooneyu.com/FiHJJ2nmON_UOfP5D8cJf3h9pUrU"; // 用户头像
  List<String> imagePaths = []; // 存储多张图片路径
  final ImagePicker _picker = ImagePicker();

  /// 刷新控制器
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 我的动态列表
  List<Feed> myFeedList = [];

  @override
  void onInit() {
    super.onInit();
    userMessage = UserService.to.profile;
    fetchMyFeedList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void toProfileView() {
    Get.toNamed(RouteNames.myEditProfile);
    // print(userMessage.toJson());
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }

  // 选择单张图片
  void pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('选中图片: ${pickedFile.path}');

        await UploadService.to.requestQiniuToken();

        UploadService.to.upload(
          pickedFile.path,
          onProgress: (progress) {},
          onStatus: (state) {
            print(state);
          },
          onDone: (done) {
            print('上传完成: ${done.key}');
            userMessage.portrait = "t.pic.mooneyu.com/${done.key}";
            UserService.to.setProfile(userMessage);
            update(["edit_profile"]);
          },
        );
      }
    } catch (e) {
      print('选择图片失败: $e');
      Get.snackbar('错误', '选择图片失败，请检查权限设置');
    }
  }

  /// 个人信息-展示墙照片
  void setImagePaths(List<String> paths) {
    imagePaths = paths;
  }

  /// 我的形象
  void onMyImageSelected(List<String> images) {
    print('选中图片路径: $images');
    // 这里可以处理选中的图片路径，例如上传到服务器或更新UI
  }

  /// 获取我的动态列表
  Future<void> fetchMyFeedList() async {
    BaseResponse<FeedModel> response = await UserApi.getMyFeed();
    if (response.success) {
      FeedModel? myFeed = response.result;
      myFeedList = myFeed?.records ?? [];
      update(["my_index"]);
    } else {
      print('获取动态列表失败: ${response.message}');
    }
  }

  /// 下拉刷新
  void onRefresh() async {
    await fetchMyFeedList();
    refreshController.finishRefresh();
  }

  // 跳转到编辑页面并处理返回结果
  void toEditPage({required int type}) async {
    final result = await Get.toNamed(RouteNames.myEdit);
    if (result != null) {
      switch (type) {
        case Constants.editNickname:
          userMessage.name = result;
          break;
        case Constants.editProfile:
          userMessage.profile = result;
          break;
        case Constants.editHeight:
          userMessage.height = int.tryParse(result) ?? userMessage.height;
          break;
        case Constants.editWeight:
          userMessage.weight = int.tryParse(result) ?? userMessage.weight;
      }
      update(["edit_profile_info"]);
    }
  }

  /// 保存资料
  void saveProfile() async {
    await UserService.to.setProfile(userMessage);
    Get.back();
  }
}
