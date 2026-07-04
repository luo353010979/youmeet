# AGENTS.md — youmeet 项目协作约定

> 这是 AI Agent 每次工作前必读的"唯一事实来源"。修改需求请改文档（`docs/`），不要只在聊天里说。

## 1. 技术栈

| 类别 | 选型 | 说明 |
|------|------|------|
| 框架 | Flutter（**fvm 管理**，版本 3.32.8） | 所有命令必须用 `fvm flutter xxx`，**禁止**直接用 `flutter` |
| 状态管理 | **GetX**（`get`） | 路由、状态、依赖注入都用 GetX |
| 网络 | `dio`（封装为 `WPHttpService.to`） | 统一走 `WPHttpService`，返回 `BaseResponse<T>` |
| 本地存储 | `shared_preferences`（`flustars` 封装） | |
| UI 扩展 | `ducafe_ui_core` + `flutter_screenutil` | 链式 API（`.toColumn()`、`100.w`、`.paddingHorizontal()`） |
| 加载提示 | `flutter_easyloading` | |
| 多语言 | GetX i18n | 文案用 `LocaleKeys.xxx.tr`，**禁止硬编码中文字符串** |
| IM | `wukongimfluttersdk` | 即时通讯 |

## 2. 目录与代码约定

### 页面结构（GetX 三件套）
每个页面是一个文件夹，固定三个文件：
```
lib/pages/<模块>/<页面>/
  ├── view.dart        # class XxxPage extends GetView<XxxController>
  ├── controller.dart  # class XxxController extends GetxController
  └── index.dart       # library + export controller/view
```

### 公共层
```
lib/common/
  ├── api/        # 静态方法，调 WPHttpService，返回 BaseResponse<T>
  ├── services/   # XxxService extends GetxService，用 XxxService.to 单例
  ├── models/     # 数据模型（fromJson/toJson）
  ├── routers/    # names.dart(RouteNames 常量) + pages.dart(RoutePages.list)
  ├── i18n/       # locale_keys.dart + locales/locale_zh.dart / locale_en.dart
  ├── values/     # 常量、图片/svg 路径
  ├── widgets/    # 通用组件
  └── utils/      # 工具
```

### 关键写法
- **局部刷新**：`GetBuilder<C>(id: "xxx")` + `update(["xxx"])`，不要全页 setState
- **路由跳转**：`Get.toNamed(RouteNames.xxx)` / `Get.offAllNamed(...)`；新页面必须在 `routers/names.dart` 加常量、`routers/pages.dart` 注册
- **文案**：新增文案先加到 `i18n/locale_keys.dart` 和 `locales/locale_zh.dart`、`locale_en.dart`，再用 `LocaleKeys.xxx.tr`
- **尺寸**：用 `.w/.h/.sp`（设计稿 375x812）

## 3. 工作流铁律（重要）

1. **文档驱动**：实现任何功能前，先读 `docs/prd/<功能>.md`，没有就先和用户确认。
2. **歧义不猜**：发现需求缺失/矛盾/有多种解释时，**不要自己拍脑袋实现**，写进 `questions/<功能>.q.md` 问用户。
3. **任务可追踪**：实现拆成 `todos/<功能>.todo.md`，完成一项勾一项。
4. **任务编号**：每次开始执行任务前，读 `docs/task-log.md` 取最后批次号 +1，先在回复里声明「🔢 第 N 次任务 / #NNN」，并在 `docs/task-log.md` 追加一行（含日期、功能、内容、状态）；执行结束更新该行状态。
5. **改动总结**：完成后直接在聊天里用 md 总结**改了哪些文件 / 做了什么**（无需再写 `specs/` 验收文件）。
6. **验证交用户**：设备验证默认由用户亲自验收；除非用户要求，不必自己截图逐条核对。需要时仍可 `fvm flutter analyze` 做静态检查。

## 4. 验证（默认交用户）

> 设备验证默认**由用户亲自验收**：AI 完成后说明改了哪些、怎么验，用户自己在设备上点。
> 仅当用户明确要求时，AI 才自己驱动设备截图核对。

- 静态检查（AI 可自查）：`fvm flutter analyze`
- 需要 AI 跑设备时：先 `fvm flutter devices` 识别设备（不写死某台），再 `fvm flutter run`（多设备 `-d <deviceId>`）。
- 截图（需要时）：安卓 `adb shell screencap -p /sdcard/__cap.png && adb pull /sdcard/__cap.png`；iOS 模拟器 `xcrun simctl io booted screenshot <path>`。

## 5. 完整流程图

```
PRD(docs/prd) → 任务(todos) + 歧义(questions)
   → 用户回答歧义 → 按任务实现 → 聊天里 md 总结改动 → 用户亲自验收
```
