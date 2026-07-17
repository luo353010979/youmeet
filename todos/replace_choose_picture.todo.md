# 替换选择图片 - 任务清单 (slug: replace_choose_picture)

需求确认（用户已答）：
- 拍照：需要（引入 wechat_camera_picker，仅拍照，不录像）
- 视频：相册选择支持图片 + 视频
- 范围：把所有 image_picker 替换为 wechat_assets_picker，行为保持一致

## 任务
- [x] T1 pubspec 加依赖 wechat_assets_picker / wechat_camera_picker，pub get
- [x] T2 Android 权限（相机 + 媒体读取 READ_MEDIA_IMAGES/VIDEO）
- [x] T3 iOS 权限（相册 + 相机 + 麦克风 Usage 描述，改为中文说明）
- [x] T4 i18n 文案：拍照 / 从相册选择
- [x] T5 新建统一工具 MediaPicker（弹「拍照/相册」选择；相册支持图+视频；返回本地文件路径）
- [x] T6 替换 ImageSelectorWidget（多选，默认图+视频，视频用播放图标占位）
- [x] T7 替换 UploadService.pickImage（聊天发图，单选图片）
- [x] T8 替换 RegisterIndexController.pickImage（头像/实名照，单选图片）
- [x] T9 替换 MyIndexController.pickImage（头像，单选图片）
- [x] T10 移除 image_picker 依赖 & 清理 import
- [x] T11 fvm flutter analyze 自查（新增/改动文件 0 issue）

## 备注
- 视频缩略图：本地视频在网格里先用占位(播放图标)展示，避免再引入缩略图依赖；查看/播放属 photo_wall 另一功能，不在本次范围。
