import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:youmeet/common/index.dart';

class ImageSelectorWidget extends StatefulWidget {
  const ImageSelectorWidget({
    super.key,
    this.maxImages = 1,
    this.onImagesSelected,
    this.images,
    this.requestType = RequestType.common,
  });

  final int? maxImages; // 最大数量
  final Function(List<String>)? onImagesSelected; // 选择回调
  final List<String>? images; // 外部传入图片
  final RequestType requestType; // 可选类型：默认图片+视频

  @override
  State<ImageSelectorWidget> createState() => _ImageSelectorWidgetState();
}

class _ImageSelectorWidgetState extends State<ImageSelectorWidget> {
  List<String> selectedImages = []; // 存储多张图片路径

  List<String> get allImages {
    // 合并外部图片和内部选择图片
    final extImages = widget.images ?? [];
    return [...extImages, ...selectedImages];
  }

  int get imageCount => allImages.length;

  int get totalItems {
    final showPlaceholder = imageCount < widget.maxImages!;
    return showPlaceholder ? imageCount + 1 : imageCount;
  }

  static const _videoExts = ['.mp4', '.mov', '.avi', '.mkv', '.wmv', '.flv', '.webm', '.m4v', '.3gp'];

  bool _isVideo(String path) {
    final lower = path.toLowerCase();
    return _videoExts.any((ext) => lower.endsWith(ext));
  }

  Widget _buildVideoPlaceholder() {
    return IconWidget.icon(Icons.play_circle_fill, size: 32.w, color: const Color(0xFFFFFFFF))
        .center()
        .decorated(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(12.r),
        )
        .constrained(width: 108.w, height: 108.w);
  }

  /// 选择图片/视频
  void pickMultipleImages({int? maxImages}) async {
    try {
      final remain = maxImages ?? ((widget.maxImages ?? 1) - imageCount);
      if (remain <= 0) return;

      final paths = await MediaPicker.pick(
        maxCount: remain,
        requestType: widget.requestType,
      );
      if (paths.isNotEmpty) {
        setState(() {
          selectedImages.addAll(paths);
        });
        widget.onImagesSelected?.call(allImages);
      }
    } catch (e) {
      logger.d('选择图片失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        // childAspectRatio: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < imageCount) {
          final path = allImages[index];
          // 视频：无法直接当图片渲染，展示占位 + 播放图标
          if (_isVideo(path)) {
            return _buildVideoPlaceholder();
          }
          // 显示已选择的图片（包括外部传入和内部选择）
          final isHttpImg = path.contains("http");
          final imgWidget = isHttpImg
              ? ImageWidget.img(path, width: 108.w, height: 108.w, fit: BoxFit.cover, radius: 12)
              : ImageWidget.file(path, width: 108.w, height: 108.w, fit: BoxFit.cover, radius: 12);
          // 点击预览（放大缩小、滑动切换）——仅图片
          return imgWidget.onTap(() {
            final images = allImages.where((e) => !_isVideo(e)).toList();
            final previewIndex = images.indexOf(path);
            PhotoPreview.show(images, initialIndex: previewIndex < 0 ? 0 : previewIndex);
          });
        } else {
          // 显示上传占位符（只在未满时显示一个）
          return IconWidget.svg(AssetsSvgs.icProfileAdd2Svg, width: 16.w, height: 16.w)
              .center()
              .decorated(
                border: Border.all(color: Color(0xFFF1F1F1), width: 1.w),
              )
              .onTap(() {
                pickMultipleImages(maxImages: widget.maxImages! - imageCount);
              });
        }
      },
    );
  }
}
