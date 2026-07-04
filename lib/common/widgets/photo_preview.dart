import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 全屏图片查看器：支持手势放大缩小、左右滑动切换。
/// 网络图与本地文件图都支持。
class PhotoPreview {
  /// 打开图片预览。
  /// [images] 图片地址列表（http 网络图或本地文件路径）。
  /// [initialIndex] 初始展示的图片下标。
  static void show(List<String> images, {int initialIndex = 0}) {
    final list = images.where((e) => e.trim().isNotEmpty).toList();
    if (list.isEmpty) return;
    final start = initialIndex.clamp(0, list.length - 1);
    Get.to(
      () => PhotoPreviewPage(images: list, initialIndex: start),
      opaque: false,
      fullscreenDialog: true,
      transition: Transition.fadeIn,
    );
  }
}

class PhotoPreviewPage extends StatefulWidget {
  const PhotoPreviewPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ImageProvider _provider(String path) {
    final isNetwork = path.startsWith('http') || path.startsWith('//');
    return isNetwork
        ? CachedNetworkImageProvider(path)
        : FileImage(File(path)) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: _provider(widget.images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                initialScale: PhotoViewComputedScale.contained,
                // 单击关闭；双击/双指缩放由 photo_view 内部处理，互不冲突
                onTapUp: (context, details, controllerValue) => Get.back(),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.broken_image, color: Colors.white54, size: 48.r),
                ),
              );
            },
          ),
          // 左上角返回按钮
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 8.w,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22.r),
              onPressed: () => Get.back(),
            ),
          ),
          // 页码指示器
          if (widget.images.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.images.length}',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
