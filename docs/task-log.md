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
| #014 | 2026-07-04 | feature | 资质查看实时申请-审批：基于 WuKongIM 自定义消息(type=1001)实现 申请/同意/拒绝 实时信令；新增 QualificationContent 模型；MsgService 注册类型+全局审批弹窗+发送信令+授权占位；ChatController 发起申请/状态管理/拉取对方报告；聊天内渲染状态卡片(收方带同意/拒绝按钮)。后端授权接口待对接 | - | ⏸ 待后端字段+验收 |
| #015 | 2026-07-06 | guide | 暂时移除引导页(欢迎页)：SplashController._jumpToPage 去掉 isAlreadyOpen 跳欢迎页分支，直接按登录态去主页/登录页。欢迎页代码与路由保留，后续需要时恢复判断即可 | - | ⏸ 交用户验收 |
| #016 | 2026-07-07 | chat优化 | 修复聊天页键盘遮挡消息：消息区是顶部锚定 CustomScrollView，键盘弹出后视口变矮但最新消息不跟随。ChatController mixin WidgetsBindingObserver，didChangeMetrics 检测键盘弹出(底部 inset 变大)时 scrollToBottom，postFrame+300ms 各滚一次兜底；onClose 移除 observer | - | ⏸ 交用户验收 |
| #017 | 2026-07-07 | splash | 移除 flutter_native_splash 启动页(含 Android12 猫头图)。该版本 remove 命令有 bug(--help flag 判空错误)故手动还原：Android 删 android12splash/background 图、v31 样式、还原 launch_background.xml 与 styles.xml 为默认纯色；iOS 删 LaunchBackground.imageset、LaunchScreen.storyboard 还原默认；pubspec 移除 flutter_native_splash 配置与依赖。pub get 因国内镜像 TLS 报错未完成(环境问题) | - | ⏸ 待 pub get+验收 |
| #018 | 2026-07-09 | select-country | 选择国家页新增搜索框(按中文名/英文名/区号/缩写过滤)；列表名称按当前语言显示(中文取 chinese、英文取 english)，标题与占位符走 i18n；注册提交 req.country 同步按语言取名 | - | ⏸ 交用户验收 |
| #019 | 2026-07-09 | bugfix | 修复发布动态无反应：uploadImagesStream 在无图片(纯文字)或上传失败时 StreamController 永不 close，导致 sendFeed 的 await for 永久挂起(卡在取完七牛 token 之后)。空列表直接 close；改用 upload().then 计数(成功/失败都计)确保流一定结束 | - | ⏸ 交用户验收 |
| #020 | 2026-07-09 | send-post | 发布动态后加 Loading(开始 show/成功 success/失败异常 error)、空内容校验 | - | ⏸ 交用户验收 |
| #021 | 2026-07-09 | bugfix | 修复发布后"我的"页不刷新(需重启)：sendFeed 成功后 Get.find<MyIndexController>().fetchMyFeedList() 刷新列表；修复无图动态显示破图：feed.pic 为空时 "".split(",") 得到 [""] 渲染空图，改为过滤空串且 images 为空时不渲染图片网格 | - | ⏸ 交用户验收 |
| #022 | 2026-07-09 | about-us | 关于我们页去掉测试代码(list/loadData/add)和右上角"+"添加图标；改为居中显示 logo + 品牌名 + 版本号(取 ConfigService.to.version)；保留右上角注销菜单 | - | ⏸ 交用户验收 |
| #023 | 2026-07-09 | register | 品牌名 YouMeet→Boaura(关于我们页)；修复注册第二页/第一页键盘弹出底部溢出(LayoutBuilder+SingleChildScrollView+ConstrainedBox+IntrinsicHeight 保留 Spacer)；修复注册 language 传字符串报错——后端要 int(0=zh 1=en 2=ja 3=ko 4=de)，UserRegisterReq.language 改 int? 且控制器按 _languageMap 映射 | - | ⏸ 交用户验收 |
| #024 | 2026-07-10 | login | 登录记住账号密码：新增 storageAccount/storagePassword；EncryptUtil 加 aesDecode；LoginController onInit 读缓存回填(密码 AES 解密)，登录成功 _saveCredentials 保存(密码 AES 加密)，切换账号 setString 自动覆盖 | - | ⏸ 交用户验收 |
| #025 | 2026-07-10 | chat-entry | 首页卡片"打招呼"按钮注释掉；用户详情页(matching_detail)"打招呼"按钮接通跳转聊天页，arguments 传 {channelId: user.id, userMessage: user}(与聊天页 Get.arguments 读取格式一致) | - | ⏸ 交用户验收 |
| #026 | 2026-07-10 | bugfix | 修复首次进聊天没有对方头像/昵称(发条消息后二次进入才有)：loadData 原来仅在 userMessage.id 为空时拉资料，改为只要 channelId 非空就主动拉一次对方 profile(传入数据仅作占位)；_getUserMessages 成功才覆盖并回写 MsgService.userMap 供会话列表复用 | - | ⏸ 交用户验收 |
| #033 | 2026-07-17 | chat | 聊天页发送消息后清空输入框：ChatController 新增 inputController(TextEditingController)并在 onClose dispose，sendMessage 里发送前 inputController.clear()；view 的 InputWidget 绑定该 controller | - | ⏸ 交用户验收 |
| #032 | 2026-07-17 | bugfix | 修复直接在动态页发布后进「我的」页崩溃(MyIndexController not found)：MyIndexPage 的 GetBuilder 原 init: Get.find<MyIndexController>() 在实例未注册时直接抛错(send_post 里 Get.find 触发的 lazyPut 实例在 send_post 路由 pop 后被回收)。改为 isRegistered? Get.find : Get.put(MyIndexController()) 复用或新建 | - | ⏸ 交用户验收 |
| #035 | 2026-07-17 | register | 真人认证已选图片右上角加删除按钮：_buildRealPicWidget 用 Stack 叠加半透明圆形关闭按钮，点击调 RegisterIndexController.clearRealPic()(置空 req.realPic 并 update(["register_upload_picture"]))，删除后回到拍照卡片可重新选择相册 | - | ⏸ 交用户验收 |
| #034 | 2026-07-17 | my-profile | 修复「我的」页面性别标签显示 null：其实标签文案是年龄(profile.age)非性别(性别由 icon 区分,male 图标说明 sex 已存)。后端注册只收 birthday 不收 age，返回 age 为 null。my_index/view 加 _displayAge()：age 为空时用 _ageFromBirthday(birthday) 客户端算年龄，仍无则显示空串(不再显示 null) | - | ⏸ 交用户验收 |
| #031 | 2026-07-17 | register | 实名认证页 _buildRealPicWidget 顶部加示例图 img_example.png(引导做相同手势,图内含说明文案)，与已拍照片竖排展示；AssetsImages 加 imgExamplePng 常量；_buildView 由 Center 改 SingleChildScrollView 防内容变高溢出 | - | ⏸ 交用户验收 |
| #030 | 2026-07-17 | register | 注册基本信息页生日改为日期选择器：原 TextField 手输改为可点击文本(GetBuilder id:birth 显示已选日期/占位)，点击调 RegisterIndexController.pickBirthday 用 flutter_datetime_picker_plus 的 DatePicker(1950-01-01~今天，默认1990-01-01，随语言 zh/en)，确认后写回 birthController+req.birthday 并 update(["birth"]) | - | ⏸ 交用户验收 |
| #029 | 2026-07-17 | chat-bugfix | 修复首次进聊天(无历史消息)不显示对方信息卡/报告上传卡：view._buildView 原来两张卡用 if(isComplete) 门控，而 isComplete 仅在有历史消息时才置 true，导致新会话永不显示(发条消息二次进入才有)。去掉门控让卡片始终显示(内部各自 Obx 随 userMessage/report 加载刷新)；_buildUploadCard 补 Obx 使我的报告加载后能回填。注：ym/queryById(getSafeReport 查我自己报告)后端返回 500「操作失败,null」属后端问题，前端已容错(失败保留空报告，卡片照常显示) | - | ⏸ 交用户验收 |
| #028 | 2026-07-17 | home-entry | 首页用户卡片(HomeItem)「申请查看报告」按钮(viewApplication)原 onTap 为空，接通跳转聊天页：Get.toNamed(RouteNames.msgChat, arguments:{channelId:data.id, userMessage:data})，与详情页打招呼/聊天页读取格式一致 | - | ⏸ 交用户验收 |
| #027 | 2026-07-17 | replace-picture | 全量替换 image_picker→wechat_assets_picker：新增统一 MediaPicker(弹「拍照/相册」；拍照用 wechat_camera_picker 仅拍照；相册支持图+视频；返回本地路径)；替换 ImageSelectorWidget(默认图+视频,视频占位)/UploadService.pickImage/RegisterIndexController.pickImage/MyIndexController.pickImage；配置 Android(READ_MEDIA_IMAGES/VIDEO+CAMERA)/iOS 权限；加 i18n(拍照/从相册选择)；移除 image_picker 依赖。pub get+analyze 通过 | - | ⏸ 交用户验收 |
