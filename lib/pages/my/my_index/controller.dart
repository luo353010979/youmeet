import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';

class MyIndexController extends GetxController {
  MyIndexController();

  // late UserMessage userMessage;
  String userAvatar = "t.pic.mooneyu.com/FiHJJ2nmON_UOfP5D8cJf3h9pUrU"; // 用户头像
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
    // userMessage = UserService.to.profile;
    fetchMyFeedList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void toProfileView() {
    Get.toNamed(RouteNames.myEditProfile);
    // logger.d(userMessage.toJson());
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
        logger.d('选中图片: ${pickedFile.path}');

        await UploadService.to.requestQiniuToken();

        UploadService.to.upload(
          pickedFile.path,
          onProgress: (progress) {},
          onStatus: (state) {
            logger.d(state);
          },
          onDone: (done) {
            logger.d('上传完成: ${done.key}');
            UserService.to.profile.portrait = "t.pic.mooneyu.com/${done.key}";
            UserService.to.setProfile(UserService.to.profile);
            update(["edit_profile"]);
          },
        );
      }
    } catch (e) {
      logger.d('选择图片失败: $e');
      Get.snackbar('错误', '选择图片失败，请检查权限设置');
    }
  }

  /// 个人信息-展示墙照片
  void setImagePaths(List<String> paths) {
    uploadImage(paths);
  }

  /// 我的形象
  void onMyImageSelected(List<String> images) {
    logger.d('选中图片路径: $images');
    uploadImage(images);
  }


  void uploadImage(List<String> imgPaths) async {
    List<String> keys = [];
    final token = UserService.to.token;
    String baseUrl = "http://t.pic.mooneyu.com/";

    await UploadService.to.requestQiniuToken();

    await for (final key in UploadService.uploadImagesStream(imgPaths, token)) {
      keys.add("$baseUrl$key");
    }

    UserService.to.profile.pic = keys.join(",");

    UserService.to.setProfile(UserService.to.profile);
  }

  /// 获取我的动态列表
  Future<void> fetchMyFeedList() async {
    BaseResponse<FeedModel> response = await UserApi.getMyFeed();
    if (response.success) {
      FeedModel? myFeed = response.result;
      myFeedList = myFeed?.records ?? [];
      update(["my_index"]);
    } else {
      logger.d('获取动态列表失败: ${response.message}');
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
          UserService.to.profile.name = result;
          break;
        case Constants.editProfile:
          UserService.to.profile.profile = result;
          break;
        case Constants.editHeight:
          UserService.to.profile.height = int.tryParse(result) ?? UserService.to.profile.height;
          break;
        case Constants.editWeight:
          UserService.to.profile.weight = int.tryParse(result) ?? UserService.to.profile.weight;
      }
      update(["edit_profile_info"]);
    }
  }

  /// 保存资料
  void saveProfile() async {
    logger.d(UserService.to.profile.pic);
    await UserService.to.setProfile(UserService.to.profile);
    Get.back();
  }
}
