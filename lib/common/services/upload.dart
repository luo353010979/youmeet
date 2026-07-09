import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:youmeet/common/index.dart' hide Storage;

enum UploadStatus { idle, uploading, failed, success }

class UploadService extends GetxService {
  static UploadService get to => Get.find();

  final storage = Storage();
  final putController = PutController();

  final ImagePicker _picker = ImagePicker();

  QiNiuTokenModel? token;

  /// 初始化，获取七牛云上传 token
  Future<String> requestQiniuToken() async {
    BaseResponse<QiNiuTokenModel> model = await SystemApi.requestQiniuToken();
    token = model.result;
    logger.d('七牛云上传 token: ${token?.token}');
    return token?.token ?? '';
  }

  /// 上传文件
  Future<PutResponse?> upload(
    String filePath, {
    required void Function(double) onProgress,
    required void Function(StorageStatus) onStatus,
    required void Function(PutResponse) onDone,
  }) async {
    final removeStatusListener = putController.addStatusListener(onStatus);
    final removeProgressListener = putController.addProgressListener(onProgress);

    File file = File(filePath);
    final putOptions = PutOptions(key: generateSimpleId("${file.hashCode.abs()}"), controller: putController);
    try {
      final response = await storage.putFile(file, token?.token ?? '', options: putOptions);
      onDone(response);
      return response;
    } catch (e) {
      return null;
    } finally {
      removeProgressListener();
      removeStatusListener();
    }
  }

  String generateSimpleId(String hashCode) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '${hashCode}_$timestamp';
  }

  /// 选择图片并上传，返回图片 URL
  Future<String?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 100, maxHeight: 100);
    if (pickedFile == null) {
      return null;
    }

    await requestQiniuToken();
    final response = await upload(pickedFile.path, onProgress: (progress) {}, onStatus: (state) {}, onDone: (done) {});

    final key = response?.key;
    if (key == null || key.isEmpty) {
      return null;
    }

    return "${Constants.imgDomain}$key";
  }

  static Stream<String> uploadImagesStream(List<String> imagePaths, String token) {
    final streamController = StreamController<String>();

    // 没有图片时立即结束，避免调用方 await for 永久挂起
    if (imagePaths.isEmpty) {
      streamController.close();
      return streamController.stream;
    }

    int finished = 0;
    void onSettled() {
      finished++;
      if (finished == imagePaths.length) {
        streamController.close();
      }
    }

    for (final img in imagePaths) {
      UploadService.to
          .upload(
            img,
            onProgress: (progress) {},
            onStatus: (state) {
              logger.d('上传状态: $state');
            },
            onDone: (done) {
              streamController.add(done.key ?? "");
              logger.d('上传完成: ${done.key}');
            },
          )
          .then((response) {
            // 无论成功或失败都要计数，避免有图片上传失败时永久挂起
            if (response == null) {
              logger.d('上传失败: $img');
            }
            onSettled();
          });
    }
    return streamController.stream;
  }
}
