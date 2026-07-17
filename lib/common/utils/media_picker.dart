import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:youmeet/common/index.dart';

export 'package:wechat_assets_picker/wechat_assets_picker.dart' show RequestType;

/// 统一的图片/视频选择工具（替代 image_picker）。
///
/// 底部弹出「拍照 / 从相册选择」：
/// - 拍照走 [wechat_camera_picker]（仅拍照，不录像）
/// - 相册走 [wechat_assets_picker]，可按 [requestType] 选择图片或图片+视频
///
/// 统一返回本地文件路径，交给上层上传（与原 image_picker 流程一致）。
class MediaPicker {
  MediaPicker._();

  /// 选择资源，返回本地文件路径列表。
  ///
  /// [maxCount] 相册最多可选数量；
  /// [requestType] 相册可选类型（默认仅图片，传 [RequestType.common] 可选图片+视频）；
  /// [enableCamera] 为 true 时先弹「拍照/从相册选择」，false 时直接进相册。
  static Future<List<String>> pick({
    int maxCount = 9,
    RequestType requestType = RequestType.image,
    bool enableCamera = true,
  }) async {
    if (Get.context == null) return [];

    if (!enableCamera) {
      return _pickFromGallery(maxCount: maxCount, requestType: requestType);
    }

    final source = await _showSourceSheet();
    switch (source) {
      case _PickSource.camera:
        final path = await _pickFromCamera();
        return path == null ? <String>[] : <String>[path];
      case _PickSource.gallery:
        return _pickFromGallery(maxCount: maxCount, requestType: requestType);
      case null:
        return <String>[];
    }
  }

  /// 单选，返回一个本地文件路径（无选择时为 null）。
  static Future<String?> pickSingle({
    RequestType requestType = RequestType.image,
    bool enableCamera = true,
  }) async {
    final list = await pick(
      maxCount: 1,
      requestType: requestType,
      enableCamera: enableCamera,
    );
    return list.isEmpty ? null : list.first;
  }

  static Future<List<String>> _pickFromGallery({
    required int maxCount,
    required RequestType requestType,
  }) async {
    final context = Get.context;
    if (context == null) return <String>[];

    final assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxCount,
        requestType: requestType,
      ),
    );
    if (assets == null || assets.isEmpty) return <String>[];

    final paths = <String>[];
    for (final asset in assets) {
      final file = await asset.file;
      if (file != null) paths.add(file.path);
    }
    return paths;
  }

  static Future<String?> _pickFromCamera() async {
    final context = Get.context;
    if (context == null) return null;

    final entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(enableRecording: false),
    );
    if (entity == null) return null;
    final file = await entity.file;
    return file?.path;
  }

  static Future<_PickSource?> _showSourceSheet() {
    return Get.bottomSheet<_PickSource>(
      Container(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: <Widget>[
            _sheetItem(
              LocaleKeys.commonTakePhoto.tr,
              () => Get.back(result: _PickSource.camera),
            ),
            Divider(height: 1.h, color: const Color(0x1A333333)),
            _sheetItem(
              LocaleKeys.commonChooseFromAlbum.tr,
              () => Get.back(result: _PickSource.gallery),
            ),
            Container(height: 6.h, color: const Color(0xFFF5F5F5)),
            _sheetItem(
              LocaleKeys.commonBottomCancel.tr,
              () => Get.back(),
            ),
          ].toColumn(mainAxisSize: MainAxisSize.min),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
    );
  }

  static Widget _sheetItem(String text, VoidCallback onTap) {
    return TextWidget.body(text).center().tight(height: 52.h).onTap(onTap);
  }
}

enum _PickSource { camera, gallery }
