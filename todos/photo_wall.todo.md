# 图片查看器（photo_wall）任务清单

- **slug**: photo_wall

## 任务
- [x] T1: 添加 `photo_view` 依赖（`fvm flutter pub add photo_view`）
- [x] T2: 封装可复用全屏查看器 `PhotoPreview`（缩放/滑动/页码/网络+本地），导出到 widgets barrel
- [x] T3: 圈子列表页九宫格图接入 `PhotoPreview.show`
- [x] T4: 圈子详情页九宫格图接入 `PhotoPreview.show`
- [x] T5: 我的页面自己帖子九宫格图接入 `PhotoPreview.show`
- [x] T6: `ImageSelectorWidget`（我的形象/展示墙）已选图片接入 `PhotoPreview.show`
- [x] T7: `fvm flutter analyze` 无新增 error
- [ ] T8: 真机/模拟器验证 AC1~AC6（点击→放大缩小→滑动→关闭）

## 阻塞中（等 questions 回答）
- 无（PRD 已确认，且授权自选插件）
