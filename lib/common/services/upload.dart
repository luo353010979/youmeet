import 'dart:io';

import 'package:get/get.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:youmeet/common/index.dart' hide Storage;

enum UploadStatus { idle, uploading, failed, success }

class UploadService extends GetxService {
  static UploadService get to => Get.find();

  final storage = Storage();

  final putController = PutController();

  Future<String> getQiNiuToken() async {
    BaseResponse<QiNiuTokenModel> model = await SystemApi.getQiNiuToken();
    final token = model.result?.token;
    return token ?? '';
  }

  void upload(
    String filePath,
    String token, {
    required void Function(double) onProgress,
    required void Function(StorageStatus) onStatus,
    required void Function(PutResponse) onDone,
  }) {
    final removeStatusListener = putController.addStatusListener(onStatus);
    final removeProgressListener = putController.addProgressListener(
      onProgress,
    );

    File file = File(filePath);
    final putOptions = PutOptions(
      key: generateSimpleId("${file.hashCode.abs()}"),
      controller: putController,
    );
    final upload = storage.putFile(file, token, options: putOptions);
    upload
      ..then((response) {
        onDone(response);
        removeProgressListener();
        removeStatusListener();
      })
      ..catchError((e) {
        return PutResponse.fromJson({'error': e});
      });
  }

  String generateSimpleId(String hashCode) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '${hashCode}_$timestamp';
  }
}
