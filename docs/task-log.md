# 任务执行日志（Task Log）

> 每次执行一个任务（批）前，AI 在此登记一条，编号 `#NNN` 全局自增。
> 这是"第几次任务"的唯一计数来源；查最后一行即知当前批次。
> AI 在开始执行时会先声明本次批次号（如「🔢 第 3 次任务 / #003」）。

## 编号规则
- 编号格式：`#001`、`#002`……三位数字，**全局连续**，跨功能不重置。
- 一"批"= 一次连贯的执行（可能完成某功能的若干 todo 项）。
- 状态：🔄 进行中 / ✅ 完成 / ❌ 失败/中止 / ⏸ 等待用户（如等 questions 回答）。

## 记录

| 批次 | 日期 | 功能(slug) | 本批做了什么 | 涉及 todo | 状态 |
|------|------|-----------|-------------|----------|------|
| #001 | 2026-07-01 | login-register | 修复登录请求 URL 重复 `/jeecg-boot` 导致 404；加固 onError 防止非 JSON 错误体崩溃导致 Loading 卡死 | bugfix | ✅ 登录验证通过 |
| #002 | 2026-07-01 | photo_wall | 接入 `photo_view`，封装全屏查看器 `PhotoPreview`；圈子列表/详情、我的帖子、我的形象/展示墙图片点击可放大缩小、滑动切换 | T1~T7 | ⏸ 代码完成，交用户验收 |
| #003 | 2026-07-01 | photo_wall | 查看器左上角加返回按钮，避免用户不知如何退出 | - | ⏸ 代码完成，交用户验收 |
| #004 | 2026-07-01 | bugfix | 修复 release 包无网络：INTERNET 权限只在 debug manifest，补到 main，并加 usesCleartextTraffic 支持明文 HTTP | - | ⏸ 重新打 release 验收 |
| #005 | 2026-07-02 | bugfix | 修复消息列表收到新会话崩溃：`_onRefreshConversationListener` 用 indexWhere 替代无 orElse 的 firstWhere（有则更新无则新增），消除 Bad state: No element | - | ⏸ 交用户验收 |
| #006 | 2026-07-02 | chat优化 | 优化聊天消息区域：修头像(按 fromUID 分自己/对方,去掉调试 seq)、气泡左右分色；ChatController 加 onClose 清理监听、按 channel 过滤+去重、删死代码；MsgService 精简为只留全局/同步类监听，理清分层 | - | ⏸ 交用户验收 |
| #007 | 2026-07-02 | bugfix | 修复未读红点重登复现：同步会话请求字段名 lastSsgSeqs→lastMsgSeqs(接口文档要求)，服务器据此算未读；顺带清理 msg.dart 未用 import | - | ⏸ 交用户验收 |
| #008 | 2026-07-02 | chat优化 | 修复聊天头像：chat 控制器拉对方资料的条件对 null id 判断有误(漏拉)；重构频道信息获取——_onGetChannelListener 改为按 channelId 拉真实用户(区分自己/对方)并缓存，删掉会话同步里逐个 getUserMessages 的请求风暴 | - | ⏸ 交用户验收 |
| #009 | 2026-07-03 | bugfix | 修复 http://null 报错+左侧头像不刷新：新增 _avatarWidget/_avatarUrl 空值兜底(不再请求 http://null)；消息列表 Obx 内同步读取 userMessage.portrait 并传入 msgWidget，使对方资料加载后列表正确重建 | - | ⏸ 交用户验收 |
| #010 | 2026-07-03 | chat优化 | 修复聊天滚动：scrollController 未接到 CustomScrollView(空操作)，发消息不滚底；接上 controller，发送/在底部时自动滚到最新，翻历史时收到新消息不打断并在底部中间弹出"新消息↓"气泡，点击回到最新 | - | ⏸ 交用户验收 |
| #011 | 2026-07-03 | bugfix | 修复已读消息返回列表仍显示未读：进聊天页只在 toChatPage 清了一次，页内新到的消息又被 SDK+1；ChatController 新增 _clearChannelUnread，onInit 进入即清、页内每次收到本会话消息再清一次 | - | ⏸ 交用户验收 |
| #012 | 2026-07-03 | feature | 用户详情页右上角"更多"改为 PopupMenuButton 气泡菜单，含举报/拉黑两项，点击各弹 toast(举报成功/已拉黑)；图标色跟随沉浸头部展开状态 | - | ⏸ 交用户验收 |
| #013 | 2026-07-03 | feature | 关于我们页 appBar 新增"更多"PopupMenuButton，单项"注销"，点击弹 toast(注销成功) | - | ⏸ 交用户验收 |
