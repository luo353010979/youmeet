import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/index.dart';

class ImageSelectorWidget extends StatefulWidget {
  const ImageSelectorWidget({
    super.key,
    this.maxImages = 1,
    this.onImagesSelected,
  });

  final int? maxImages; // 最大图片数量

  final Function(List<String>)? onImagesSelected; // 图片选择回调

  @override
  State<ImageSelectorWidget> createState() => _ImageSelectorWidgetState();
}

class _ImageSelectorWidgetState extends State<ImageSelectorWidget> {
  List<String> selectedImages = []; // 存储多张图片路径

  int get imageCount => selectedImages.length;

  int get totalItems {
    final showPlaceholder = imageCount < widget.maxImages!;
    return showPlaceholder ? imageCount + 1 : imageCount;
  }

  final ImagePicker _picker = ImagePicker();

  /// 选择图片
  void pickMultipleImages({int? maxImages}) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(limit: maxImages);

      if (pickedFiles.isNotEmpty) {
        // 如果设置了最大数量限制
        if (maxImages != null && pickedFiles.length > maxImages) {
          setState(() {
            selectedImages = pickedFiles
                .take(maxImages)
                .map((e) => e.path)
                .toList();
          });
        } else {
          setState(() {
            selectedImages = pickedFiles.map((e) => e.path).toList();
          });
        }
        widget.onImagesSelected?.call(selectedImages);
      }
    } catch (e) {
      print('选择图片失败: $e');
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
          // 显示已选择的图片
          return ImageWidget.file(
            selectedImages[index],
            width: 108.w,
            height: 108.w,
            fit: BoxFit.cover,
          ).clipRRect(all: 12.r);
        } else {
          // 显示上传占位符（只在未满时显示一个）
          return IconWidget.svg(
                AssetsSvgs.icProfileAdd2Svg,
                width: 16.w,
                height: 16.w,
              )
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
