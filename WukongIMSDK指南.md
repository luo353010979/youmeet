# WuKongIM Flutter SDK 使用指南

> 本文档为 WuKongIM Flutter SDK 的完整使用指南，提供从快速入门到进阶功能的全套说明。

---

## 目录

- [1. 项目概述](#1-项目概述)
- [2. 快速开始](#2-快速开始)
- [3. IM连接与登录](#3-im连接与登录)
- [4. 消息发送](#4-消息发送)
- [5. 消息接收](#5-消息接收)
- [6. 会话管理](#6-会话管理)
- [7. 数据模型详解](#7-数据模型详解)
- [8. 必须实现的8个监听器](#8-必须实现的8个监听器)
- [9. 后端API集成](#9-后端api集成)
- [10. 完整实现示例](#10-完整实现示例)
- [11. 进阶功能](#11-进阶功能)
- [12. 常见问题与最佳实践](#12-常见问题与最佳实践)
- [13. 附录](#13-附录)

---

## 1. 项目概述

### 1.1 什么是 WuKongIM SDK？

WuKongIM Flutter SDK 是一套专为 Flutter 平台设计的即时通讯(IM)解决方案，基于 WebSocket 长连接实现实时通信。该 SDK 提供了完整的消息收发、会话管理、自动重连等核心功能，开发者可以快速集成到 Flutter 应用中，实现类似微信、QQ 的即时通讯功能。

#### 核心特性

- **高可用性**: 支持自动重连、断线重传、消息可靠性保障
- **易用性**: 简洁的 API 设计，Manager 模式管理各类功能
- **高性能**: 基于 WebSocket 长连接，消息传输低延迟
- **可扩展**: 支持自定义消息类型、消息扩展字段
- **跨平台**: 完整支持 iOS、Android 平台

### 1.2 核心功能列表

WuKongIM SDK 提供以下 5 大核心功能：

| 功能编号 | 功能名称 | 功能说明 | 使用场景 |
|---------|---------|---------|---------|
| 1 | IM连接与登录 | 支持 WebSocket 长连接，自动登录与断线重连 | 用户登录应用后自动建立 IM 连接 |
| 2 | 消息发送 | 支持文本、图片、语音、视频等多种消息类型 | 用户发送各类聊天内容 |
| 3 | 消息接收 | 实时接收服务器推送的消息，支持离线消息同步 | 用户接收其他人的聊天内容 |
| 4 | 会话管理 | 支持会话列表查询、未读数管理、置顶、免打扰等 | 消息列表界面展示与交互 |
| 5 | 自动重连 | 网络异常或服务器断开时自动尝试重连 | 保障连接稳定性，提升用户体验 |

### 1.3 技术架构

WuKongIM SDK 采用 **Manager 模式** 设计，所有功能通过 `WKIM.shared` 单例访问。SDK 内部包含 6 个核心管理器，每个管理器负责特定领域的功能。

#### 架构图（文字描述）

```
┌─────────────────────────────────────────────────────────┐
│                   Flutter 应用层                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   聊天界面   │  │  会话列表    │  │  联系人列表  │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
└─────────┼──────────────────┼──────────────────┼─────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │
                    ┌────────▼────────┐
                    │  WKIM.shared    │  ← 单例入口
                    │  (Main API)     │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌───────▼────────┐  ┌───────▼────────┐
│ ConnectManager │  │MessageManager  │  │ConversationMgr │
│   连接管理      │  │   消息管理      │  │   会话管理      │
│ - connect()    │  │ - sendMessage() │  │ - queryList()  │
│ - disconnect() │  │ - getHistory() │  │ - setTop()     │
│ - 状态监听      │  │ - 消息监听      │  │ - 未读数管理    │
└────────────────┘  └────────────────┘  └────────────────┘
        │                    │                    │
┌───────▼────────┐  ┌───────▼────────┐  ┌───────▼────────┐
│ ChannelManager │  │  CmdManager    │  │  ReminderMgr   │
│   频道管理      │  │   命令管理      │  │   提醒管理      │
│ - 获取用户信息  │  │ - 回收消息      │  │ - @消息提醒     │
│ - 获取群组信息  │  │ - 频道更新      │  │ - 系统通知     │
└────────────────┘  └────────────────┘  └────────────────┘
                             │
                    ┌────────▼────────┐
                    │   后端服务器      │  ← WuKongIM Server
                    │  (IM Service)   │
                    └─────────────────┘
```

#### 6 个核心管理器说明

| 管理器名称 | 类名 | 主要职责 | 常用方法 |
|----------|------|---------|---------|
| 连接管理器 | ConnectManager | IM 连接建立、断开、重连、状态监听 | `connect()`, `disconnect()`, `addOnConnectionStatus()` |
| 消息管理器 | MessageManager | 消息发送、接收、历史消息查询、附件上传 | `sendMessage()`, `getHistoryMessages()`, `addOnNewMsgListener()` |
| 会话管理器 | ConversationManager | 会话列表查询、未读数管理、置顶、免打扰 | `queryConversationList()`, `updateRedDot()`, `setTop()` |
| 频道管理器 | ChannelManager | 用户信息、群组信息获取与管理 | `getChannelInfo()`, `addOnGetChannelListener()` |
| 命令管理器 | CmdManager | 系统命令处理（消息撤回、频道更新、未读清除） | `addOnCmdListener()` |
| 提醒管理器 | ReminderManager | @消息提醒、系统通知 | `addReminderListener()` |

### 1.4 适用场景

WuKongIM SDK 适用于需要实时通讯功能的各种应用场景：

#### 场景 1: 社交聊天应用
- **功能需求**: 一对一聊天、群聊、语音消息、图片分享
- **SDK 能力**: ✅ 完全支持文本、图片、语音消息，支持个人频道和群组频道

#### 场景 2: 在线客服系统
- **功能需求**: 用户与客服人员实时沟通、消息历史查询
- **SDK 能力**: ✅ 支持实时消息收发、历史消息同步、会话列表管理

#### 场景 3: 企业协作工具
- **功能需求**: 团队群聊、@消息提醒、未读消息统计
- **SDK 能力**: ✅ 支持群组频道、@提醒功能、未读数管理

#### 场景 4: 在线教育平台
- **功能需求**: 教师与学生实时互动、语音消息、文件共享
- **SDK 能力**: ✅ 支持实时消息、语音消息、自定义消息类型（可扩展）

#### 场景 5: 直播互动应用
- **功能需求**: 直播间弹幕、礼物消息、实时互动
- **SDK 能力**: ✅ 支持实时消息收发、自定义消息类型（弹幕、礼物等）

### 1.5 版本要求

| 项目 | 最低版本 | 推荐版本 | 说明 |
|------|---------|---------|------|
| Flutter | 3.0.0 | 3.19.0+ | SDK 基于 Flutter 3.0+ 开发 |
| Dart | 2.17.0 | 3.4.0+ | 使用 Dart 新特性 |
| iOS | iOS 12.0+ | iOS 14.0+ | 支持 iOS 12 及以上系统 |
| Android | Android 5.0 (API 21) | Android 10.0+ | 支持 Android 5.0 及以上 |
| WuKongIM Server | - | 最新版 | 需要自建或使用官方云服务 |

### 1.6 官方资源

| 资源名称 | 链接 | 说明 |
|---------|------|------|
| GitHub 仓库 | https://github.com/WuKongIM/WuKongIMFlutterSDK | SDK 源码、问题反馈 |
| 官方文档 | https://github.com/WuKongIM/WuKongIMDocs | 详细文档、API 参考 |
| 示例项目 | https://github.com/WuKongIM/WuKongIMFlutterSDK/tree/master/example | 完整示例代码 |
| WuKongIM Server | https://github.com/WuKongIM/WuKongIMServer | 后端服务器源码 |

### 1.7 重要说明

⚠️ **WuKongIM SDK 不是独立运行的组件，必须配合后端服务器使用！**

#### 为什么需要后端？

WuKongIM SDK 的以下功能依赖后端 API：

1. **用户认证**: `uid` 和 `token` 需要从后端获取
2. **IM 服务器地址**: 可通过后端 API 动态获取
3. **历史消息同步**: 需要后端提供消息存储和查询接口
4. **用户/群组信息**: 用户昵称、头像、群组信息需要从后端获取
5. **会话同步**: 会话列表需要从后端同步
6. **文件上传**: 图片、语音、视频等附件需要上传到后端 CDN

#### 后端必需的 API 列表

| API | 方法 | 用途 | 优先级 |
|-----|------|------|-------|
| `/api/im/server` | GET | 获取 IM 服务器地址 | 中 |
| `/api/message/sync` | POST | 同步历史消息 | 高 |
| `/api/conversation/sync` | POST | 同步会话列表 | 高 |
| `/api/user/{uid}` | GET | 获取用户信息 | 高 |
| `/api/group/{groupId}` | GET | 获取群组信息 | 高 |
| `/api/file/upload` | POST | 上传文件附件 | 高 |

#### 后端集成建议

- 使用官方 WuKongIM Server：https://github.com/WuKongIM/WuKongIMServer
- 或使用 WuKongIM 云服务（提供完整的后端支持）
- 参考示例项目中的 `http.dart` 文件了解 API 调用方式

### 1.8 开发流程概览

使用 WuKongIM SDK 开发 IM 功能的标准流程：

```
第 1 步: 后端准备
  ├── 搭建 WuKongIM Server
  ├── 实现用户认证接口
  └── 实现必需的 6 个后端 API

第 2 步: SDK 集成
  ├── 添加依赖包
  ├── 初始化 SDK (setup)
  └── 注册 8 个监听器

第 3 步: 连接 IM
  ├── 配置连接参数 (Options)
  ├── 连接服务器 (connect)
  └── 监听连接状态

第 4 步: 消息收发
  ├── 实现消息发送 (文本/图片/语音/视频)
  ├── 实现消息接收 (监听器)
  └── 实现消息列表 UI

第 5 步: 会话管理
  ├── 获取会话列表
  ├── 未读数管理
  └── 置顶、免打扰功能

第 6 步: 测试与优化
  ├── 功能测试
  ├── 性能优化
  └── 上线部署
```

---

## 2. 快速开始

本章节将引导你在 5 分钟内完成 WuKongIM SDK 的基础集成，实现发送和接收消息的最小可用示例。

### 2.1 安装依赖

#### 2.1.1 添加依赖包

在你的 Flutter 项目的 `pubspec.yaml` 文件中添加 WuKongIM SDK 依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter

  # WuKongIM Flutter SDK
  wukongimfluttersdk: ^最新版本
```

> 💡 **提示**: 最新版本号请查看 [pub.dev](https://pub.dev/packages/wukongimfluttersdk) 或 GitHub Releases。

#### 2.1.2 安装依赖

在项目根目录下执行以下命令下载依赖：

```bash
# 如果使用 Flutter CLI
flutter pub get

# 或者使用 pub
pub get
```

### 2.2 导入 SDK

在需要使用 WuKongIM SDK 的 Dart 文件中导入：

```dart
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
```

> 📌 **注意**: `WKIM` 是 SDK 的核心类，所有功能都通过 `WKIM.shared` 单例访问。

### 2.3 基础概念说明

在使用 SDK 前，需要理解以下 3 个核心概念：

| 概念 | 英文名 | 说明 | 举例 |
|-----|-------|------|------|
| **频道** | Channel | 聊天对象的标识，可以是用户或群组 | 个人频道 `user123`，群组频道 `group456` |
| **消息** | Message | 聊天内容的载体，包含文本、图片、语音等 | 文本消息 "你好"，图片消息 |
| **会话** | Conversation | 聊天记录列表中的每一条记录 | 和 "张三" 的会话、"工作群" 的会话 |

#### 频道类型（Channel Type）

| 类型值 | 常量 | 说明 |
|-------|------|------|
| 1 | `WKChannelType.personal` | 个人频道（一对一聊天） |
| 2 | `WKChannelType.group` | 群组频道（群聊） |

### 2.4 3 步实现最小可用示例

以下代码展示了发送和接收消息的最小可用示例。假设你已经有了后端服务器，并且能够获取到用户的 `uid` 和 `token`。

#### 步骤 1: 初始化 SDK

```dart
// 在 main.dart 或应用启动时初始化
void initWuKongIM() {
  // 从后端获取用户 uid 和 token
  String uid = 'user_123';        // 用户唯一标识
  String token = 'user_token';   // 用户身份令牌

  // 创建 Options 配置对象
  Options options = Options.newDefault(uid, token);

  // 可选：配置 IM 服务器地址（如果未配置，SDK 会使用默认地址）
  options.addr = 'ws://your-im-server.com:5100';

  // 可选：开启调试模式
  options.debug = true;

  // 初始化 SDK
  WKIM.shared.setup(options);

  print('WuKongIM SDK 初始化完成');
}
```

#### 步骤 2: 连接 IM 服务器

```dart
// 在用户登录后调用
void connectIM() {
  // 连接 IM 服务器
  WKIM.shared.connectionManager.connect();

  // 监听连接状态
  WKIM.shared.connectionManager.addOnConnectionStatus('connect_key', (status, reason, connectInfo) {
    switch (status) {
      case WKConnectStatus.connecting:
        print('IM 连接中...');
        break;
      case WKConnectStatus.success:
        print('IM 连接成功，节点ID: ${connectInfo?.nodeId}');
        break;
      case WKConnectStatus.fail:
        print('IM 连接失败，原因: $reason');
        break;
      case WKConnectStatus.noNetwork:
        print('网络异常，无法连接');
        break;
      case WKConnectStatus.kicked:
        print('被踢下线（其他设备登录）');
        break;
      case WKConnectStatus.syncMsg:
        print('正在同步消息...');
        break;
      case WKConnectStatus.syncCompleted:
        print('消息同步完成');
        break;
    }
  });
}
```

#### 步骤 3: 发送和接收消息

```dart
// 3.1 发送文本消息
void sendMessage() {
  // 创建文本消息内容
  WKTextContent textContent = WKTextContent('你好，这是我的第一条消息！');

  // 创建频道对象（个人频道）
  String targetUID = 'user_456';              // 目标用户ID
  int channelType = WKChannelType.personal;   // 频道类型：个人
  WKChannel channel = WKChannel(targetUID, channelType);

  // 发送消息
  WKIM.shared.messageManager.sendMessage(
    textContent,
    channel,
  ).then((WKMsg msg) {
    print('消息发送成功，消息ID: ${msg.messageID}');
  }).catchError((error) {
    print('消息发送失败: $error');
  });
}

// 3.2 接收消息
void setupMessageListeners() {
  // 监听新消息（消息刚收到，尚未保存到数据库）
  WKIM.shared.messageManager.addOnNewMsgListener('msg_key', (WKMsg msg) {
    print('收到新消息: ${msg.content}');
    print('发送者: ${msg.fromUID}');
    print('频道ID: ${msg.channelID}');

    // 此时可以播放提示音、更新小红点等
  });

  // 监听消息插入数据库（消息已保存，可以刷新 UI）
  WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
    print('消息已保存到数据库: ${msg.messageID}');

    // 此时可以刷新聊天列表 UI
  });
}
```

### 2.5 完整最小可用示例

将上述代码整合到一个完整的 Flutter 示例中：

```dart
import 'package:flutter/material.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WuKongIM Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _connectionStatus = '未连接';
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _initSDK();
  }

  @override
  void dispose() {
    // 移除监听器，避免内存泄漏
    WKIM.shared.connectionManager.removeOnConnectionStatus('connect_key');
    WKIM.shared.messageManager.removeOnNewMsgListener('msg_key');
    WKIM.shared.messageManager.removeOnMsgInsertedListener('insert_key');
    super.dispose();
  }

  // 初始化 SDK
  void _initSDK() {
    // 初始化
    Options options = Options.newDefault('user_123', 'user_token');
    options.debug = true;
    WKIM.shared.setup(options);

    // 连接 IM
    _connectIM();

    // 监听消息
    _setupMessageListeners();
  }

  // 连接 IM
  void _connectIM() {
    WKIM.shared.connectionManager.connect();

    WKIM.shared.connectionManager.addOnConnectionStatus('connect_key', (status, reason, connectInfo) {
      setState(() {
        switch (status) {
          case WKConnectStatus.connecting:
            _connectionStatus = '连接中...';
            break;
          case WKConnectStatus.success:
            _connectionStatus = '已连接 (${connectInfo?.nodeId})';
            break;
          case WKConnectStatus.fail:
            _connectionStatus = '连接失败';
            break;
          case WKConnectStatus.noNetwork:
            _connectionStatus = '无网络';
            break;
          case WKConnectStatus.kicked:
            _connectionStatus = '被踢下线';
            break;
          case WKConnectStatus.syncMsg:
            _connectionStatus = '同步消息中...';
            break;
          case WKConnectStatus.syncCompleted:
            _connectionStatus = '同步完成';
            break;
        }
      });
    });
  }

  // 监听消息
  void _setupMessageListeners() {
    WKIM.shared.messageManager.addOnNewMsgListener('msg_key', (WKMsg msg) {
      print('收到新消息: ${msg.content}');
    });

    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      setState(() {
        _messages.add('[${msg.fromUID}]: ${msg.content}');
      });
    });
  }

  // 发送消息
  void _sendMessage() {
    WKTextContent textContent = WKTextContent('你好，当前时间: ${DateTime.now()}');
    WKChannel channel = WKChannel('user_456', WKChannelType.personal);

    WKIM.shared.messageManager.sendMessage(textContent, channel).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('WuKongIM Demo'),
      ),
      body: Column(
        children: [
          // 连接状态
          Container(
            padding: const EdgeInsets.all(16),
            color: _connectionStatus.contains('已连接') ? Colors.green[100] : Colors.red[100],
            child: Row(
              children: [
                Icon(
                  _connectionStatus.contains('已连接') ? Icons.cloud_done : Icons.cloud_off,
                  color: _connectionStatus.contains('已连接') ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  '连接状态: $_connectionStatus',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // 消息列表
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                  leading: const Icon(Icons.message),
                );
              },
            ),
          ),
          // 发送按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('发送测试消息'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 2.6 常见问题

#### Q1: 如何获取 IM 服务器地址？

**A**: 可以通过后端 API 动态获取，也可以在 `Options` 中配置固定地址：

```dart
// 方式 1: 固定地址
Options options = Options.newDefault('uid', 'token');
options.addr = 'ws://your-server.com:5100';

// 方式 2: 动态获取
WKIM.shared.options.getAddr = (Function(String address) complete) async {
  String ip = await HttpUtils.getIMServerIP();  // 从你的后端获取
  complete(ip);
};
```

#### Q2: 如何断开连接？

**A**: 使用 `disconnect()` 方法：

```dart
// isLogout = true: 退出登录，不再重连
// isLogout = false: 临时断开，SDK 会自动重连
WKIM.shared.connectionManager.disconnect(isLogout: true);
```

#### Q3: 如何清理监听器？

**A**: 在 `dispose()` 或页面销毁时调用 `remove` 方法：

```dart
@override
void dispose() {
  WKIM.shared.connectionManager.removeOnConnectionStatus('your_key');
  WKIM.shared.messageManager.removeOnNewMsgListener('your_key');
  super.dispose();
}
```

> ⚠️ **注意**: 所有监听器的 `key` 必须唯一，否则可能导致重复监听或无法移除。

---

## 3. IM连接与登录

IM 连接是使用 WuKongIM SDK 的第一步。本章将详细介绍如何配置 SDK、建立连接、监听连接状态、处理断线重连等核心功能。

### 3.1 Options 配置详解

`Options` 是 SDK 初始化的核心配置类，包含所有连接所需的参数。

#### 3.1.1 Options 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|-------|------|------|
| `uid` | String | ✅ | - | 用户唯一标识符 | `"user_12345"` |
| `token` | String | ✅ | - | 用户身份令牌，用于服务端认证 | `"a1b2c3d4e5f6..."` |
| `addr` | String? | ❌ | `null` | IM 服务器地址（格式：`IP:PORT` 或 `ws://IP:PORT`） | `"ws://192.168.1.100:5100"` |
| `protoVersion` | int | ❌ | `0x04` | 协议版本号，通常使用默认值 | `4` |
| `deviceFlag` | int | ❌ | `0` | 设备标识符（0=iOS，1=Android，2=Web） | `1` |
| `debug` | bool | ❌ | `true` | 是否开启调试模式（输出详细日志） | `true` |
| `getAddr` | Function? | ❌ | `null` | 动态获取 IM 服务器地址的回调函数 | 参见 3.3 节 |
| `proto` | Proto | ❌ | `Proto()` | 协议编解码器实例，通常不需要修改 | - |

> 💡 **提示**: `uid` 和 `token` 必须从你的后端服务器获取，不要在客户端硬编码，否则存在安全风险。

#### 3.1.2 创建 Options 的方法

SDK 提供了两种创建 Options 的方式：

##### 方式 1: 使用默认构造函数

```dart
import 'package:wukongimfluttersdk/common/options.dart';

Options options = Options();
options.uid = 'user_12345';
options.token = 'user_token_from_backend';
options.addr = 'ws://192.168.1.100:5100';
options.debug = true;
options.deviceFlag = 1;  // Android 设备
```

##### 方式 2: 使用 `newDefault` 工厂方法（推荐）

```dart
import 'package:wukongimfluttersdk/common/options.dart';

// 最简洁的方式
Options options = Options.newDefault('user_12345', 'user_token_from_backend');

// 带可选参数
Options options = Options.newDefault(
  'user_12345',
  'user_token_from_backend',
  addr: 'ws://192.168.1.100:5100'
);
```

#### 3.1.3 完整配置示例

```dart
Options createIMOptions(String uid, String token) {
  Options options = Options.newDefault(uid, token);

  // 配置 IM 服务器地址（可选）
  options.addr = 'ws://im.example.com:5100';

  // 开启调试模式（生产环境建议关闭）
  options.debug = false;

  // 设置设备标识（通常不需要手动设置，SDK 会自动识别）
  if (Platform.isAndroid) {
    options.deviceFlag = 1;  // Android
  } else if (Platform.isIOS) {
    options.deviceFlag = 0;  // iOS
  }

  // 配置动态获取服务器地址（可选，参见 3.3 节）
  options.getAddr = (Function(String address) complete) async {
    String serverAddr = await fetchIMServerAddressFromBackend();
    complete(serverAddr);
  };

  return options;
}
```

### 3.2 setup() 初始化流程

`WKIM.shared.setup()` 是 SDK 的初始化方法，必须在所有其他操作之前调用。

#### 3.2.1 setup() 方法签名

```dart
WKIM.shared.setup(Options options)
```

**参数说明**:
- `options`: Options 配置对象，必须包含 `uid` 和 `token`

**返回值**: 无返回值

#### 3.2.2 初始化时机

**最佳实践**: 在应用启动时尽早调用，建议在 `main.dart` 的 `runApp` 之前或第一个页面的 `initState` 中调用。

```dart
import 'package:flutter/material.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/common/options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 初始化

  // 初始化 WuKongIM SDK
  await initWuKongIM();

  runApp(const MyApp());
}

Future<void> initWuKongIM() async {
  // 从你的后端获取 uid 和 token
  UserInfo userInfo = await BackendAPI.login(username, password);
  
  // 创建配置
  Options options = Options.newDefault(userInfo.uid, userInfo.token);
  options.debug = true;  // 开发模式开启调试
  
  // 初始化 SDK
  WKIM.shared.setup(options);
  
  print('WuKongIM SDK 初始化完成');
}
```

#### 3.2.3 setup() 完整流程

```
用户登录成功
    │
    ├─> 1. 从后端获取 uid 和 token
    │
    ├─> 2. 创建 Options 配置对象
    │
    ├─> 3. 调用 WKIM.shared.setup(options)
    │       │
    │       ├─> 验证 uid 和 token 是否为空
    │       ├─> 初始化各个 Manager（连接、消息、会话等）
    │       ├─> 初始化本地数据库
    │       ├─> 保存配置到内存
    │       └─> 准备好连接
    │
    ├─> 4. 调用 connect() 连接 IM 服务器
    │
    └─> 5. 监听连接状态，开始使用
```

#### 3.2.4 错误处理

```dart
void initWuKongIM() {
  try {
    UserInfo userInfo = await BackendAPI.login(username, password);
    
    if (userInfo.uid == null || userInfo.token == null) {
      throw Exception('uid 或 token 为空');
    }
    
    Options options = Options.newDefault(userInfo.uid, userInfo.token);
    WKIM.shared.setup(options);
    
    print('SDK 初始化成功');
  } catch (e) {
    print('SDK 初始化失败: $e');
    // 处理初始化失败，例如弹出错误提示
  }
}
```

### 3.3 动态 IP 配置（getAddr）

如果 IM 服务器地址可能变化（例如有多台服务器负载均衡），可以使用 `getAddr` 回调动态获取服务器地址。

#### 3.3.1 使用场景

- **多机房部署**: 根据用户地理位置返回最近的机房地址
- **负载均衡**: 服务器地址动态调整
- **灰度发布**: 新版本用户连接到新服务器

#### 3.3.2 getAddr 回调函数签名

```dart
options.getAddr = (Function(String address) complete) async {
  // 1. 调用你的后端 API 获取服务器地址
  String serverAddr = await BackendAPI.getIMServerAddress();
  
  // 2. 必须调用 complete() 并传入地址
  complete(serverAddr);
};
```

**注意**:
- 回调是异步的，可以执行网络请求
- **必须**调用 `complete(String)`，否则 SDK 无法连接
- 如果 `addr` 和 `getAddr` 都配置了，SDK 优先使用 `getAddr`

#### 3.3.3 完整示例

```dart
// 后端 API 调用示例
class BackendAPI {
  static Future<String> getIMServerAddress() async {
    // 调用你的后端 API
    final response = await http.get(Uri.parse('https://api.example.com/im/server'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String addr = data['address'];  // 格式: "ws://192.168.1.100:5100"
      return addr;
    } else {
      throw Exception('获取服务器地址失败');
    }
  }
}

// SDK 配置
void setupIMWithDynamicAddress() {
  Options options = Options.newDefault('user_123', 'user_token');
  
  // 配置动态获取服务器地址
  options.getAddr = (Function(String address) complete) async {
    try {
      String serverAddr = await BackendAPI.getIMServerAddress();
      print('动态获取到服务器地址: $serverAddr');
      complete(serverAddr);
    } catch (e) {
      print('获取服务器地址失败: $e');
      complete('ws://default-server.com:5100');  // 使用默认地址
    }
  };
  
  WKIM.shared.setup(options);
  WKIM.shared.connectionManager.connect();
}
```

### 3.4 connect() 连接过程

`connect()` 方法用于建立与 IM 服务器的 WebSocket 长连接。

#### 3.4.1 方法签名

```dart
WKIM.shared.connectionManager.connect()
```

**返回值**: 无返回值

**注意事项**:
- 必须先调用 `setup()` 初始化 SDK
- 如果已经连接，调用 `connect()` 会自动断开后重新连接
- 如果未配置 `addr` 且未配置 `getAddr`，连接会失败

#### 3.4.2 连接流程图

```
调用 connect()
    │
    ├─> 1. 检查配置
    │       ├─> addr 或 getAddr 是否配置？
    │       └─> uid 和 token 是否配置？
    │
    ├─> 2. 获取服务器地址
    │       ├─> 如果配置了 getAddr → 调用回调获取地址
    │       └─> 否则 → 使用 addr 的值
    │
    ├─> 3. 断开旧连接（如果存在）
    │
    ├─> 4. 建立 WebSocket 连接
    │       ├─> Socket.connect(host, port, timeout: 5秒)
    │       ├─> 触发状态: WKConnectStatus.connecting
    │       └─> 等待连接响应
    │
    ├─> 5. 连接成功
    │       ├─> 发送连接认证包（包含 uid、token、deviceID）
    │       ├─> 等待服务器返回 connack
    │       │
    │       ├─> 成功 (reasonCode=1)
    │       │       ├─> 触发状态: WKConnectStatus.success
    │       │       ├─> 启动心跳定时器（60秒/次）
    │       │       ├─> 启动网络检测定时器（1秒/次）
    │       │       ├─> 开始同步会话列表
    │       │       ├─> 重发未发送成功的消息
    │       │       └─> 连接完成
    │       │
    │       └─> 失败 (reasonCode != 1)
    │               ├─> 触发状态: WKConnectStatus.fail
    │               └─> 1.5秒后自动重连
    │
    └─> 6. 连接失败（超时或网络错误）
            ├─> 触发状态: WKConnectStatus.fail
            └─> 1.5秒后自动重连
```

#### 3.4.3 连接示例代码

```dart
void connectToIM() {
  print('开始连接 IM 服务器...');
  
  WKIM.shared.connectionManager.connect();
  
  // 监听连接状态（参见 3.5 节）
  WKIM.shared.connectionManager.addOnConnectionStatus('connect_key', 
    (status, reason, connectInfo) {
      handleConnectionStatus(status, reason, connectInfo);
  });
}

void handleConnectionStatus(int status, int? reason, ConnectionInfo? info) {
  switch (status) {
    case WKConnectStatus.connecting:
      print('正在连接 IM 服务器...');
      // 显示连接中提示
      break;
      
    case WKConnectStatus.success:
      print('IM 连接成功！节点ID: ${info?.nodeId}');
      // 隐藏连接提示，进入聊天界面
      break;
      
    case WKConnectStatus.fail:
      print('IM 连接失败，原因: $reason');
      // 显示错误提示，SDK 会自动重连
      break;
      
    case WKConnectStatus.noNetwork:
      print('网络不可用');
      // 显示网络错误提示
      break;
      
    case WKConnectStatus.kicked:
      print('被踢下线（其他设备登录）');
      // 提示用户，可能需要重新登录
      break;
  }
}
```

### 3.5 连接状态监听

WuKongIM SDK 定义了 7 种连接状态，通过监听这些状态可以实时了解连接情况。

#### 3.5.1 7 种连接状态详解

| 状态值 | 常量 | 触发时机 | 处理建议 |
|-------|------|---------|---------|
| 0 | `WKConnectStatus.fail` | 连接失败（认证失败、超时等） | 提示用户，SDK 会自动重连 |
| 1 | `WKConnectStatus.success` | 连接成功并认证通过 | 隐藏加载提示，可以开始收发消息 |
| 2 | `WKConnectStatus.kicked` | 被服务器踢下线（其他设备登录） | 提示用户，可能需要重新登录 |
| 3 | `WKConnectStatus.syncMsg` | 正在同步消息 | 显示同步进度提示 |
| 4 | `WKConnectStatus.connecting` | 正在连接服务器 | 显示连接中提示 |
| 5 | `WKConnectStatus.noNetwork` | 网络不可用 | 显示网络错误提示 |
| 6 | `WKConnectStatus.syncCompleted` | 消息同步完成 | 隐藏进度提示，可以刷新UI |

#### 3.5.2 状态流转图

```
未连接
    │
    connect() 或 自动重连
    │
    ▼
[4] connecting (连接中)
    │
    ├─> 成功 ──────────────────┐
    │                           │
    ▼                           │
[1] success (连接成功)          │
    │                           │
    ├─> 开始同步会话           │
    ▼                           │
[3] syncMsg (同步中)            │
    │                           │
    ├─> 同步完成               │
    ▼                           │
[6] syncCompleted (同步完成)────┘
    │
    ├─> 心跳超时 (60秒未收到pong)
    ├─> 网络断开
    │
    ▼
[5] noNetwork (无网络)
    │
    ├─> 网络恢复
    │   └─> 自动重连 ──┐
    │                   │
    ├─> 连接失败       │
    │                   │
    ▼                   │
[0] fail (连接失败)─────┘
    │
    ├─> 1.5秒后自动重连 ──┐
    │                      │
    └──────────────────────┘

[2] kicked (被踢下线)
    │
    ├─> 用户主动重新登录
    └─> 连接被服务器强制断开
```

#### 3.5.3 监听连接状态

```dart
// 注册连接状态监听器
WKIM.shared.connectionManager.addOnConnectionStatus(
  'unique_key',  // 用于移除监听器的唯一标识
  (int status, int? reason, ConnectionInfo? connectInfo) {
    
    switch (status) {
      case WKConnectStatus.connecting:
        _onConnecting();
        break;
        
      case WKConnectStatus.success:
        _onConnected(connectInfo);
        break;
        
      case WKConnectStatus.fail:
        _onConnectFailed(reason);
        break;
        
      case WKConnectStatus.noNetwork:
        _onNoNetwork();
        break;
        
      case WKConnectStatus.kicked:
        _onKicked();
        break;
        
      case WKConnectStatus.syncMsg:
        _onSyncing();
        break;
        
      case WKConnectStatus.syncCompleted:
        _onSyncCompleted();
        break;
    }
  }
);

// 移除监听器（在页面销毁时）
WKIM.shared.connectionManager.removeOnConnectionStatus('unique_key');
```

#### 3.5.4 各状态处理示例

```dart
void _onConnecting() {
  print('正在连接 IM 服务器...');
  // 显示加载提示
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('正在连接服务器...'),
        ],
      ),
    ),
  );
}

void _onConnected(ConnectionInfo? connectInfo) {
  print('连接成功！节点ID: ${connectInfo?.nodeId}');
  
  // 关闭加载提示
  Navigator.of(context).pop();
  
  // 显示成功提示
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('连接成功！')),
  );
}

void _onConnectFailed(int? reason) {
  print('连接失败，原因代码: $reason');
  
  // 提示用户，SDK 会自动重连
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('连接失败，正在重试...'),
      duration: Duration(seconds: 2),
    ),
  );
}

void _onNoNetwork() {
  print('网络不可用');
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('网络不可用，请检查网络连接')),
  );
}

void _onKicked() {
  print('被踢下线，原因：其他设备登录');
  
  // 弹出提示，强制重新登录
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('账号已在其他设备登录'),
      content: const Text('您的账号在其他设备登录，如非本人操作，请及时修改密码。'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // 跳转到登录页
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text('重新登录'),
        ),
      ],
    ),
  );
}

void _onSyncing() {
  print('正在同步消息...');
}

void _onSyncCompleted() {
  print('消息同步完成');
  
  // 刷新聊天列表
  refreshConversationList();
}
```

### 3.6 disconnect() 断开连接

`disconnect()` 方法用于断开与 IM 服务器的连接。

#### 3.6.1 方法签名

```dart
WKIM.shared.connectionManager.disconnect(bool isLogout)
```

**参数说明**:
- `isLogout`: 是否退出登录
  - `true`: 退出登录，SDK 不再重连，清除本地缓存的 uid 和 token
  - `false`: 临时断开连接（如应用进入后台），SDK 会保留连接信息，可以自动重连

#### 3.6.2 使用场景

| 场景 | isLogout 参数 | 说明 |
|-----|--------------|------|
| 用户主动退出登录 | `true` | 清除登录信息，不再自动重连 |
| 应用切换账号 | `true` | 清除旧账号信息，准备连接新账号 |
| 应用进入后台 | `false` | 临时断开，应用回到前台时自动重连 |
| 网络切换 | `false` | SDK 内部自动处理，一般不需要手动调用 |

#### 3.6.3 代码示例

```dart
// 场景 1: 用户退出登录
void logout() {
  // 显示确认对话框
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('确认退出'),
      content: const Text('确定要退出登录吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            
            // 断开连接，并清除登录信息
            WKIM.shared.connectionManager.disconnect(isLogout: true);
            
            print('已退出登录');
            
            // 跳转到登录页
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

// 场景 2: 应用进入后台
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  super.didChangeAppLifecycleState(state);
  
  switch (state) {
    case AppLifecycleState.paused:
      print('应用进入后台');
      // 可选：断开连接以节省资源
      // WKIM.shared.connectionManager.disconnect(isLogout: false);
      break;
      
    case AppLifecycleState.resumed:
      print('应用回到前台');
      // 重新连接
      WKIM.shared.connectionManager.connect();
      break;
      
    default:
      break;
  }
}

// 场景 3: 切换账号
void switchAccount(String newUID, String newToken) {
  // 1. 退出当前账号
  WKIM.shared.connectionManager.disconnect(isLogout: true);
  
  // 2. 重新初始化 SDK
  Options options = Options.newDefault(newUID, newToken);
  WKIM.shared.setup(options);
  
  // 3. 连接新账号
  WKIM.shared.connectionManager.connect();
}
```

### 3.7 自动重连机制

WuKongIM SDK 内置了强大的自动重连机制，在网络恢复或连接断开时会自动尝试重连。

#### 3.7.1 自动重连触发条件

SDK 会在以下情况自动重连：

1. **连接失败**: 首次连接失败，1.5 秒后重连
2. **心跳超时**: 60 秒未收到服务器的 pong 响应
3. **网络恢复**: 检测到网络从不可用变为可用
4. **Socket 断开**: WebSocket 连接意外断开

#### 3.7.2 重连策略

| 场景 | 重连间隔 | 重连次数限制 |
|-----|---------|------------|
| 连接失败 | 1.5 秒 | 无限制，直到连接成功 |
| 心跳超时 | 立即重连 | 无限制 |
| 网络恢复 | 立即重连 | 每次网络恢复触发一次 |
| Socket 断开 | 1.5 秒 | 无限制 |

#### 3.7.3 禁用自动重连

如果需要禁用自动重连（如测试环境），可以在连接失败后主动调用 `disconnect(isLogout: false)` 停止重连：

```dart
WKIM.shared.connectionManager.addOnConnectionStatus('key', (status, reason, info) {
  if (status == WKConnectStatus.fail) {
    // 连接失败，可以选择禁用自动重连
    WKIM.shared.connectionManager.disconnect(isLogout: false);
  }
});
```

#### 3.7.4 自动重连监听示例

```dart
// 监听连接状态，了解重连过程
WKIM.shared.connectionManager.addOnConnectionStatus('connect_key',
  (status, reason, connectInfo) {
    
  switch (status) {
    case WKConnectStatus.connecting:
      print('正在连接...（可能是首次连接或重连）');
      break;
      
    case WKConnectStatus.fail:
      print('连接失败，SDK 将在 1.5 秒后自动重连');
      // 显示提示：正在重新连接...
      break;
      
    case WKConnectStatus.noNetwork:
      print('网络不可用，等待网络恢复后自动重连');
      break;
      
    case WKConnectStatus.success:
      print('连接成功！如果是重连，说明网络已恢复');
      break;
  }
});
```

### 3.8 完整连接管理示例

```dart
class IMConnectionManager {
  static const String _connectionKey = 'im_connection_key';
  bool _isConnected = false;

  /// 初始化 SDK
  static void initSDK(String uid, String token) {
    Options options = Options.newDefault(uid, token);
    options.debug = true;
    options.addr = 'ws://im.example.com:5100';
    
    WKIM.shared.setup(options);
    print('SDK 初始化完成');
  }

  /// 连接 IM
  static void connect() {
    WKIM.shared.connectionManager.connect();
    
    // 监听连接状态
    WKIM.shared.connectionManager.addOnConnectionStatus(
      _connectionKey,
      (status, reason, connectInfo) {
        _handleConnectionStatus(status, reason, connectInfo);
      },
    );
  }

  /// 断开连接
  static void disconnect({bool isLogout = false}) {
    WKIM.shared.connectionManager.disconnect(isLogout);
  }

  /// 移除监听器
  static void dispose() {
    WKIM.shared.connectionManager.removeOnConnectionStatus(_connectionKey);
  }

  /// 处理连接状态
  static void _handleConnectionStatus(
    int status,
    int? reason,
    ConnectionInfo? connectInfo,
  ) {
    switch (status) {
      case WKConnectStatus.connecting:
        _isConnected = false;
        print('状态: 正在连接...');
        break;
        
      case WKConnectStatus.success:
        _isConnected = true;
        print('状态: 连接成功，节点ID: ${connectInfo?.nodeId}');
        break;
        
      case WKConnectStatus.fail:
        _isConnected = false;
        print('状态: 连接失败，原因: $reason');
        print('SDK 将在 1.5 秒后自动重连');
        break;
        
      case WKConnectStatus.noNetwork:
        _isConnected = false;
        print('状态: 无网络');
        break;
        
      case WKConnectStatus.kicked:
        _isConnected = false;
        print('状态: 被踢下线（其他设备登录）');
        break;
        
      case WKConnectStatus.syncMsg:
        print('状态: 正在同步消息...');
        break;
        
      case WKConnectStatus.syncCompleted:
        print('状态: 消息同步完成');
        break;
    }
  }

  /// 获取当前连接状态
  static bool get isConnected => _isConnected;
}

// 使用示例
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 初始化 SDK
  IMConnectionManager.initSDK('user_123', 'user_token');
  
  // 2. 连接 IM
  IMConnectionManager.connect();
  
  runApp(const MyApp());
}
```

---

## 4. 消息发送

消息发送是 IM 功能的核心，WuKongIM SDK 支持发送文本、图片、语音、视频等多种消息类型。本章将详细介绍各种消息的发送方法、发送配置、状态监听和错误处理。

### 4.1 发送文本消息

文本消息是最常用的消息类型，用于发送普通文字内容。

#### 4.1.1 WKTextContent 类

`WKTextContent` 是文本消息内容的载体类。

**字段说明**:

| 字段名 | 类型 | 必填 | 说明 | 示例 |
|-------|------|------|------|------|
| `content` | String | ✅ | 文本消息内容 | `"你好，世界！"` |

**继承关系**:
```
WKMessageContent (基类)
    └── WKTextContent
```

#### 4.1.2 发送文本消息示例

```dart
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/type/const.dart';

// 发送文本消息（最简单的方式）
void sendTextMessage(String text, String targetUID) {
  // 1. 创建文本消息内容
  WKTextContent textContent = WKTextContent(text);
  
  // 2. 创建频道对象（个人频道）
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  // 3. 发送消息
  WKIM.shared.messageManager.sendMessage(textContent, channel);
  
  print('文本消息已发送: $text');
}

// 发送文本消息（监听发送结果）
Future<void> sendTextMessageWithResult(String text, String targetUID) async {
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  try {
    WKMsg result = await WKIM.shared.messageManager.sendMessage(textContent, channel);
    print('消息发送成功，消息ID: ${result.messageID}');
    print('消息序号: ${result.messageSeq}');
  } catch (e) {
    print('消息发送失败: $e');
  }
}
```

#### 4.1.3 完整的文本消息发送 UI 示例

```dart
class ChatPage extends StatefulWidget {
  final String targetUID;
  final int channelType;
  
  const ChatPage({
    required this.targetUID,
    required this.channelType,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<WKMsg> _messages = [];

  // 发送文本消息
  void _sendTextMessage() async {
    String text = _textController.text.trim();
    
    if (text.isEmpty) {
      return;  // 空消息不发送
    }
    
    // 创建文本消息内容
    WKTextContent textContent = WKTextContent(text);
    
    // 创建频道对象
    WKChannel channel = WKChannel(widget.targetUID, widget.channelType);
    
    try {
      // 发送消息
      WKMsg msg = await WKIM.shared.messageManager.sendMessage(textContent, channel);
      
      // 添加到消息列表（显示在右侧）
      setState(() {
        _messages.add(msg);
      });
      
      // 清空输入框
      _textController.clear();
      
      print('文本消息发送成功');
    } catch (e) {
      print('文本消息发送失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('与 ${widget.targetUID} 聊天')),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                WKMsg msg = _messages[index];
                bool isSelf = msg.fromUID == WKIM.shared.options.uid;
                
                return Align(
                  alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelf ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      msg.messageContent?.displayText() ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 输入框
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '输入消息...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendTextMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.2 发送图片消息

图片消息用于发送图片，支持本地图片和服务器图片。发送前 SDK 会自动调用上传监听器上传图片到服务器。

#### 4.2.1 WKImageContent 类

`WKImageContent` 继承自 `WKMediaMessageContent`，专门用于图片消息。

**字段说明**:

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `width` | int | ✅ | - | 图片宽度（像素） | `1920` |
| `height` | int | ✅ | - | 图片高度（像素） | `1080` |
| `url` | String | ❌ | - | 服务器图片 URL（上传后设置） | `"https://cdn.example.com/img/abc.jpg"` |
| `localPath` | String | ❌ | `''` | 本地图片路径（发送时使用） | `"/path/to/local/image.jpg"` |

**继承关系**:
```
WKMessageContent (基类)
    └── WKMediaMessageContent
            ├── url: String          // 服务器URL
            └── localPath: String    // 本地路径
            └── WKImageContent
                ├── width: int
                ├── height: int
                ├── url: String
                └── localPath: String
```

#### 4.2.2 发送图片消息流程

```
用户选择图片
    │
    ├─> 1. 压缩图片（可选）
    │
    ├─> 2. 创建 WKImageContent 对象
    │       - 设置 width 和 height
    │       - 设置 localPath
    │
    ├─> 3. 调用 sendMessage()
    │       │
    │       ├─> 触发 addOnUploadAttachmentListener 监听器
    │       ├─> 上传图片到服务器（你的后端 API）
    │       ├─> 设置 url 字段为上传后的地址
    │       └─> 调用 back(true, wkMsg) 返回
    │
    └─> 4. SDK 发送消息到 IM 服务器
```

#### 4.2.3 发送图片消息示例

```dart
import 'package:image_picker/image_picker.dart';
import 'package:wukongimfluttersdk/model/wk_image_content.dart';
import 'dart:io';

// 选择并发送图片
Future<void> sendImageMessage(String targetUID) async {
  // 1. 使用 image_picker 选择图片
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image == null) {
    return;  // 用户取消选择
  }
  
  // 2. 获取图片尺寸
  File imageFile = File(image.path);
  var decodedImage = await decodeImageFromList(await imageFile.readAsBytes());
  
  int width = decodedImage.width;
  int height = decodedImage.height;
  
  print('图片尺寸: $width x $height');
  
  // 3. 创建图片消息内容
  WKImageContent imageContent = WKImageContent(width, height);
  imageContent.localPath = image.path;  // 本地路径
  
  // 4. 创建频道对象
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  try {
    // 5. 发送消息（SDK 会调用上传监听器）
    WKMsg msg = await WKIM.shared.messageManager.sendMessage(imageContent, channel);
    print('图片消息发送中...');
  } catch (e) {
    print('图片消息发送失败: $e');
  }
}

// 从资源文件发送图片
Future<void> sendImageFromAssets(String targetUID, String assetPath) async {
  // 1. 加载资源图片
  final ByteData data = await rootBundle.load(assetPath);
  final Uint8List bytes = data.buffer.asUint8List();
  
  // 2. 解码图片获取尺寸
  var decodedImage = await decodeImageFromList(bytes);
  
  // 3. 创建图片消息内容
  WKImageContent imageContent = WKImageContent(
    decodedImage.width,
    decodedImage.height,
  );
  
  // 注意：这里需要先将资源图片复制到本地临时路径
  // 或者实现自定义上传逻辑直接上传资源图片
  imageContent.localPath = await _saveImageToTempFile(bytes);
  
  // 4. 发送
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  WKIM.shared.messageManager.sendMessage(imageContent, channel);
}

// 保存图片到临时文件
Future<String> _saveImageToTempFile(Uint8List bytes) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/temp_image.jpg');
  await file.writeAsBytes(bytes);
  return file.path;
}
```

#### 4.2.4 图片压缩策略

建议在发送前对大图片进行压缩，以节省流量和提升性能：

```dart
import 'package:image/image.dart' as img;

// 压缩图片
Future<Uint8List> compressImage(File imageFile) async {
  // 读取图片
  final bytes = await imageFile.readAsBytes();
  final image = img.decodeImage(bytes)!;
  
  // 压缩到最大宽度 1280 像素
  final compressed = img.copyResize(
    image,
    width: image.width > 1280 ? 1280 : null,
    maintainAspect: true,
  );
  
  // 压缩质量 85%
  final compressedBytes = img.encodeJpg(compressed, quality: 85);
  
  return Uint8List.fromList(compressedBytes);
}

// 使用压缩后的图片发送
Future<void> sendCompressedImage(String targetUID, String imagePath) async {
  File imageFile = File(imagePath);
  
  // 压缩
  Uint8List compressedBytes = await compressImage(imageFile);
  
  // 保存压缩后的图片
  final tempDir = await getTemporaryDirectory();
  final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await compressedFile.writeAsBytes(compressedBytes);
  
  // 获取压缩后的尺寸
  var decodedImage = await decodeImageFromList(compressedBytes);
  
  // 创建并发送图片消息
  WKImageContent imageContent = WKImageContent(
    decodedImage.width,
    decodedImage.height,
  );
  imageContent.localPath = compressedFile.path;
  
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  await WKIM.shared.messageManager.sendMessage(imageContent, channel);
}
```

### 4.3 发送语音消息

语音消息用于发送录音，支持录制时长和波形显示。

#### 4.3.1 WKVoiceContent 类

`WKVoiceContent` 继承自 `WKMediaMessageContent`，专门用于语音消息。

**字段说明**:

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `timeTrad` | int | ✅ | - | 语音时长（秒） | `10` |
| `waveform` | String? | ❌ | `null` | 语音波形（Base64 编码） | `"AAECAw=="` |
| `url` | String | ❌ | - | 服务器语音 URL（上传后设置） | `"https://cdn.example.com/voice/abc.mp3"` |
| `localPath` | String | ❌ | `''` | 本地语音文件路径 | `"/path/to/local/voice.mp3"` |

#### 4.3.2 录音实现建议

SDK 不提供录音功能，推荐使用以下第三方库：

| 库名 | 说明 | 链接 |
|------|------|------|
| `record` | 跨平台录音库 | https://pub.dev/packages/record |
| `flutter_sound` | 功能强大的音频处理库 | https://pub.dev/packages/flutter_sound |

#### 4.3.3 发送语音消息示例（使用 record 库）

```dart
import 'package:record/record.dart';
import 'package:wukongimfluttersdk/model/wk_voice_content.dart';
import 'package:path_provider/path_provider.dart';

class VoiceMessageSender {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;
  Timer? _timer;
  int _duration = 0;

  // 开始录音
  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getTemporaryDirectory();
      _recordingPath = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,  // AAC 编码
          bitRate: 128000,              // 128kbps
        ),
        path: _recordingPath!,
      );
      
      _isRecording = true;
      _duration = 0;
      
      // 开始计时
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _duration++;
        print('录音时长: $_duration 秒');
      });
      
      print('开始录音...');
    } else {
      print('没有录音权限');
    }
  }

  // 停止录音并发送
  Future<void> stopAndSendVoice(String targetUID) async {
    if (!_isRecording) {
      return;
    }
    
    // 停止录音
    final path = await _recorder.stop();
    _isRecording = false;
    _timer?.cancel();
    
    if (path == null) {
      print('录音失败');
      return;
    }
    
    print('录音完成，时长: $_duration 秒');
    
    // 创建语音消息内容
    WKVoiceContent voiceContent = WKVoiceContent(_duration);
    voiceContent.localPath = path!;
    
    // 创建频道
    WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
    
    try {
      // 发送语音消息
      await WKIM.shared.messageManager.sendMessage(voiceContent, channel);
      print('语音消息发送中...');
    } catch (e) {
      print('语音消息发送失败: $e');
    }
  }

  // 取消录音
  Future<void> cancelRecording() async {
    if (_isRecording) {
      await _recorder.stop();
      _isRecording = false;
      _timer?.cancel();
      print('录音已取消');
    }
  }
}

// UI 使用示例
class VoiceRecorderWidget extends StatefulWidget {
  final String targetUID;
  
  const VoiceRecorderWidget({required this.targetUID, super.key});

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final VoiceMessageSender _sender = VoiceMessageSender();
  bool _isRecording = false;
  String _recordingTime = '0"';

  @override
  void dispose() {
    _sender.cancelRecording();
    super.dispose();
  }

  void _startRecording() async {
    await _sender.startRecording();
    setState(() {
      _isRecording = true;
    });
    
    // 更新录音时长显示
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRecording) {
        timer.cancel();
        return;
      }
      setState(() {
        _recordingTime = '${timer.tick}"';
      });
    });
  }

  void _stopAndSend() async {
    await _sender.stopAndSendVoice(widget.targetUID);
    setState(() {
      _isRecording = false;
      _recordingTime = '0"';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        _startRecording();
      },
      onLongPressEnd: (_) {
        _stopAndSend();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isRecording ? Colors.blue[100] : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 32,
              color: _isRecording ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              _isRecording ? _recordingTime : '按住说话',
              style: TextStyle(
                color: _isRecording ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 4.3.4 语音波形生成

可选功能：为语音消息生成波形图，提升用户体验：

```dart
import 'package:flutter_sound/flutter_sound.dart';

// 生成语音波形
Future<String?> generateWaveform(String audioPath) async {
  try {
    // 读取音频文件
    final flutterSound = FlutterSoundPlayer();
    await flutterSound.startPlayerFromUri(Uri.file(audioPath));
    
    // 获取音频数据
    final buffer = await flutterSound.getFoodBuffer();
    
    // 生成波形数据（简化版）
    final waveform = <int>[];
    for (int i = 0; i < buffer.length; i += 100) {
      final amplitude = buffer[i].abs().toInt();
      waveform.add(amplitude);
    }
    
    // Base64 编码
    final waveformJson = jsonEncode(waveform);
    final base64Waveform = base64Encode(waveformJson.codeUnits);
    
    await flutterSound.stopPlayer();
    
    return base64Waveform;
  } catch (e) {
    print('生成波形失败: $e');
    return null;
  }
}

// 使用波形
Future<void> sendVoiceWithWaveform(String targetUID, String audioPath) async {
  // 获取时长
  final duration = await _getAudioDuration(audioPath);
  
  // 生成波形
  final waveform = await generateWaveform(audioPath);
  
  // 创建语音消息
  WKVoiceContent voiceContent = WKVoiceContent(duration);
  voiceContent.localPath = audioPath;
  voiceContent.waveform = waveform;  // 设置波形
  
  // 发送
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  await WKIM.shared.messageManager.sendMessage(voiceContent, channel);
}
```

### 4.4 发送视频消息

视频消息用于发送视频，需要同时上传视频文件和封面图片。

#### 4.4.1 WKVideoContent 类

`WKVideoContent` 继承自 `WKMediaMessageContent`，专门用于视频消息。

**字段说明**:

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `second` | int | ✅ | - | 视频时长（秒） | `30` |
| `size` | int | ❌ | `0` | 视频文件大小（字节） | `5242880` (5MB) |
| `width` | int | ❌ | `0` | 视频宽度（像素） | `1920` |
| `height` | int | ❌ | `0` | 视频高度（像素） | `1080` |
| `cover` | String | ❌ | - | 视频封面 URL（上传后设置） | `"https://cdn.example.com/cover/abc.jpg"` |
| `coverLocalPath` | String | ❌ | - | 本地封面图片路径 | `"/path/to/local/cover.jpg"` |
| `url` | String | ❌ | - | 服务器视频 URL（上传后设置） | `"https://cdn.example.com/video/abc.mp4"` |
| `localPath` | String | ❌ | - | 本地视频文件路径 | `"/path/to/local/video.mp4"` |

#### 4.4.2 发送视频消息流程

```
用户选择视频
    │
    ├─> 1. 压缩视频（可选）
    │
    ├─> 2. 生成视频封面
    │       - 从视频中提取第一帧
    │       - 或让用户选择封面
    │
    ├─> 3. 获取视频信息
    │       - 时长
    │       - 尺寸
    │       - 文件大小
    │
    ├─> 4. 创建 WKVideoContent 对象
    │       - 设置 second, size, width, height
    │       - 设置 localPath 和 coverLocalPath
    │
    ├─> 5. 调用 sendMessage()
    │       │
    │       ├─> 触发 addOnUploadAttachmentListener 监听器
    │       ├─> 上传封面图片到服务器
    │       ├─> 上传视频文件到服务器
    │       ├─> 设置 cover 和 url 字段
    │       └─> 调用 back(true, wkMsg) 返回
    │
    └─> 6. SDK 发送消息到 IM 服务器
```

#### 4.4.3 发送视频消息示例

```dart
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wukongimfluttersdk/model/wk_video_content.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// 选择并发送视频
Future<void> sendVideoMessage(String targetUID) async {
  // 1. 选择视频
  final ImagePicker picker = ImagePicker();
  final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
  
  if (video == null) {
    return;  // 用户取消选择
  }
  
  // 2. 获取视频信息
  final videoFile = File(video.path);
  final videoController = VideoPlayerController.file(videoFile);
  await videoController.initialize();
  
  int duration = videoController.value.duration.inSeconds;
  int width = videoController.value.size.width.toInt();
  int height = videoController.value.size.height.toInt();
  int size = await videoFile.length();
  
  videoController.dispose();
  
  print('视频信息: ${width}x${height}, ${duration}秒, ${size ~/ 1024}KB');
  
  // 3. 生成视频封面
  String? coverPath = await generateVideoThumbnail(video.path);
  if (coverPath == null) {
    print('生成封面失败');
    return;
  }
  
  // 4. 创建视频消息内容
  WKVideoContent videoContent = WKVideoContent();
  videoContent.second = duration;
  videoContent.size = size;
  videoContent.width = width;
  videoContent.height = height;
  videoContent.localPath = video.path;
  videoContent.coverLocalPath = coverPath;
  
  // 5. 发送
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  try {
    await WKIM.shared.messageManager.sendMessage(videoContent, channel);
    print('视频消息发送中...');
  } catch (e) {
    print('视频消息发送失败: $e');
  }
}

// 生成视频封面
Future<String?> generateVideoThumbnail(String videoPath) async {
  try {
    final thumbnailPath = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 75,
    );
    
    if (thumbnailPath == null) {
      return null;
    }
    
    // 保存封面到临时文件
    final tempDir = await getTemporaryDirectory();
    final coverFile = File('${tempDir.path}/cover_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await coverFile.writeAsBytes(thumbnailPath);
    
    return coverFile.path;
  } catch (e) {
    print('生成封面失败: $e');
    return null;
  }
}
```

#### 4.4.4 视频压缩建议

推荐使用 `video_compress` 库对大视频进行压缩：

```dart
import 'package:video_compress/video_compress.dart';

// 压缩视频
Future<String?> compressVideo(String originalPath) async {
  try {
    // 获取视频信息
    final info = await VideoCompress.getMediaInfo(originalPath);
    
    print('原始视频: ${info.duration}秒, ${info.filesize ~/ 1024 ~/ 1024}MB');
    
    // 压缩参数
    final result = await VideoCompress.compressVideo(
      originalPath,
      quality: VideoQuality.MediumQuality,  // 中等质量
      deleteOrigin: false,                // 不删除原视频
      includeAudio: true,                 // 包含音频
    );
    
    if (result == null) {
      return null;
    }
    
    print('压缩后: ${result.filesize ~/ 1024 ~/ 1024}MB');
    
    return result.file?.path;
  } catch (e) {
    print('视频压缩失败: $e');
    return null;
  }
}

// 使用压缩后的视频发送
Future<void> sendCompressedVideo(String targetUID, String originalPath) async {
  // 压缩视频
  String? compressedPath = await compressVideo(originalPath);
  
  if (compressedPath == null) {
    // 压缩失败，使用原视频
    compressedPath = originalPath;
  }
  
  // 生成封面
  String? coverPath = await generateVideoThumbnail(compressedPath);
  
  // 获取压缩后的视频信息
  final compressedFile = File(compressedPath);
  final videoController = VideoPlayerController.file(compressedFile);
  await videoController.initialize();
  
  int duration = videoController.value.duration.inSeconds;
  int width = videoController.value.size.width.toInt();
  int height = videoController.value.size.height.toInt();
  int size = await compressedFile.length();
  
  videoController.dispose();
  
  // 创建并发送
  WKVideoContent videoContent = WKVideoContent();
  videoContent.second = duration;
  videoContent.size = size;
  videoContent.width = width;
  videoContent.height = height;
  videoContent.localPath = compressedPath;
  videoContent.coverLocalPath = coverPath;
  
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  await WKIM.shared.messageManager.sendMessage(videoContent, channel);
}
```

### 4.5 WKSendOptions 配置

`WKSendOptions` 用于配置消息发送时的行为。

#### 4.5.1 WKSendOptions 字段说明

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `header` | MessageHeader | `MessageHeader()` | 消息头配置 |
| `setting` | Setting | `Setting()` | 消息设置 |
| `expire` | int | `0` | 消息过期时间（秒），0表示永不过期 |
| `topicID` | String | `""` | 话题ID（用于话题消息） |

#### 4.5.2 MessageHeader 消息头配置

| 字段名 | 类型 | 默认值 | 说明 | 使用场景 |
|-------|------|--------|------|---------|
| `redDot` | bool | `true` | 是否显示红点 | `false` 表示不显示未读红点 |
| `noPersist` | bool | `false` | 是否不存储到本地 | 临时消息（如"正在输入..."） |
| `syncOnce` | bool | `false` | 是否只同步一次 | 离线推送消息 |

#### 4.5.3 Setting 消息设置

| 字段名 | 类型 | 默认值 | 说明 | 使用场景 |
|-------|------|--------|------|---------|
| `receipt` | int | `0` | 是否开启消息回执 | 需要知道对方是否已读 |
| `topic` | int | `0` | 是否话题消息 | 群内话题讨论 |
| `stream` | int | `0` | 是否流消息（实时传输） | 大文件传输 |

#### 4.5.4 使用 WKSendOptions 示例

```dart
import 'package:wukongimfluttersdk/entity/msg.dart';

// 发送不显示红点的消息
Future<void> sendSilentMessage(String text, String targetUID) async {
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  // 创建配置选项
  WKSendOptions options = WKSendOptions();
  options.header.redDot = false;  // 不显示红点
  
  await WKIM.shared.messageManager.sendWithOption(textContent, channel, options);
}

// 发送临时消息（不存储）
Future<void> sendTempMessage(String text, String targetUID) async {
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  WKSendOptions options = WKSendOptions();
  options.header.noPersist = true;  // 不存储到本地
  options.header.redDot = false;   // 不显示红点
  
  await WKIM.shared.messageManager.sendWithOption(textContent, channel, options);
}

// 发送阅后即焚消息（30秒后删除）
Future<void> sendFlameMessage(String text, String targetUID) async {
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  WKSendOptions options = WKSendOptions();
  options.expire = 30;  // 30秒后过期
  
  await WKIM.shared.messageManager.sendWithOption(textContent, channel, options);
}

// 发送带回执的消息
Future<void> sendReceiptMessage(String text, String targetUID) async {
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
  
  WKSendOptions options = WKSendOptions();
  options.setting.receipt = 1;  // 开启消息回执
  
  await WKIM.shared.messageManager.sendWithOption(textContent, channel, options);
}
```

### 4.6 发送状态监听

SDK 提供了消息发送状态的监听，可以实时了解消息的发送进度和结果。

#### 4.6.1 消息发送状态

| 状态值 | 常量 | 说明 | UI 展示 |
|-------|------|------|---------|
| 0 | `WKSendMsgResult.sendLoading` | 发送中 | 转圈动画 |
| 1 | `WKSendMsgResult.sendSuccess` | 发送成功 | 显示单勾或双勾 |
| 2 | `WKSendMsgResult.sendFail` | 发送失败 | 显示感叹号，可重发 |

#### 4.6.2 监听消息刷新

SDK 在消息状态变化时会触发 `addOnRefreshMsgListener` 监听器：

```dart
// 监听消息状态变化
WKIM.shared.messageManager.addOnRefreshMsgListener('refresh_key', (WKMsg msg) {
  print('消息状态更新: ${msg.messageID}, 状态: ${msg.status}');
  
  // 更新 UI 中对应消息的状态
  updateMessageStatus(msg.messageID, msg.status);
});

// 移除监听器
WKIM.shared.messageManager.removeOnRefreshMsgListener('refresh_key');

// 更新消息状态的示例方法
void updateMessageStatus(String messageID, int status) {
  setState(() {
    for (var msg in _messages) {
      if (msg.messageID == messageID) {
        msg.status = status;
        break;
      }
    }
  });
}
```

#### 4.6.3 完整的消息状态显示

```dart
class MessageStatusWidget extends StatelessWidget {
  final WKMsg message;
  
  const MessageStatusWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    Widget statusIcon;
    
    switch (message.status) {
      case WKSendMsgResult.sendLoading:
        statusIcon = const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
        break;
        
      case WKSendMsgResult.sendSuccess:
        statusIcon = const Icon(Icons.done, size: 16, color: Colors.green);
        break;
        
      case WKSendMsgResult.sendFail:
        statusIcon = Icon(
          Icons.error_outline,
          size: 16,
          color: Colors.red[400],
        );
        break;
    }
    
    return statusIcon;
  }
}

// 在消息列表中使用
Widget buildMessageBubble(WKMsg msg) {
  return Row(
    children: [
      // 消息内容
      Text(msg.messageContent?.displayText() ?? ''),
      const SizedBox(width: 8),
      // 状态图标
      MessageStatusWidget(message: msg),
    ],
  );
}
```

### 4.7 错误处理与重试

#### 4.7.1 常见错误类型

| 错误类型 | 原因 | 解决方案 |
|---------|------|---------|
| 网络错误 | 网络不可用或超时 | 等待网络恢复或重试 |
| 认证失败 | uid 或 token 无效 | 重新登录获取新 token |
| 文件上传失败 | 服务器存储空间不足或文件过大 | 检查文件大小，重新上传 |
| 频道不存在 | channelID 错误或被删除 | 检查 channelID 是否正确 |

#### 4.7.2 错误处理示例

```dart
Future<void> sendMessageWithErrorHandling(
  WKMessageContent content,
  WKChannel channel,
) async {
  try {
    // 发送消息
    WKMsg msg = await WKIM.shared.messageManager.sendMessage(content, channel);
    print('消息发送成功');
    
  } on SocketException catch (e) {
    // 网络错误
    print('网络错误: $e');
    _showErrorDialog('网络错误', '请检查网络连接后重试');
    
  } on TimeoutException catch (e) {
    // 超时错误
    print('请求超时: $e');
    _showErrorDialog('请求超时', '网络请求超时，请重试');
    
  } catch (e) {
    // 其他错误
    print('发送失败: $e');
    _showErrorDialog('发送失败', e.toString());
  }
}

void _showErrorDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('确定'),
        ),
      ],
    ),
  );
}
```

#### 4.7.3 消息重试机制

当消息发送失败时，可以手动重试：

```dart
class MessageSender {
  final Map<String, WKMessageContent> _failedMessages = {};
  
  // 发送消息（带重试功能）
  Future<void> sendMessageWithRetry(
    WKMessageContent content,
    WKChannel channel,
  ) async {
    try {
      // 生成客户端消息编号（用于标识）
      String clientMsgNO = generateClientMsgNO();
      
      // 保存到失败列表（临时）
      _failedMessages[clientMsgNO] = content;
      
      // 发送
      await WKIM.shared.messageManager.sendMessage(content, channel);
      
      // 从失败列表移除
      _failedMessages.remove(clientMsgNO);
      
    } catch (e) {
      print('消息发送失败: $e');
      // 消息仍在 _failedMessages 中，可以重试
    }
  }
  
  // 重试所有失败的消息
  Future<void> retryFailedMessages(String targetUID) async {
    if (_failedMessages.isEmpty) {
      print('没有失败的消息需要重试');
      return;
    }
    
    print('开始重试 ${_failedMessages.length} 条失败消息');
    
    WKChannel channel = WKChannel(targetUID, WKChannelType.personal);
    
    for (var entry in _failedMessages.entries) {
      try {
        await WKIM.shared.messageManager.sendMessage(entry.value, channel);
        print('重试成功: ${entry.key}');
      } catch (e) {
        print('重试失败: ${entry.key}, $e');
      }
    }
    
    _failedMessages.clear();
  }
  
  // 生成客户端消息编号
  String generateClientMsgNO() {
    return '${WKIM.shared.options.uid}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}

// UI 使用：点击重试按钮
class FailedMessageWidget extends StatelessWidget {
  final WKMsg message;
  final VoidCallback onRetry;
  
  const FailedMessageWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 显示重试对话框
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('重新发送'),
            content: const Text('是否重新发送这条消息？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        );
      },
      child: Row(
        children: [
          Text(message.messageContent?.displayText() ?? ''),
          const SizedBox(width: 8),
          Icon(Icons.refresh, color: Colors.orange, size: 20),
        ],
      ),
    );
  }
}
```

#### 4.7.4 文件上传失败重试

对于附件消息（图片、语音、视频），上传失败时需要特殊处理：

```dart
// 监听附件上传
WKIM.shared.messageManager.addOnUploadAttachmentListener('upload_key', (
  WKMsg wkMsg,
  Function(bool isSuccess, WKMsg uploadedMsg) back,
) async {
  try {
    // 判断消息类型
    if (wkMsg.contentType == WkMessageContentType.image) {
      WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
      
      // 上传图片到你的服务器
      String? uploadedUrl = await uploadImageToServer(imageContent.localPath);
      
      if (uploadedUrl == null) {
        // 上传失败
        back(false, wkMsg);
        return;
      }
      
      // 上传成功，更新 URL
      imageContent.url = uploadedUrl;
      wkMsg.messageContent = imageContent;
      back(true, wkMsg);
      
    } else if (wkMsg.contentType == WkMessageContentType.voice) {
      WKVoiceContent voiceContent = wkMsg.messageContent! as WKVoiceContent;
      
      // 上传语音
      String? uploadedUrl = await uploadVoiceToServer(voiceContent.localPath);
      
      if (uploadedUrl == null) {
        back(false, wkMsg);
        return;
      }
      
      voiceContent.url = uploadedUrl;
      wkMsg.messageContent = voiceContent;
      back(true, wkMsg);
      
    } else if (wkMsg.contentType == WkMessageContentType.video) {
      WKVideoContent videoContent = wkMsg.messageContent! as WKVideoContent;
      
      // 上传视频和封面
      String? videoUrl = await uploadVideoToServer(videoContent.localPath);
      String? coverUrl = await uploadImageToServer(videoContent.coverLocalPath);
      
      if (videoUrl == null || coverUrl == null) {
        back(false, wkMsg);
        return;
      }
      
      videoContent.url = videoUrl;
      videoContent.cover = coverUrl;
      wkMsg.messageContent = videoContent;
      back(true, wkMsg);
    }
  } catch (e) {
    print('附件上传失败: $e');
    back(false, wkMsg);
  }
});

// 上传图片示例
Future<String?> uploadImageToServer(String localPath) async {
  try {
    File imageFile = File(localPath);
    
    // 创建 FormData
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.example.com/file/upload'),
    );
    
    // 添加文件
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
    ));
    
    // 发送请求
    var response = await request.send();
    
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      return data['url'];  // 返回服务器 URL
    } else {
      print('上传失败: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('上传异常: $e');
    return null;
  }
}
```

---

**下一章**: [5. 消息接收](#5-消息接收) - 详细讲解消息接收监听器、CMD消息处理、历史消息同步。

## 5. 消息接收

消息接收是 IM 功能的另一核心，WuKongIM SDK 提供了多种监听器来处理不同阶段的消息接收事件。本章将详细介绍新消息监听、消息入库监听、CMD 消息处理、历史消息同步等功能。

### 5.1 addOnNewMsgListener 监听新消息

`addOnNewMsgListener` 用于监听接收到的新消息，这些消息刚从服务器收到，但尚未保存到本地数据库。

#### 5.1.1 触发时机

- 当服务器推送新消息到客户端时
- 消息接收到后立即触发
- 消息尚未保存到数据库
- 消息尚未添加到会话列表

#### 5.1.2 使用场景

| 场景 | 说明 | 示例 |
|-----|------|------|
| 播放提示音 | 收到新消息时播放提示音 | "叮咚" 提示音 |
| 显示通知栏通知 | 在应用后台时显示系统通知 | 推送通知 |
| 更新应用角标 | 更新桌面应用的未读角标 | 图标上的红色数字 |
| 震动反馈 | 收到消息时震动手机 | iOS/Android 震动 |
| LED 灯提示 | 部分 Android 手机 LED 灯闪烁 | 闪烁提示 |

#### 5.1.3 监听器注册与移除

```dart
import 'package:wukongimfluttersdk/wkim.dart';

// 注册新消息监听器
WKIM.shared.messageManager.addOnNewMsgListener(
  'new_msg_key',  // 唯一标识，用于移除监听器
  (WKMsg msg) {
    // 处理新消息
    print('收到新消息: ${msg.content}');
    print('发送者: ${msg.fromUID}');
    print('频道: ${msg.channelID}');
    print('消息类型: ${msg.contentType}');
  },
);

// 移除新消息监听器
WKIM.shared.messageManager.removeOnNewMsgListener('new_msg_key');
```

#### 5.1.4 完整示例：收到消息时播放提示音

```dart
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class MessageNotificationHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInForeground = true;

  /// 初始化通知处理器
  void init() {
    // 注册新消息监听器
    WKIM.shared.messageManager.addOnNewMsgListener('notification_key', (WKMsg msg) {
      handleNewMessage(msg);
    });

    // 监听应用生命周期
    WidgetsBinding.instance.addObserver(_LifecycleObserver(this));
  }

  /// 处理新消息
  void handleNewMessage(WKMsg msg) {
    // 不处理自己的消息
    if (msg.fromUID == WKIM.shared.options.uid) {
      return;
    }

    print('收到新消息: ${msg.messageID}');

    // 播放提示音
    playNotificationSound();

    // 震动（如果支持）
    vibrate();

    // 如果应用在后台，显示系统通知
    if (!_isInForeground) {
      showSystemNotification(msg);
    }

    // 增加未读角标
    incrementBadgeCount();
  }

  /// 播放提示音
  void playNotificationSound() async {
    try {
      // 检查是否开启了声音
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool soundEnabled = prefs.getBool('notification_sound') ?? true;

      if (!soundEnabled) {
        return;
      }

      // 播放默认提示音
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      print('播放提示音成功');
    } catch (e) {
      print('播放提示音失败: $e');
    }
  }

  /// 震动
  void vibrate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool vibrateEnabled = prefs.getBool('notification_vibrate') ?? true;

      if (!vibrateEnabled) {
        return;
      }

      // 检查设备是否支持震动
      bool hasVibrator = await Vibration.hasVibrator() ?? false;

      if (hasVibrator) {
        Vibration.vibrate(duration: 200);
        print('震动成功');
      }
    } catch (e) {
      print('震动失败: $e');
    }
  }

  /// 显示系统通知
  void showSystemNotification(WKMsg msg) async {
    // 这里使用 flutter_local_notifications 插件
    // 示例代码略
    print('显示系统通知: ${msg.messageContent?.displayText()}');
  }

  /// 增加未读角标
  void incrementBadgeCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('badge_count') ?? 0;
    prefs.setInt('badge_count', currentCount + 1);
    print('未读角标: ${currentCount + 1}');
  }

  /// 清除角标
  void clearBadgeCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('badge_count', 0);
    print('清除角标');
  }

  /// 生命周期观察器
  void onAppLifecycleStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isInForeground = true;
        clearBadgeCount();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _isInForeground = false;
        break;
      default:
        break;
    }
  }

  /// 销毁资源
  void dispose() {
    _audioPlayer.dispose();
    WKIM.shared.messageManager.removeOnNewMsgListener('notification_key');
  }
}

/// 生命周期观察器类
class _LifecycleObserver extends WidgetsBindingObserver {
  final MessageNotificationHandler handler;

  _LifecycleObserver(this.handler);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handler.onAppLifecycleStateChanged(state);
  }
}

// 使用示例
class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final MessageNotificationHandler _notificationHandler = MessageNotificationHandler();

  @override
  void initState() {
    super.initState();
    _notificationHandler.init();
  }

  @override
  void dispose() {
    _notificationHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}
```

### 5.2 addOnMsgInsertedListener 监听消息入库

`addOnMsgInsertedListener` 用于监听消息保存到数据库的事件。此时消息已经完整保存，可以安全地用于刷新 UI。

#### 5.2.1 触发时机

- 消息已保存到本地数据库
- 消息已添加到会话列表（如果适用）
- 消息数据完整，可以用于 UI 渲染

#### 5.2.2 addOnNewMsgListener vs addOnMsgInsertedListener

| 对比项 | addOnNewMsgListener | addOnMsgInsertedListener |
|-------|---------------------|--------------------------|
| 触发时机 | 消息刚收到 | 消息已保存到数据库 |
| 是否已存库 | ❌ 否 | ✅ 是 |
| 是否已添加到会话列表 | ❌ 否 | ✅ 是 |
| 主要用途 | 播放提示音、系统通知 | 刷新聊天列表 UI |
| 消息数量 | 单条消息 | 单条消息 |
| 触发频率 | 高（每条消息） | 高（每条消息） |

#### 5.2.3 使用场景

| 场景 | 说明 |
|-----|------|
| 刷新聊天列表 | 消息入库后，在聊天列表中显示新消息 |
| 更新会话列表 | 消息入库后，更新会话列表的最后一条消息 |
| 更新未读数 | 消息入库后，更新会话的未读数 |
| 滚动到底部 | 在当前聊天页面，收到消息后滚动到底部 |

#### 5.2.4 监听器注册与移除

```dart
// 注册消息入库监听器
WKIM.shared.messageManager.addOnMsgInsertedListener(
  (WKMsg msg) {
    print('消息已入库: ${msg.messageID}');
    print('发送者: ${msg.fromUID}');
    print('频道: ${msg.channelID}');
    print('消息内容: ${msg.messageContent?.displayText()}');
    
    // 刷新 UI
    refreshMessageList();
  },
);
```

> ⚠️ **注意**: `addOnMsgInsertedListener` 不需要 key 参数，因为只有一个全局监听器。

#### 5.2.5 完整示例：刷新聊天列表 UI

```dart
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<WKUIConversationMsg> _conversations = [];
  final MessageListController _controller = MessageListController();

  @override
  void initState() {
    super.initState();
    _initListener();
    _loadConversations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 初始化监听器
  void _initListener() {
    // 监听消息入库，刷新会话列表
    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      print('收到新消息，刷新会话列表');
      
      // 检查是否是当前列表中的会话
      int index = _conversations.indexWhere(
        (conv) => conv.channelID == msg.channelID && 
                  conv.channelType == msg.channelType,
      );
      
      if (index != -1) {
        // 会话已存在，更新
        setState(() {
          _conversations[index].wkMsg = msg;
          _conversations[index].lastMsgTimestamp = msg.timestamp;
          _conversations[index].unreadCount++;
        });
      } else {
        // 新会话，重新加载
        _loadConversations();
      }
    });

    // 监听会话列表刷新
    WKIM.shared.conversationManager.addOnRefreshListener('refresh_key', (List<WKUIConversationMsg> uiMsgs) {
      print('会话列表刷新: ${uiMsgs.length} 条');
      _loadConversations();
    });
  }

  /// 加载会话列表
  Future<void> _loadConversations() async {
    List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.queryConversationList();
    
    setState(() {
      _conversations.clear();
      _conversations.addAll(conversations);
    });
  }

  /// 跳转到聊天页面
  void _openChat(WKUIConversationMsg conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          channelID: conversation.channelID,
          channelType: conversation.channelType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
      ),
      body: _conversations.isEmpty
        ? const Center(child: Text('暂无消息'))
        : ListView.builder(
            itemCount: _conversations.length,
            itemBuilder: (context, index) {
              WKUIConversationMsg conversation = _conversations[index];
              return _buildConversationItem(conversation);
            },
          ),
    );
  }

  /// 构建会话列表项
  Widget _buildConversationItem(WKUIConversationMsg conversation) {
    String channelName = conversation.wkChannel?.channelName ?? '未知';
    String lastMessage = conversation.wkMsg?.messageContent?.displayText() ?? '';
    int unreadCount = conversation.unreadCount;

    return ListTile(
      leading: CircleAvatar(
        child: Text(channelName[0]),
      ),
      title: Text(channelName),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: unreadCount > 0
        ? Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$unreadCount',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        : null,
      onTap: () => _openChat(conversation),
    );
  }
}
```

### 5.3 CMD 消息处理

CMD 消息（Command Message）是系统命令消息，用于通知客户端执行特定操作，如消息撤回、频道信息更新、未读数清除等。

#### 5.3.1 什么是 CMD 消息？

CMD 消息是 WuKongIM Server 主动发送给客户端的系统命令，用于：
- 消息撤回通知
- 用户/群组信息更新通知
- 未读数清除通知

#### 5.3.2 3 种 CMD 消息类型

| CMD 类型 | 参数 | 触发时机 | 处理方式 |
|---------|------|---------|---------|
| `messageRevoke` | `channel_id`, `channel_type` | 消息被撤回 | 同步消息扩展，删除本地消息 |
| `channelUpdate` | `channel_id`, `channel_type` | 用户/群组信息变更 | 获取最新的用户/群组信息 |
| `unreadClear` | `channel_id`, `channel_type`, `unread` | 未读数被清除 | 更新本地未读数 |

#### 5.3.3 监听 CMD 消息

```dart
// 监听 CMD 消息
WKIM.shared.cmdManager.addOnCmdListener(
  'cmd_key',  // 唯一标识
  (WKCmd cmd) async {
    print('收到 CMD 消息: ${cmd.cmd}');
    print('参数: ${cmd.param}');
    
    // 根据 cmd 类型处理
    if (cmd.cmd == 'messageRevoke') {
      await handleMessageRevoke(cmd);
    } else if (cmd.cmd == 'channelUpdate') {
      await handleChannelUpdate(cmd);
    } else if (cmd.cmd == 'unreadClear') {
      handleUnreadClear(cmd);
    }
  },
);

// 移除监听器
WKIM.shared.cmdManager.removeOnCmdListener('cmd_key');
```

#### 5.3.4 处理 messageRevoke 消息撤回

当一条消息被撤回时，服务器会发送 `messageRevoke` CMD 消息通知客户端。

```dart
/// 处理消息撤回
Future<void> handleMessageRevoke(WKCmd cmd) async {
  String channelID = cmd.param['channel_id'] ?? '';
  int channelType = cmd.param['channel_type'] ?? 0;
  
  print('收到消息撤回通知: $channelID, $channelType');
  
  if (channelID.isEmpty) {
    return;
  }
  
  // 获取当前频道的最大扩展版本号
  int maxVersion = await WKIM.shared.messageManager.getMaxExtraVersionWithChannel(
    channelID,
    channelType,
  );
  
  print('当前最大扩展版本号: $maxVersion');
  
  // 调用后端 API 同步消息扩展
  await syncMessageExtra(channelID, channelType, maxVersion);
}

/// 同步消息扩展（需要调用后端 API）
Future<void> syncMessageExtra(String channelID, int channelType, int version) async {
  try {
    // 调用你的后端 API
    // POST /api/message/extra/sync
    var response = await http.post(
      Uri.parse('https://api.example.com/message/extra/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_id': channelID,
        'channel_type': channelType,
        'version': version,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('同步消息扩展成功');
      
      // SDK 会自动更新消息状态
      // 被撤回的消息会显示为"消息已撤回"
    }
  } catch (e) {
    print('同步消息扩展失败: $e');
  }
}
```

#### 5.3.5 处理 channelUpdate 频道更新

当用户信息（个人）或群组信息发生变更时，服务器会发送 `channelUpdate` CMD 消息通知客户端。

```dart
/// 处理频道更新
Future<void> handleChannelUpdate(WKCmd cmd) async {
  String channelID = cmd.param['channel_id'] ?? '';
  int channelType = cmd.param['channel_type'] ?? 0;
  
  print('收到频道更新通知: $channelID, $channelType');
  
  if (channelID.isEmpty) {
    return;
  }
  
  if (channelType == WKChannelType.personal) {
    // 个人频道：获取用户信息
    await getUserInfo(channelID);
  } else if (channelType == WKChannelType.group) {
    // 群组频道：获取群组信息
    await getGroupInfo(channelID);
  }
}

/// 获取用户信息
Future<void> getUserInfo(String uid) async {
  try {
    print('获取用户信息: $uid');
    
    // 调用你的后端 API
    // GET /api/user/{uid}
    var response = await http.get(
      Uri.parse('https://api.example.com/user/$uid'),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      
      // 更新或创建频道信息
      WKChannel channel = WKChannel(uid, WKChannelType.personal);
      channel.channelName = data['nickname'] ?? '';
      channel.avatar = data['avatar'] ?? '';
      
      // 保存到本地
      await WKIM.shared.channelManager.saveOrUpdateChannel(channel);
      
      print('用户信息更新成功: ${channel.channelName}');
    }
  } catch (e) {
    print('获取用户信息失败: $e');
  }
}

/// 获取群组信息
Future<void> getGroupInfo(String groupId) async {
  try {
    print('获取群组信息: $groupId');
    
    // 调用你的后端 API
    // GET /api/group/{groupId}
    var response = await http.get(
      Uri.parse('https://api.example.com/group/$groupId'),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      
      // 更新或创建频道信息
      WKChannel channel = WKChannel(groupId, WKChannelType.group);
      channel.channelName = data['group_name'] ?? '';
      channel.avatar = data['avatar'] ?? '';
      
      // 保存到本地
      await WKIM.shared.channelManager.saveOrUpdateChannel(channel);
      
      print('群组信息更新成功: ${channel.channelName}');
    }
  } catch (e) {
    print('获取群组信息失败: $e');
  }
}
```

#### 5.3.6 处理 unreadClear 未读数清除

当未读数被清除（用户在另一个设备阅读了消息）时，服务器会发送 `unreadClear` CMD 消息通知客户端。

```dart
/// 处理未读数清除
void handleUnreadClear(WKCmd cmd) {
  String channelID = cmd.param['channel_id'] ?? '';
  int channelType = cmd.param['channel_type'] ?? 0;
  int unread = cmd.param['unread'] ?? 0;
  
  print('收到未读数清除通知: $channelID, $channelType, $unread');
  
  if (channelID.isEmpty) {
    return;
  }
  
  // 更新本地未读数
  WKIM.shared.conversationManager.updateRedDot(
    channelID,
    channelType,
    unread,
  );
  
  print('未读数已更新: $unread');
}
```

#### 5.3.7 完整 CMD 消息处理示例

```dart
class CMDMessageHandler {
  /// 初始化 CMD 监听器
  static void init() {
    WKIM.shared.cmdManager.addOnCmdListener('cmd_handler', (WKCmd cmd) async {
      print('收到 CMD 消息: ${cmd.cmd}');
      print('参数: ${cmd.param}');
      
      switch (cmd.cmd) {
        case 'messageRevoke':
          await handleMessageRevoke(cmd);
          break;
        case 'channelUpdate':
          await handleChannelUpdate(cmd);
          break;
        case 'unreadClear':
          handleUnreadClear(cmd);
          break;
        default:
          print('未知的 CMD 消息: ${cmd.cmd}');
      }
    });
  }

  /// 处理消息撤回
  static Future<void> handleMessageRevoke(WKCmd cmd) async {
    String channelID = cmd.param['channel_id'] ?? '';
    int channelType = cmd.param['channel_type'] ?? 0;
    
    if (channelID.isEmpty) return;
    
    // 获取最大扩展版本号
    int maxVersion = await WKIM.shared.messageManager.getMaxExtraVersionWithChannel(
      channelID,
      channelType,
    );
    
    // 同步消息扩展
    await BackendAPI.syncMessageExtra(channelID, channelType, maxVersion);
  }

  /// 处理频道更新
  static Future<void> handleChannelUpdate(WKCmd cmd) async {
    String channelID = cmd.param['channel_id'] ?? '';
    int channelType = cmd.param['channel_type'] ?? 0;
    
    if (channelID.isEmpty) return;
    
    if (channelType == WKChannelType.personal) {
      await BackendAPI.getUserInfo(channelID);
    } else if (channelType == WKChannelType.group) {
      await BackendAPI.getGroupInfo(channelID);
    }
  }

  /// 处理未读数清除
  static void handleUnreadClear(WKCmd cmd) {
    String channelID = cmd.param['channel_id'] ?? '';
    int channelType = cmd.param['channel_type'] ?? 0;
    int unread = cmd.param['unread'] ?? 0;
    
    if (channelID.isEmpty) return;
    
    WKIM.shared.conversationManager.updateRedDot(
      channelID,
      channelType,
      unread,
    );
  }

  /// 销毁监听器
  static void dispose() {
    WKIM.shared.cmdManager.removeOnCmdListener('cmd_handler');
  }
}

// 后端 API 调用类
class BackendAPI {
  static Future<void> syncMessageExtra(
    String channelID,
    int channelType,
    int version,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('https://api.example.com/message/extra/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'channel_id': channelID,
          'channel_type': channelType,
          'version': version,
        }),
      );
      print('同步消息扩展: ${response.statusCode}');
    } catch (e) {
      print('同步失败: $e');
    }
  }

  static Future<void> getUserInfo(String uid) async {
    try {
      var response = await http.get(
        Uri.parse('https://api.example.com/user/$uid'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        WKChannel channel = WKChannel(uid, WKChannelType.personal);
        channel.channelName = data['nickname'];
        channel.avatar = data['avatar'];
        await WKIM.shared.channelManager.saveOrUpdateChannel(channel);
      }
    } catch (e) {
      print('获取用户信息失败: $e');
    }
  }

  static Future<void> getGroupInfo(String groupId) async {
    try {
      var response = await http.get(
        Uri.parse('https://api.example.com/group/$groupId'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        WKChannel channel = WKChannel(groupId, WKChannelType.group);
        channel.channelName = data['group_name'];
        channel.avatar = data['avatar'];
        await WKIM.shared.channelManager.saveOrUpdateChannel(channel);
      }
    } catch (e) {
      print('获取群组信息失败: $e');
    }
  }
}
```

### 5.4 历史消息同步

当用户进入聊天页面时，需要同步历史消息。WuKongIM SDK 提供了 `addOnSyncChannelMsgListener` 监听器来处理后端的历史消息同步请求。

#### 5.4.1 同步触发时机

- 用户首次进入聊天页面
- 用户向上滚动消息列表，需要加载更多历史消息
- 连接成功后同步离线消息

#### 5.4.2 监听器注册

```dart
// 监听历史消息同步请求
WKIM.shared.messageManager.addOnSyncChannelMsgListener(
  (String channelID,
   int channelType,
   int startMessageSeq,
   int endMessageSeq,
   int limit,
   int pullMode,
   Function(List<WKMsg> msgs) back) {
    
    print('请求同步历史消息:');
    print('  频道ID: $channelID');
    print('  频道类型: $channelType');
    print('  起始序号: $startMessageSeq');
    print('  结束序号: $endMessageSeq');
    print('  限制条数: $limit');
    print('  拉取模式: $pullMode');
    
    // 调用后端 API 获取历史消息
    syncHistoryMessages(
      channelID,
      channelType,
      startMessageSeq,
      endMessageSeq,
      limit,
      back,
    );
  },
);
```

#### 5.4.3 参数说明

| 参数名 | 类型 | 说明 | 示例 |
|-------|------|------|------|
| `channelID` | String | 频道 ID | `"user_123"` |
| `channelType` | int | 频道类型（1=个人，2=群组） | `1` |
| `startMessageSeq` | int | 起始消息序号（不包含） | `100` |
| `endMessageSeq` | int | 结束消息序号（包含） | `150` |
| `limit` | int | 最大返回条数 | `20` |
| `pullMode` | int | 拉取模式 | `0` |
| `back` | Function | 回调函数，必须调用 | `back(messages)` |

#### 5.4.4 调用后端 API 同步历史消息

```dart
/// 同步历史消息
Future<void> syncHistoryMessages(
  String channelID,
  int channelType,
  int startMessageSeq,
  int endMessageSeq,
  int limit,
  Function(List<WKMsg> msgs) back,
) async {
  try {
    // 调用你的后端 API
    // POST /api/message/sync
    var response = await http.post(
      Uri.parse('https://api.example.com/message/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_id': channelID,
        'channel_type': channelType,
        'start_message_seq': startMessageSeq,
        'end_message_seq': endMessageSeq,
        'limit': limit,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> messages = data['messages'] ?? [];
      
      // 解析消息列表
      List<WKMsg> wkMsgs = messages.map((msgJson) {
        return parseMessage(msgJson);
      }).toList();
      
      print('获取到 ${wkMsgs.length} 条历史消息');
      
      // 调用回调，返回消息列表
      back(wkMsgs);
    } else {
      print('同步历史消息失败: ${response.statusCode}');
      back([]);
    }
  } catch (e) {
    print('同步历史消息异常: $e');
    back([]);
  }
}

/// 解析后端返回的消息
WKMsg parseMessage(Map<String, dynamic> msgJson) {
  WKMsg msg = WKMsg();
  msg.messageID = msgJson['message_id'] ?? '';
  msg.messageSeq = msgJson['message_seq'] ?? 0;
  msg.clientMsgNO = msgJson['client_msg_no'] ?? '';
  msg.fromUID = msgJson['from_uid'] ?? '';
  msg.channelID = msgJson['channel_id'] ?? '';
  msg.channelType = msgJson['channel_type'] ?? 0;
  msg.contentType = msgJson['content_type'] ?? 0;
  msg.content = msgJson['content'] ?? '';
  msg.timestamp = msgJson['timestamp'] ?? 0;
  
  // 解析消息内容
  var contentJson = jsonDecode(msg.content);
  msg.messageContent = WKIM.shared.messageManager.getMessageModel(
    msg.contentType,
    contentJson,
  );
  
  return msg;
}
```

#### 5.4.5 完整历史消息同步示例

```dart
class HistoryMessageLoader {
  final String channelID;
  final int channelType;
  final List<WKMsg> _messages = [];
  bool _isLoading = false;
  bool _hasMore = true;

  HistoryMessageLoader({
    required this.channelID,
    required this.channelType,
  });

  /// 初始化监听器
  void init() {
    WKIM.shared.messageManager.addOnSyncChannelMsgListener(
      'history_key',
      _onSyncChannelMsg,
    );
  }

  /// 处理历史消息同步请求
  Future<void> _onSyncChannelMsg(
    String channelID,
    int channelType,
    int startMessageSeq,
    int endMessageSeq,
    int limit,
    int pullMode,
    Function(List<WKMsg>) back,
  ) async {
    // 只处理当前频道的同步请求
    if (channelID != this.channelID || channelType != this.channelType) {
      return;
    }

    print('同步历史消息: $startMessageSeq - $endMessageSeq (limit: $limit)');

    // 调用后端 API
    List<WKMsg> messages = await BackendAPI.syncHistoryMessages(
      channelID,
      channelType,
      startMessageSeq,
      endMessageSeq,
      limit,
    );

    // 返回消息
    back(messages);
  }

  /// 加载历史消息（从后端）
  Future<void> loadHistoryMessages() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;

    try {
      // 获取最早的消息序号
      int oldestSeq = 0;
      if (_messages.isNotEmpty) {
        oldestSeq = _messages.last.messageSeq;
      }

      print('加载历史消息，起始序号: $oldestSeq');

      // 调用 SDK 方法触发同步
      List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
        channelID,
        channelType,
        oldestSeq: oldestSeq,
        limit: 20,
        order: WKOrder.asc,
      );

      if (messages.isEmpty) {
        _hasMore = false;
        print('没有更多历史消息');
      } else {
        _messages.addAll(messages.reversed);  // SDK 返回的是倒序，需要反转
        print('加载了 ${messages.length} 条历史消息');
      }
    } catch (e) {
      print('加载历史消息失败: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// 获取所有消息
  List<WKMsg> get messages => _messages;
  
  /// 是否正在加载
  bool get isLoading => _isLoading;
  
  /// 是否还有更多消息
  bool get hasMore => _hasMore;

  /// 销毁监听器
  void dispose() {
    WKIM.shared.messageManager.removeOnSyncChannelMsgListener('history_key');
  }
}
```

### 5.5 消息去重与排序

#### 5.5.1 消息去重

SDK 使用 `clientMsgNO`（客户端消息编号）来去重消息。

**去重规则**:
- 每条消息都有唯一的 `clientMsgNO`
- 相同 `clientMsgNO` 的消息被视为重复消息
- SDK 会自动过滤重复消息

**生成 clientMsgNO**:

```dart
/// 生成客户端消息编号
String generateClientMsgNO() {
  // 格式: {uid}_{timestamp}_{random}
  String uid = WKIM.shared.options.uid;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int random = Random().nextInt(10000);
  
  return '${uid}_${timestamp}_$random';
}

// 发送消息时使用
WKTextContent content = WKTextContent('消息内容');
WKMsg msg = WKMsg();
msg.clientMsgNO = generateClientMsgNO();  // 设置客户端消息编号
msg.messageContent = content;
```

#### 5.5.2 消息排序

SDK 使用 `messageSeq`（消息序号）来排序消息。

**排序规则**:
- `messageSeq` 是消息在频道内的序号
- 序号越大，消息越新
- 消息列表按照 `messageSeq` 升序排列

**排序示例**:

```dart
/// 排序消息列表
List<WKMsg> sortMessages(List<WKMsg> messages) {
  // 按照 messageSeq 升序排列
  messages.sort((a, b) => a.messageSeq.compareTo(b.messageSeq));
  return messages;
}

/// 去重并排序
List<WKMsg> deduplicateAndSort(List<WKMsg> messages) {
  // 使用 clientMsgNO 去重
  final Map<String, WKMsg> uniqueMessages = {};
  
  for (var msg in messages) {
    uniqueMessages[msg.clientMsgNO] = msg;
  }
  
  // 转换为列表并排序
  List<WKMsg> result = uniqueMessages.values.toList();
  return sortMessages(result);
}
```

#### 5.5.3 完整示例：消息列表管理

```dart
class MessageListManager {
  final Map<String, WKMsg> _messages = {};  // key: messageID
  final List<WKMsg> _sortedMessages = [];

  /// 添加消息
  void addMessage(WKMsg msg) {
    // 去重
    if (_messages.containsKey(msg.messageID)) {
      print('消息已存在，跳过: ${msg.messageID}');
      return;
    }

    _messages[msg.messageID] = msg;
    _rebuildSortedMessages();
  }

  /// 添加多条消息
  void addMessages(List<WKMsg> messages) {
    for (var msg in messages) {
      _messages[msg.messageID] = msg;
    }
    _rebuildSortedMessages();
  }

  /// 删除消息
  void removeMessage(String messageID) {
    _messages.remove(messageID);
    _rebuildSortedMessages();
  }

  /// 更新消息
  void updateMessage(WKMsg msg) {
    if (_messages.containsKey(msg.messageID)) {
      _messages[msg.messageID] = msg;
      _rebuildSortedMessages();
    }
  }

  /// 重新构建排序后的消息列表
  void _rebuildSortedMessages() {
    _sortedMessages.clear();
    _sortedMessages.addAll(_messages.values);

    // 按照 messageSeq 升序排列
    _sortedMessages.sort((a, b) => a.messageSeq.compareTo(b.messageSeq));
  }

  /// 获取排序后的消息列表
  List<WKMsg> get sortedMessages => List.unmodifiable(_sortedMessages);

  /// 获取消息总数
  int get count => _messages.length;

  /// 清空所有消息
  void clear() {
    _messages.clear();
    _sortedMessages.clear();
  }

  /// 查找消息
  WKMsg? findMessage(String messageID) {
    return _messages[messageID];
  }

  /// 获取某个序号范围的消息
  List<WKMsg> getMessagesBySeqRange(int startSeq, int endSeq) {
    return _sortedMessages.where((msg) {
      return msg.messageSeq >= startSeq && msg.messageSeq <= endSeq;
    }).toList();
  }
}

// 使用示例
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessageListManager _messageManager = MessageListManager();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initListeners();
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 初始化监听器
  void _initListeners() {
    // 监听新消息
    WKIM.shared.messageManager.addOnNewMsgListener('chat_key', (WKMsg msg) {
      if (msg.channelID == 'current_channel_id') {
        _messageManager.addMessage(msg);
        _scrollToBottom();
      }
    });

    // 监听消息刷新
    WKIM.shared.messageManager.addOnRefreshMsgListener('refresh_key', (WKMsg msg) {
      _messageManager.updateMessage(msg);
    });
  }

  /// 加载初始消息
  Future<void> _loadInitialMessages() async {
    List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
      'current_channel_id',
      WKChannelType.personal,
      oldestOrderSeq: 0,
      limit: 20,
      order: WKOrder.desc,
    );

    _messageManager.addMessages(messages);
  }

  /// 滚动到底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<WKMsg> messages = _messageManager.sortedMessages;

    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          WKMsg msg = messages[index];
          return MessageBubble(message: msg);
        },
      ),
    );
  }
}
```

---

**下一章**: [6. 会话管理](#6-会话管理) - 详细讲解会话列表查询、未读数管理、置顶、免打扰等功能。

## 6. 会话管理

会话（Conversation）是聊天的会话记录列表，每个会话代表一个聊天对象（个人或群组）。WuKongIM SDK 提供了完整的会话管理功能，包括查询、同步、未读数管理、置顶、免打扰等。

### 6.1 获取会话列表

获取所有会话列表，用于在"消息"页面显示聊天列表。

#### 6.1.1 查询会话列表

```dart
/// 查询所有会话列表
Future<List<WKUIConversationMsg>> queryConversationList() async {
  List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.queryConversationList();
  print('查询到 ${conversations.length} 个会话');
  return conversations;
}
```

#### 6.1.2 WKUIConversationMsg 字段说明

| 字段名 | 类型 | 说明 | 示例 |
|-------|------|------|------|
| `channelID` | String | 频道 ID | `"user_123"` |
| `channelType` | int | 频道类型（1=个人，2=群组） | `1` |
| `lastMsgTimestamp` | int | 最后一条消息的时间戳 | `1640995200000` |
| `unreadCount` | int | 未读消息数量 | `5` |
| `wkChannel` | WKChannel? | 频道信息（包含昵称、头像等） | - |
| `wkMsg` | WKMsg? | 最后一条消息 | - |
| `reminderList` | List<WKReminder>? | 提醒列表（@消息等） | - |

#### 6.1.3 完整示例：会话列表 UI

```dart
class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  final List<WKUIConversationMsg> _conversations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _initListeners();
  }

  @override
  void dispose() {
    WKIM.shared.conversationManager.removeOnRefreshListener('conv_list');
    super.dispose();
  }

  /// 初始化监听器
  void _initListeners() {
    // 监听会话列表刷新
    WKIM.shared.conversationManager.addOnRefreshListener('conv_list', (List<WKUIConversationMsg> uiMsgs) {
      print('会话列表刷新: ${uiMsgs.length} 条');
      _loadConversations();
    });
  }

  /// 加载会话列表
  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.queryConversationList();
      
      setState(() {
        _conversations.clear();
        _conversations.addAll(conversations);
      });
      
      print('加载了 ${conversations.length} 个会话');
    } catch (e) {
      print('加载会话列表失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 跳转到聊天页面
  void _openChat(WKUIConversationMsg conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          channelID: conversation.channelID,
          channelType: conversation.channelType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _conversations.isEmpty
          ? const Center(child: Text('暂无消息'))
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                return _buildConversationItem(_conversations[index]);
              },
            ),
    );
  }

  /// 构建会话列表项
  Widget _buildConversationItem(WKUIConversationMsg conversation) {
    WKChannel? channel = conversation.wkChannel;
    WKMsg? lastMsg = conversation.wkMsg;
    
    String title = channel?.channelName ?? '未知';
    String avatar = channel?.avatar ?? '';
    String lastMessage = lastMsg?.messageContent?.displayText() ?? '';
    int unreadCount = conversation.unreadCount;
    
    // 格式化时间
    String timeStr = formatTimestamp(conversation.lastMsgTimestamp);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
        child: avatar.isEmpty ? Text(title[0]) : null,
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () => _openChat(conversation),
    );
  }

  /// 格式化时间戳
  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    
    // 今天
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    
    // 昨天
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return '昨天';
    }
    
    // 本周
    if (now.difference(dateTime).inDays < 7) {
      return '周${dateTime.weekday}';
    }
    
    // 其他：显示日期
    return '${dateTime.month}/${dateTime.day}';
  }
}
```

### 6.2 获取单个会话

根据频道 ID 和类型查询特定会话。

```dart
/// 查询单个会话
Future<WKUIConversationMsg?> queryConversation(String channelID, int channelType) async {
  WKUIConversationMsg? conversation = await WKIM.shared.conversationManager.queryWithChannelID(channelID, channelType);
  
  if (conversation != null) {
    print('查询到会话: $channelID, 未读数: ${conversation.unreadCount}');
  } else {
    print('未找到会话: $channelID');
  }
  
  return conversation;
}
```

### 6.3 会话同步机制

SDK 提供了 `addOnSyncConversationListener` 监听器来处理后端的会话同步请求。

#### 6.3.1 监听会话同步

```dart
// 监听会话同步
WKIM.shared.conversationManager.addOnSyncConversationListener(
  'sync_key',
  (List<int> lastSsgSeqs, int msgCount, int version, Function(List<WKUIConversationMsg>) complete) {
    
    print('会话同步请求:');
    print('  会话列表序号: $lastSsgSeqs');
    print('  消息数量: $msgCount');
    print('  版本号: $version');
    
    // 调用后端 API 同步会话列表
    syncConversations(lastSsgSeqs, msgCount, version, complete);
  },
);
```

#### 6.3.2 调用后端 API 同步会话

```dart
/// 同步会话列表
Future<void> syncConversations(
  List<int> lastSsgSeqs,
  int msgCount,
  int version,
  Function(List<WKUIConversationMsg>) complete,
) async {
  try {
    // 调用你的后端 API
    // POST /api/conversation/sync
    var response = await http.post(
      Uri.parse('https://api.example.com/conversation/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'last_ssg_seqs': lastSsgSeqs,
        'msg_count': msgCount,
        'version': version,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> convList = data['conversations'] ?? [];
      
      // 解析会话列表
      List<WKUIConversationMsg> conversations = convList.map((convJson) {
        return parseConversation(convJson);
      }).toList();
      
      print('同步了 ${conversations.length} 个会话');
      
      // 调用回调，返回会话列表
      complete(conversations);
    } else {
      print('同步会话失败: ${response.statusCode}');
      complete([]);
    }
  } catch (e) {
    print('同步会话异常: $e');
    complete([]);
  }
}

/// 解析后端返回的会话
WKUIConversationMsg parseConversation(Map<String, dynamic> convJson) {
  WKUIConversationMsg conversation = WKUIConversationMsg();
  conversation.channelID = convJson['channel_id'] ?? '';
  conversation.channelType = convJson['channel_type'] ?? 0;
  conversation.unreadCount = convJson['unread_count'] ?? 0;
  conversation.lastMsgTimestamp = convJson['last_msg_timestamp'] ?? 0;
  
  // 解析频道信息
  var channelJson = convJson['channel'];
  if (channelJson != null) {
    WKChannel channel = WKChannel(conversation.channelID, conversation.channelType);
    channel.channelName = channelJson['channel_name'] ?? '';
    channel.avatar = channelJson['avatar'] ?? '';
    conversation.wkChannel = channel;
  }
  
  // 解析最后一条消息
  var msgJson = convJson['last_msg'];
  if (msgJson != null) {
    conversation.wkMsg = parseMessage(msgJson);
  }
  
  return conversation;
}
```

### 6.4 未读数管理

#### 6.4.1 获取总未读数

```dart
/// 获取所有会话的总未读数
Future<int> getTotalUnreadCount() async {
  int totalUnread = await WKIM.shared.conversationManager.getAllUnreadCount();
  print('总未读数: $totalUnread');
  return totalUnread;
}
```

#### 6.4.2 标记已读

当用户阅读某条消息后，需要标记为已读。

```dart
/// 标记频道已读
Future<void> markChannelRead(String channelID, int channelType) async {
  // 调用 SDK 方法标记已读
  await WKIM.shared.messageManager.clearUnread(channelID, channelType);
  
  print('频道 $channelID 已标记为已读');
}
```

#### 6.4.3 清除未读红点

通过 CMD 消息或手动调用 SDK 方法清除未读数。

```dart
/// 更新未读红点
Future<void> updateRedDot(String channelID, int channelType, int unread) async {
  await WKIM.shared.conversationManager.updateRedDot(channelID, channelType, unread);
  print('未读数更新: $channelID = $unread');
}
```

#### 6.4.4 完整示例：阅读消息时更新未读数

```dart
class ChatPage extends StatefulWidget {
  final String channelID;
  final int channelType;
  
  const ChatPage({
    required this.channelID,
    required this.channelType,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _hasMarkedRead = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    
    // 监听滚动事件，标记已读
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动事件
  void _onScroll() {
    // 只标记一次
    if (_hasMarkedRead) {
      return;
    }
    
    // 滚动到底部时标记已读
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _markAsRead();
      _hasMarkedRead = true;
    }
  }

  /// 标记为已读
  Future<void> _markAsRead() async {
    try {
      // 清除未读数
      await WKIM.shared.messageManager.clearUnread(
        widget.channelID,
        widget.channelType,
      );
      
      print('已标记为已读');
    } catch (e) {
      print('标记已读失败: $e');
    }
  }

  /// 加载消息
  Future<void> _loadMessages() async {
    List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
      widget.channelID,
      widget.channelType,
      oldestOrderSeq: 0,
      limit: 20,
      order: WKOrder.desc,
    );
    
    print('加载了 ${messages.length} 条消息');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('聊天')),
      body: ListView(
        controller: _scrollController,
        children: const [
          // 消息列表
        ],
      ),
    );
  }
}
```

### 6.5 置顶功能

将重要会话置顶到列表顶部。

#### 6.5.1 置顶会话

```dart
/// 置顶会话
Future<void> setConversationTop(String channelID, int channelType, bool isTop) async {
  await WKIM.shared.conversationManager.setTop(channelID, channelType, isTop);
  print('会话 $channelID ${isTop ? "已置顶" : "已取消置顶"}');
}
```

#### 6.5.2 UI 示例：置顶选项

```dart
/// 显示置顶选项对话框
Future<void> showTopOptionDialog(BuildContext context, WKUIConversationMsg conversation) async {
  bool isTop = conversation.wkChannel?.top == 1;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isTop ? '取消置顶' : '置顶会话'),
      content: Text(isTop ? '确定要取消置顶吗？' : '确定要置顶该会话吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setConversationTop(
              conversation.channelID,
              conversation.channelType,
              !isTop,
            );
          },
          child: Text(isTop ? '取消置顶' : '置顶'),
        ),
      ],
    ),
  );
}

// 在会话列表项中使用
Widget _buildConversationItem(WKUIConversationMsg conversation) {
  bool isTop = conversation.wkChannel?.top == 1;
  
  return ListTile(
    title: Text(conversation.wkChannel?.channelName ?? '未知'),
    trailing: IconButton(
      icon: Icon(isTop ? Icons.push_pin : Icons.push_pin_outlined),
      onPressed: () {
        showTopOptionDialog(context, conversation);
      },
    ),
    onTap: () => _openChat(conversation),
  );
}
```

### 6.6 免打扰功能

设置会话免打扰，不接收该会话的消息通知。

#### 6.6.1 设置免打扰

```dart
/// 设置免打扰
Future<void> setConversationMute(String channelID, int channelType, bool isMute) async {
  await WKIM.shared.conversationManager.setMute(channelID, channelType, isMute);
  print('会话 $channelID ${isMute ? "已免打扰" : "已取消免打扰"}');
}
```

#### 6.6.2 UI 示例：免打扰开关

```dart
/// 显示免打扰选项
Future<void> showMuteOptionDialog(BuildContext context, WKUIConversationMsg conversation) async {
  bool isMute = conversation.wkChannel?.mute == 1;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isMute ? '取消免打扰' : '消息免打扰'),
      content: Text(isMute ? '确定要取消免打扰吗？' : '开启后，将不再接收该会话的消息通知'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setConversationMute(
              conversation.channelID,
              conversation.channelType,
              !isMute,
            );
          },
          child: Text(isMute ? '取消免打扰' : '开启免打扰'),
        ),
      ],
    ),
  );
}
```

### 6.7 删除会话

删除会话及其所有消息。

#### 6.7.1 删除会话

```dart
/// 删除会话
Future<void> deleteConversation(String channelID, int channelType) async {
  await WKIM.shared.conversationManager.deleteConversation(channelID, channelType);
  print('会话 $channelID 已删除');
}
```

#### 6.7.2 UI 示例：删除确认

```dart
/// 显示删除确认对话框
Future<void> showDeleteConfirmDialog(
  BuildContext context,
  WKUIConversationMsg conversation,
) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('删除会话'),
      content: const Text('确定要删除该会话吗？删除后无法恢复。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            deleteConversation(
              conversation.channelID,
              conversation.channelType,
            );
            
            // 刷新列表
            _loadConversations();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('删除'),
        ),
      ],
    ),
  );
}
```

### 6.8 完整会话管理示例

```dart
class ConversationManager {
  final List<WKUIConversationMsg> _conversations = [];

  /// 初始化监听器
  void init() {
    // 监听会话列表刷新
    WKIM.shared.conversationManager.addOnRefreshListener('conv_mgr', (List<WKUIConversationMsg> uiMsgs) {
      print('会话列表刷新');
      _loadConversations();
    });
  }

  /// 加载会话列表
  Future<void> _loadConversations() async {
    List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.queryConversationList();
    
    // 排序：置顶的在前面，然后按时间倒序
    conversations.sort((a, b) {
      bool aTop = a.wkChannel?.top == 1;
      bool bTop = b.wkChannel?.top == 1;
      
      if (aTop && !bTop) return -1;
      if (!aTop && bTop) return 1;
      
      return b.lastMsgTimestamp.compareTo(a.lastMsgTimestamp);
    });
    
    _conversations.clear();
    _conversations.addAll(conversations);
  }

  /// 获取会话列表
  List<WKUIConversationMsg> get conversations => List.unmodifiable(_conversations);

  /// 置顶会话
  Future<void> setTop(String channelID, int channelType, bool isTop) async {
    await WKIM.shared.conversationManager.setTop(channelID, channelType, isTop);
    await _loadConversations();
  }

  /// 设置免打扰
  Future<void> setMute(String channelID, int channelType, bool isMute) async {
    await WKIM.shared.conversationManager.setMute(channelID, channelType, isMute);
    await _loadConversations();
  }

  /// 删除会话
  Future<void> delete(String channelID, int channelType) async {
    await WKIM.shared.conversationManager.deleteConversation(channelID, channelType);
    await _loadConversations();
  }

  /// 获取总未读数
  Future<int> getTotalUnread() async {
    return await WKIM.shared.conversationManager.getAllUnreadCount();
  }

  /// 销毁监听器
  void dispose() {
    WKIM.shared.conversationManager.removeOnRefreshListener('conv_mgr');
  }
}
```

---

**下一章**: [7. 数据模型详解](#7-数据模型详解) - 详细讲解 WKMsg、WKChannel、Conversation、Options 等所有数据模型。

## 7. 数据模型详解

WuKongIM SDK 使用多个数据模型来表示消息、频道、会话等核心概念。本章将详细介绍所有数据模型的字段含义和使用方法。

### 7.1 WKMsg - 消息模型

`WKMsg` 是消息的核心模型，包含消息的所有信息。

#### 7.1.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `messageID` | String | ❌ | `""` | 服务器消息ID（全局唯一标识） | `"1234567890"` |
| `messageSeq` | int | ❌ | `0` | 消息序号（频道内顺序，用于排序） | `100` |
| `clientSeq` | int | ❌ | `0` | 客户端序号（本地数据库主键） | `12345` |
| `timestamp` | int | ❌ | `0` | 消息时间戳（毫秒，Unix timestamp） | `1640995200000` |
| `clientMsgNO` | String | ❌ | `""` | 客户端消息编号（用于去重，必须唯一） | `"user123_1640995200000_5678"` |
| `fromUID` | String | ❌ | `""` | 发送者 UID | `"user_456"` |
| `channelID` | String | ❌ | `""` | 频道 ID（会话 ID） | `"user_789"` |
| `channelType` | int | ❌ | `0` | 频道类型（1=个人，2=群组） | `1` |
| `contentType` | int | ❌ | `0` | 内容类型（1=文本，2=图片，4=语音，5=视频） | `1` |
| `content` | String | ❌ | `""` | 消息内容（JSON 字符串） | `'{"content":"你好"}'` |
| `status` | int | ❌ | `0` | 发送状态（0=发送中，1=成功，2=失败） | `1` |
| `header` | MessageHeader | ❌ | `MessageHeader()` | 消息头（红点标识、持久化标识） | - |
| `setting` | IMSetting | ❌ | `IMSetting()` | 消息设置 | - |
| `from` | WKChannel? | ❌ | `null` | 发送者频道信息 | - |
| `channelInfo` | WKChannel? | ❌ | `null` | 会话频道信息 | - |
| `messageContent` | WKMessageContent? | ❌ | `null` | 消息内容实体对象 | `WKTextContent` |
| `remoteExtra` | WKMsgExtra? | ❌ | `null` | 扩展信息（点赞数、回复数等） | - |
| `flame` | int | ❌ | `0` | 是否阅后即焚（0=否，1=是） | `0` |
| `flameSec` | int | ❌ | `0` | 阅后即焚秒数 | `30` |
| `searchableWord` | String? | ❌ | `null` | 搜索关键字 | `"你好"` |
| `orderSeq` | int | ❌ | `0` | 排序序号（用于本地消息排序） | `12345` |
| `topicID` | String | ❌ | `""` | 话题 ID | `"topic_123"` |
| `expireTime` | int | ❌ | `0` | 消息过期时间（秒） | `30` |
| `expireTimestamp` | int | ❌ | `0` | 消息过期时间戳（毫秒） | `1640995230000` |
| `isDeleted` | int | ❌ | `0` | 是否被删除（0=否，1=是） | `0` |

#### 7.1.2 使用示例

```dart
// 创建消息对象
WKMsg msg = WKMsg();
msg.messageID = '1234567890';
msg.messageSeq = 100;
msg.timestamp = DateTime.now().millisecondsSinceEpoch;
msg.clientMsgNO = 'user123_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
msg.fromUID = 'user_456';
msg.channelID = 'user_789';
msg.channelType = WKChannelType.personal;
msg.contentType = WkMessageContentType.text;
msg.content = '{"content":"你好"}';

// 设置消息内容
msg.messageContent = WKTextContent('你好');

// 设置消息头
msg.header = MessageHeader();
msg.header.redDot = true;
msg.header.noPersist = false;
msg.header.syncOnce = false;

// 设置消息设置
msg.setting = IMSetting();
msg.setting.receipt = 0;
msg.setting.topic = 0;
msg.setting.stream = 0;

print('消息对象: ${msg.messageID}');
```

### 7.2 MessageHeader - 消息头

`MessageHeader` 定义消息的元信息。

#### 7.2.1 字段说明

| 字段名 | 类型 | 默认值 | 说明 | 使用场景 |
|-------|------|--------|------|---------|
| `redDot` | bool | `true` | 是否显示红点（未读标识） | `false` 表示不显示未读红点 |
| `noPersist` | bool | `false` | 是否不存储到本地 | 临时消息（如"正在输入..."） |
| `syncOnce` | bool | `false` | 是否只同步一次 | 离线推送消息 |

#### 7.2.2 使用示例

```dart
// 创建消息头
MessageHeader header = MessageHeader();
header.redDot = true;     // 显示红点
header.noPersist = false;  // 存储到本地
header.syncOnce = false;   // 可以多次同步

// 应用到消息
WKMsg msg = WKMsg();
msg.header = header;
```

### 7.3 Setting/IMSetting - 消息设置

`Setting` 定义消息的发送和接收行为。

#### 7.3.1 字段说明

| 字段名 | 类型 | 默认值 | 说明 | 使用场景 |
|-------|------|--------|------|---------|
| `receipt` | int | `0` | 是否开启消息回执 | 需要知道对方是否已读 |
| `topic` | int | `0` | 是否话题消息 | 群内话题讨论 |
| `stream` | int | `0` | 是否流消息（实时传输） | 大文件传输 |

#### 7.3.2 使用示例

```dart
// 创建消息设置
Setting setting = Setting();
setting.receipt = 1;  // 开启消息回执
setting.topic = 0;    // 不是话题消息
setting.stream = 0;   // 不是流消息

// 应用到消息
WKMsg msg = WKMsg();
msg.setting = setting;
```

### 7.4 WKMsgExtra - 消息扩展

`WKMsgExtra` 存储消息的扩展信息，如点赞数、回复数等。

#### 7.4.1 字段说明

| 字段名 | 类型 | 默认值 | 说明 | 示例 |
|-------|------|--------|------|------|
| `messageID` | String | `""` | 消息 ID | `"1234567890"` |
| `channelID` | String | `""` | 频道 ID | `"user_123"` |
| `channelType` | int | `0` | 频道类型 | `1` |
| `readed` | int | `0` | 已读人数 | `5` |
| `readedCount` | int | `0` | 已读次数 | `10` |
| `unreadCount` | int | `0` | 未读人数 | `2` |
| `revoke` | int | `0` | 是否被撤回（0=否，1=是） | `0` |
| `isMutualDeleted` | int | `0` | 是否双方删除（0=否，1=是） | `0` |
| `revoker` | String | `""` | 撤回者 UID | `"user_456"` |
| `extraVersion` | int | `0` | 扩展版本号（用于增量同步） | `100` |
| `contentEdit` | int | `0` | 编辑次数 | `0` |
| `editedAt` | int | `0` | 编辑时间戳 | `0` |

#### 7.4.2 使用示例

```dart
// 创建消息扩展
WKMsgExtra extra = WKMsgExtra();
extra.messageID = '1234567890';
extra.channelID = 'user_123';
extra.channelType = WKChannelType.personal;
extra.readed = 5;
extra.unreadCount = 2;
extra.revoke = 0;
extra.extraVersion = 100;

print('消息扩展: ${extra.messageID}, 已读: ${extra.readed}, 未读: ${extra.unreadCount}');
```

### 7.5 WKMessageContent - 消息内容基类

`WKMessageContent` 是所有消息内容类型的基类。

#### 7.5.1 字段和方法

| 字段/方法名 | 类型 | 说明 |
|-----------|------|------|
| `contentType` | int | 内容类型 |
| `encodeJson()` | `Map<String, dynamic>` | 编码为 JSON（发送时使用） |
| `decodeJson(Map)` | `WKMessageContent` | 从 JSON 解码（接收时使用） |
| `displayText()` | `String` | 获取显示文本（用于 UI 显示） |
| `searchableWord()` | `String` | 获取搜索关键字 |

#### 7.5.2 使用示例

```dart
// 创建自定义消息内容
class CustomMessageContent extends WKMessageContent {
  String customField;
  
  CustomMessageContent(this.customField) {
    contentType = 100;  // 自定义类型
  }
  
  @override
  Map<String, dynamic> encodeJson() {
    return {
      'custom_field': customField,
    };
  }
  
  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    customField = json['custom_field'];
    return this;
  }
  
  @override
  String displayText() {
    return '[自定义消息] $customField';
  }
  
  @override
  String searchableWord() {
    return customField;
  }
}
```

### 7.6 WKTextContent - 文本消息内容

文本消息是最常用的消息类型。

#### 7.6.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `content` | String | ✅ | - | 文本消息内容 | `"你好，世界！"` |
| `contentType` | int | ✅ | `WkMessageContentType.text` | 内容类型（1） | `1` |

#### 7.6.2 使用示例

```dart
// 创建文本消息
WKTextContent textContent = WKTextContent('你好，世界！');
print('显示文本: ${textContent.displayText()}');
print('搜索关键字: ${textContent.searchableWord()}');

// 编码为 JSON（发送）
Map<String, dynamic> json = textContent.encodeJson();
print('编码: $json');
// 输出: {content: 你好，世界！}

// 从 JSON 解码（接收）
WKTextContent decodedContent = WKTextContent('');
decodedContent.decodeJson({'content': '你好，世界！'});
print('解码: ${decodedContent.content}');
```

### 7.7 WKImageContent - 图片消息内容

图片消息包含图片的 URL 和尺寸信息。

#### 7.7.1 继承关系

```
WKMediaMessageContent
    ├── url: String          // 服务器URL
    └── localPath: String    // 本地路径
            └── WKImageContent
                ├── width: int        // 图片宽度
                ├── height: int       // 图片高度
                ├── url: String       // 服务器URL（继承）
                └── localPath: String // 本地路径（继承）
```

#### 7.7.2 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `width` | int | ✅ | - | 图片宽度（像素） | `1920` |
| `height` | int | ✅ | - | 图片高度（像素） | `1080` |
| `url` | String | ❌ | `""` | 服务器图片 URL（上传后设置） | `"https://cdn.example.com/img/abc.jpg"` |
| `localPath` | String | ❌ | `""` | 本地图片路径（发送时使用） | `"/path/to/local/image.jpg"` |
| `contentType` | int | ✅ | `WkMessageContentType.image` | 内容类型（2） | `2` |

#### 7.7.3 使用示例

```dart
// 创建图片消息
WKImageContent imageContent = WKImageContent(1920, 1080);
imageContent.localPath = '/path/to/local/image.jpg';

// 上传后设置 URL
imageContent.url = 'https://cdn.example.com/img/abc.jpg';

print('图片尺寸: ${imageContent.width}x${imageContent.height}');
print('显示文本: ${imageContent.displayText()}');  // [图片]

// 编码为 JSON
Map<String, dynamic> json = imageContent.encodeJson();
print('编码: $json');
// 输出: {width: 1920, height: 1080, url: https://..., localPath: /path/...}
```

### 7.8 WKVoiceContent - 语音消息内容

语音消息包含语音时长、波形等信息。

#### 7.8.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `timeTrad` | int | ✅ | - | 语音时长（秒） | `10` |
| `waveform` | String? | ❌ | `null` | 语音波形（Base64 编码） | `"AAECAw=="` |
| `url` | String | ❌ | `""` | 服务器语音 URL（上传后设置） | `"https://cdn.example.com/voice/abc.mp3"` |
| `localPath` | String | ❌ | `""` | 本地语音文件路径 | `"/path/to/local/voice.mp3"` |
| `contentType` | int | ✅ | `WkMessageContentType.voice` | 内容类型（4） | `4` |

#### 7.8.2 使用示例

```dart
// 创建语音消息
WKVoiceContent voiceContent = WKVoiceContent(10);
voiceContent.localPath = '/path/to/local/voice.mp3';
voiceContent.waveform = 'AAECAw==';  // Base64 编码的波形

// 上传后设置 URL
voiceContent.url = 'https://cdn.example.com/voice/abc.mp3';

print('语音时长: ${voiceContent.timeTrad} 秒');
print('显示文本: ${voiceContent.displayText()}');  // [语音]

// 编码为 JSON
Map<String, dynamic> json = voiceContent.encodeJson();
print('编码: $json');
```

### 7.9 WKVideoContent - 视频消息内容

视频消息包含视频时长、尺寸、封面等信息。

#### 7.9.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `second` | int | ❌ | `0` | 视频时长（秒） | `30` |
| `size` | int | ❌ | `0` | 视频文件大小（字节） | `5242880` (5MB) |
| `width` | int | ❌ | `0` | 视频宽度（像素） | `1920` |
| `height` | int | ❌ | `0` | 视频高度（像素） | `1080` |
| `cover` | String | ❌ | - | 视频封面 URL（上传后设置） | `"https://cdn.example.com/cover/abc.jpg"` |
| `coverLocalPath` | String | ❌ | - | 本地封面图片路径 | `"/path/to/local/cover.jpg"` |
| `url` | String | ❌ | - | 服务器视频 URL（上传后设置） | `"https://cdn.example.com/video/abc.mp4"` |
| `localPath` | String | ❌ | - | 本地视频文件路径 | `"/path/to/local/video.mp4"` |
| `contentType` | int | ✅ | `WkMessageContentType.video` | 内容类型（5） | `5` |

#### 7.9.2 使用示例

```dart
// 创建视频消息
WKVideoContent videoContent = WKVideoContent();
videoContent.second = 30;
videoContent.size = 5242880;  // 5MB
videoContent.width = 1920;
videoContent.height = 1080;
videoContent.localPath = '/path/to/local/video.mp4';
videoContent.coverLocalPath = '/path/to/local/cover.jpg';

// 上传后设置 URL
videoContent.url = 'https://cdn.example.com/video/abc.mp4';
videoContent.cover = 'https://cdn.example.com/cover/abc.jpg';

print('视频信息: ${videoContent.width}x${videoContent.height}, ${videoContent.second}秒');
print('显示文本: ${videoContent.displayText()}');  // [视频]

// 编码为 JSON
Map<String, dynamic> json = videoContent.encodeJson();
print('编码: $json');
```

### 7.10 WKChannel - 频道模型

`WKChannel` 表示一个频道，可以是个人频道或群组频道。

#### 7.10.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `channelID` | String | ✅ | - | 频道 ID | `"user_123"` 或 `"group_456"` |
| `channelType` | int | ✅ | - | 频道类型（1=个人，2=群组） | `1` |
| `channelName` | String | ❌ | `""` | 频道名称（用户昵称或群名） | `"张三"` 或 `"工作群"` |
| `channelRemark` | String | ❌ | `""` | 频道备注（好友备注） | `"老张"` |
| `avatar` | String | ❌ | `""` | 头像 URL | `"https://cdn.example.com/avatar/123.jpg"` |
| `top` | int | ❌ | `0` | 是否置顶（0=否，1=是） | `1` |
| `mute` | int | ❌ | `0` | 是否免打扰（0=否，1=是） | `0` |
| `status` | int | ❌ | `0` | 频道状态（1=正常，2=黑名单） | `1` |
| `follow` | int | ❌ | `0` | 是否好友（0=陌生人，1=好友） | `1` |
| `online` | int | ❌ | `0` | 是否在线（0=离线，1=在线） | `1` |
| `lastOffline` | int | ❌ | `0` | 最后离线时间（时间戳） | `1640995200000` |
| `category` | int | ❌ | `0` | 频道分类 | `0` |
| `receipt` | int | ❌ | `0` | 是否开启消息回执 | `0` |
| `robot` | int | ❌ | `0` | 是否机器人（0=否，1=是） | `0` |
| `username` | String | ❌ | `""` | 用户名 | `"zhangsan"` |

#### 7.10.2 使用示例

```dart
// 创建个人频道
WKChannel personalChannel = WKChannel('user_123', WKChannelType.personal);
personalChannel.channelName = '张三';
personalChannel.avatar = 'https://cdn.example.com/avatar/123.jpg';
personalChannel.online = 1;
personalChannel.follow = 1;

// 创建群组频道
WKChannel groupChannel = WKChannel('group_456', WKChannelType.group);
groupChannel.channelName = '工作群';
groupChannel.avatar = 'https://cdn.example.com/avatar/group_456.jpg';
groupChannel.mute = 0;
groupChannel.top = 0;

print('个人频道: ${personalChannel.channelName}, 在线: ${personalChannel.online == 1}');
print('群组频道: ${groupChannel.channelName}, 置顶: ${groupChannel.top == 1}');
```

### 7.11 WKConversationMsg - 会话模型

`WKConversationMsg` 表示一个会话，包含会话的基本信息。

#### 7.11.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `channelID` | String | ✅ | - | 频道 ID | `"user_123"` |
| `channelType` | int | ✅ | - | 频道类型（1=个人，2=群组） | `1` |
| `lastMsgSeq` | int | ❌ | `0` | 最后一条消息序号 | `100` |
| `lastMsgTimestamp` | int | ❌ | `0` | 最后一条消息时间戳 | `1640995200000` |
| `unreadCount` | int | ❌ | `0` | 未读消息数量 | `5` |
| `version` | int | ❌ | `0` | 会话版本号（用于增量同步） | `100` |
| `isDeleted` | int | ❌ | `0` | 是否被删除（0=否，1=是） | `0` |

#### 7.11.2 使用示例

```dart
// 创建会话
WKConversationMsg conversation = WKConversationMsg();
conversation.channelID = 'user_123';
conversation.channelType = WKChannelType.personal;
conversation.lastMsgSeq = 100;
conversation.lastMsgTimestamp = DateTime.now().millisecondsSinceEpoch;
conversation.unreadCount = 5;
conversation.version = 100;

print('会话: ${conversation.channelID}, 未读: ${conversation.unreadCount}');
```

### 7.12 WKUIConversationMsg - UI 会话模型

`WKUIConversationMsg` 是 `WKConversationMsg` 的扩展，用于 UI 展示，包含频道信息和最后一条消息。

#### 7.12.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `channelID` | String | ✅ | - | 频道 ID | `"user_123"` |
| `channelType` | int | ✅ | - | 频道类型（1=个人，2=群组） | `1` |
| `lastMsgTimestamp` | int | ❌ | `0` | 最后一条消息时间戳 | `1640995200000` |
| `unreadCount` | int | ❌ | `0` | 未读消息数量 | `5` |
| `wkChannel` | WKChannel? | ❌ | `null` | 频道信息（包含昵称、头像等） | - |
| `wkMsg` | WKMsg? | ❌ | `null` | 最后一条消息 | - |
| `reminderList` | List<WKReminder>? | ❌ | `null` | 提醒列表（@消息等） | - |

#### 7.12.2 使用示例

```dart
// 创建 UI 会话
WKUIConversationMsg uiConversation = WKUIConversationMsg();
uiConversation.channelID = 'user_123';
uiConversation.channelType = WKChannelType.personal;
uiConversation.unreadCount = 5;
uiConversation.lastMsgTimestamp = DateTime.now().millisecondsSinceEpoch;

// 设置频道信息
WKChannel channel = WKChannel('user_123', WKChannelType.personal);
channel.channelName = '张三';
channel.avatar = 'https://cdn.example.com/avatar/123.jpg';
uiConversation.wkChannel = channel;

// 设置最后一条消息
WKMsg lastMsg = WKMsg();
lastMsg.messageContent = WKTextContent('你好');
uiConversation.wkMsg = lastMsg;

print('UI 会话: ${uiConversation.wkChannel?.channelName}');
print('最后消息: ${uiConversation.wkMsg?.messageContent?.displayText()}');
```

### 7.13 Options - SDK 配置

`Options` 是 SDK 初始化的核心配置类。

#### 7.13.1 字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 | 示例 |
|-------|------|------|--------|------|------|
| `uid` | String | ✅ | - | 用户 ID | `"user_12345"` |
| `token` | String | ✅ | - | 用户身份令牌，用于服务端认证 | `"a1b2c3d4e5f6..."` |
| `addr` | String? | ❌ | `null` | IM 服务器地址（格式：`IP:PORT` 或 `ws://IP:PORT`） | `"ws://192.168.1.100:5100"` |
| `protoVersion` | int | ❌ | `0x04` | 协议版本号，通常使用默认值 | `4` |
| `deviceFlag` | int | ❌ | `0` | 设备标识符（0=iOS，1=Android，2=Web） | `1` |
| `debug` | bool | ❌ | `true` | 是否开启调试模式（输出详细日志） | `true` |
| `getAddr` | Function? | ❌ | `null` | 动态获取 IM 服务器地址的回调函数 | 参见 3.3 节 |
| `proto` | Proto | ❌ | `Proto()` | 协议编解码器实例，通常不需要修改 | - |

#### 7.13.2 使用示例

```dart
// 使用默认构造函数
Options options = Options();
options.uid = 'user_12345';
options.token = 'user_token_from_backend';
options.addr = 'ws://im.example.com:5100';
options.debug = true;
options.deviceFlag = 1;  // Android

// 使用工厂方法（推荐）
Options options = Options.newDefault('user_12345', 'user_token_from_backend');
options.addr = 'ws://im.example.com:5100';
options.debug = false;

// 使用动态 IP 获取
options.getAddr = (Function(String address) complete) async {
  String ip = await fetchIMServerAddressFromBackend();
  complete(ip);
};

// 初始化 SDK
WKIM.shared.setup(options);
```

### 7.14 枚举值

#### 7.14.1 WKChannelType - 频道类型

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKChannelType.personal` | 1 | 个人频道（一对一聊天） |
| `WKChannelType.group` | 2 | 群组频道（群聊） |

**使用示例**:

```dart
// 创建个人频道
WKChannel channel = WKChannel('user_123', WKChannelType.personal);

// 判断频道类型
if (channel.channelType == WKChannelType.personal) {
  print('这是一个个人频道');
} else if (channel.channelType == WKChannelType.group) {
  print('这是一个群组频道');
}
```

#### 7.14.2 WkMessageContentType - 消息内容类型

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WkMessageContentType.text` | 1 | 文本消息 |
| `WkMessageContentType.image` | 2 | 图片消息 |
| `WkMessageContentType.voice` | 4 | 语音消息 |
| `WkMessageContentType.video` | 5 | 视频消息 |
| `WkMessageContentType.insideMsg` | 99 | 内部消息（系统消息） |

**使用示例**:

```dart
// 判断消息类型
WKMsg msg = ...;

switch (msg.contentType) {
  case WkMessageContentType.text:
    print('文本消息');
    break;
  case WkMessageContentType.image:
    print('图片消息');
    break;
  case WkMessageContentType.voice:
    print('语音消息');
    break;
  case WkMessageContentType.video:
    print('视频消息');
    break;
  case WkMessageContentType.insideMsg:
    print('内部消息');
    break;
}
```

#### 7.14.3 WKConnectStatus - 连接状态

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKConnectStatus.fail` | 0 | 连接失败 |
| `WKConnectStatus.success` | 1 | 连接成功 |
| `WKConnectStatus.kicked` | 2 | 被踢下线（其他设备登录） |
| `WKConnectStatus.syncMsg` | 3 | 同步消息中 |
| `WKConnectStatus.connecting` | 4 | 正在连接 |
| `WKConnectStatus.noNetwork` | 5 | 无网络 |
| `WKConnectStatus.syncCompleted` | 6 | 同步完成 |

**使用示例**:

```dart
WKIM.shared.connectionManager.addOnConnectionStatus('key', (status, reason, connectInfo) {
  switch (status) {
    case WKConnectStatus.connecting:
      print('正在连接...');
      break;
    case WKConnectStatus.success:
      print('连接成功');
      break;
    case WKConnectStatus.fail:
      print('连接失败');
      break;
    case WKConnectStatus.noNetwork:
      print('无网络');
      break;
    case WKConnectStatus.kicked:
      print('被踢下线');
      break;
    case WKConnectStatus.syncMsg:
      print('同步消息中...');
      break;
    case WKConnectStatus.syncCompleted:
      print('同步完成');
      break;
  }
});
```

#### 7.14.4 WKSendMsgResult - 发送消息结果

| 常量名 | 值 | 说明 | UI 展示 |
|---------|-----|------|---------|
| `WKSendMsgResult.sendLoading` | 0 | 发送中 | 转圈动画 |
| `WKSendMsgResult.sendSuccess` | 1 | 发送成功 | 显示单勾或双勾 |
| `WKSendMsgResult.sendFail` | 2 | 发送失败 | 显示感叹号，可重发 |

**使用示例**:

```dart
// 判断消息发送状态
WKMsg msg = ...;

switch (msg.status) {
  case WKSendMsgResult.sendLoading:
    // 显示加载动画
    break;
  case WKSendMsgResult.sendSuccess:
    // 显示成功图标
    break;
  case WKSendMsgResult.sendFail:
    // 显示失败图标，可重发
    break;
}
```

#### 7.14.5 WKOrder - 排序方向

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKOrder.asc` | 0 | 升序（从小到大） |
| `WKOrder.desc` | 1 | 降序（从大到小） |

**使用示例**:

```dart
// 查询历史消息，升序排列（旧消息在前）
List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
  'user_123',
  WKChannelType.personal,
  limit: 20,
  order: WKOrder.asc,
);

// 查询历史消息，降序排列（新消息在前）
List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
  'user_123',
  WKChannelType.personal,
  limit: 20,
  order: WKOrder.desc,
);
```

### 7.15 数据模型关系图

```
WKMsg (消息)
├── messageID: String
├── messageSeq: int
├── clientMsgNO: String
├── timestamp: int
├── fromUID: String
├── channelID: String
├── channelType: int
├── contentType: int
├── content: String
├── status: int
├── header: MessageHeader
│       ├── redDot: bool
│       ├── noPersist: bool
│       └── syncOnce: bool
├── setting: Setting
│       ├── receipt: int
│       ├── topic: int
│       └── stream: int
├── from: WKChannel?
├── channelInfo: WKChannel?
├── messageContent: WKMessageContent?
│       ├── contentType: int
│       ├── encodeJson()
│       ├── decodeJson()
│       ├── displayText()
│       └── searchableWord()
│               ├── WKTextContent
│               │       └── content: String
│               ├── WKImageContent
│               │       ├── width: int
│               │       ├── height: int
│               │       ├── url: String
│               │       └── localPath: String
│               ├── WKVoiceContent
│               │       ├── timeTrad: int
│               │       ├── waveform: String?
│               │       ├── url: String
│               │       └── localPath: String
│               └── WKVideoContent
│                       ├── second: int
│                       ├── size: int
│                       ├── width: int
│                       ├── height: int
│                       ├── cover: String
│                       ├── coverLocalPath: String
│                       ├── url: String
│                       └── localPath: String
├── remoteExtra: WKMsgExtra?
├── flame: int
├── flameSec: int
└── searchableWord: String?

WKChannel (频道)
├── channelID: String
├── channelType: int
└── ChannelInfo
        ├── channelName: String
        ├── channelRemark: String
        ├── avatar: String
        ├── top: int
        ├── mute: int
        ├── status: int
        ├── follow: int
        ├── online: int
        ├── lastOffline: int
        ├── category: int
        ├── receipt: int
        ├── robot: int
        └── username: String

WKUIConversationMsg (UI 会话)
├── channelID: String
├── channelType: int
├── lastMsgTimestamp: int
├── unreadCount: int
├── wkChannel: WKChannel?
└── wkMsg: WKMsg?

Options (SDK 配置)
├── uid: String
├── token: String
├── addr: String?
├── protoVersion: int
├── deviceFlag: int
├── debug: bool
├── getAddr: Function?
└── proto: Proto
```

---

**下一章**: [8. 必须实现的8个监听器](#8-必须实现的8个监听器) - 详细讲解8个必须实现的监听器，每个监听器的用途、触发时机、参数、完整代码和使用场景。

## 8. 必须实现的8个监听器

⚠️ **重要**: 这 8 个监听器是 WuKongIM SDK 正常运行的必要条件，每个应用都必须实现！

本章将详细讲解每个监听器的用途、触发时机、参数说明、完整代码实现和使用场景。

### 8.1 监听器总览

| 编号 | 监听器名称 | 类别 | 是否需要后端 API | 用途 |
|-----|----------|------|---------------|------|
| 1 | Connection Status Listener | 连接 | ❌ | 监听连接状态变化 |
| 2 | New Message Listener | 消息 | ❌ | 监听收到的新消息 |
| 3 | Message Inserted Listener | 消息 | ❌ | 监听消息保存到数据库 |
| 4 | CMD Message Listener | 命令 | ✅ | 处理系统命令（撤回、更新、清除） |
| 5 | Sync Channel Messages Listener | 消息 | ✅ | 同步历史消息 |
| 6 | Get Channel Info Listener | 频道 | ✅ | 获取用户/群组信息 |
| 7 | Sync Conversations Listener | 会话 | ✅ | 同步会话列表 |
| 8 | Upload Attachment Listener | 消息 | ✅ | 上传图片/语音/视频附件 |

### 8.2 监听器 1: Connection Status Listener

#### 8.2.1 用途说明

监听 IM 连接状态的变化，实时了解连接情况。

#### 8.2.2 触发时机

- 连接建立成功
- 连接失败（认证失败、超时等）
- 网络不可用
- 被服务器踢下线
- 正在同步消息
- 消息同步完成

#### 8.2.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `status` | int | 连接状态（参见 7.14.3 节） |
| `reason` | int? | 失败原因代码 |
| `connectInfo` | ConnectionInfo? | 连接信息（节点 ID 等） |

#### 8.2.4 完整代码实现

```dart
/// 初始化连接状态监听器
void initConnectionStatusListener() {
  WKIM.shared.connectionManager.addOnConnectionStatus(
    'connection_key',  // 唯一标识，用于移除监听器
    (int status, int? reason, ConnectionInfo? connectInfo) {
      
      switch (status) {
        case WKConnectStatus.connecting:
          _handleConnecting();
          break;
          
        case WKConnectStatus.success:
          _handleConnectSuccess(connectInfo);
          break;
          
        case WKConnectStatus.fail:
          _handleConnectFail(reason);
          break;
          
        case WKConnectStatus.noNetwork:
          _handleNoNetwork();
          break;
          
        case WKConnectStatus.kicked:
          _handleKicked();
          break;
          
        case WKConnectStatus.syncMsg:
          _handleSyncMsg();
          break;
          
        case WKConnectStatus.syncCompleted:
          _handleSyncCompleted();
          break;
      }
    },
  );
}

/// 处理连接中
void _handleConnecting() {
  print('IM 连接中...');
  // 显示连接中提示
  showLoadingDialog('正在连接服务器...');
}

/// 处理连接成功
void _handleConnectSuccess(ConnectionInfo? connectInfo) {
  String nodeId = connectInfo?.nodeId.toString() ?? '未知';
  print('IM 连接成功，节点ID: $nodeId');
  
  // 隐藏加载提示
  hideLoadingDialog();
  
  // 显示成功提示
  showToast('连接成功');
}

/// 处理连接失败
void _handleConnectFail(int? reason) {
  print('IM 连接失败，原因: $reason');
  
  // 隐藏加载提示
  hideLoadingDialog();
  
  // 提示用户，SDK 会自动重连
  showToast('连接失败，正在重试...');
}

/// 处理无网络
void _handleNoNetwork() {
  print('网络不可用');
  
  // 显示网络错误提示
  showToast('网络不可用，请检查网络连接');
}

/// 处理被踢下线
void _handleKicked() {
  print('被踢下线（其他设备登录）');
  
  // 弹出提示，强制重新登录
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('账号已在其他设备登录'),
      content: const Text('您的账号在其他设备登录，如非本人操作，请及时修改密码。'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // 跳转到登录页
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text('重新登录'),
        ),
      ],
    ),
  );
}

/// 处理同步消息中
void _handleSyncMsg() {
  print('正在同步消息...');
}

/// 处理同步完成
void _handleSyncCompleted() {
  print('消息同步完成');
  
  // 刷新聊天列表
  refreshConversationList();
}

/// 移除监听器
void removeConnectionStatusListener() {
  WKIM.shared.connectionManager.removeOnConnectionStatus('connection_key');
}
```

#### 8.2.5 使用场景

| 场景 | 处理方式 |
|-----|---------|
| 显示连接状态 | 根据状态显示不同的 UI（连接中、已连接、无网络） |
| 被踢下线处理 | 弹出对话框，强制用户重新登录 |
| 重连提示 | 连接失败时提示用户正在重试 |
| 同步完成刷新 | 消息同步完成后刷新聊天列表 |

### 8.3 监听器 2: New Message Listener

#### 8.3.1 用途说明

监听收到的新消息，消息刚从服务器收到，但尚未保存到数据库。

#### 8.3.2 触发时机

- 服务器推送新消息到客户端
- 消息接收到后立即触发
- 消息尚未保存到数据库
- 消息尚未添加到会话列表

#### 8.3.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `msg` | WKMsg | 收到的消息对象 |

#### 8.3.4 完整代码实现

```dart
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class NewMessageHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInForeground = true;

  /// 初始化新消息监听器
  void init() {
    WKIM.shared.messageManager.addOnNewMsgListener(
      'new_msg_key',  // 唯一标识
      (WKMsg msg) {
        // 不处理自己的消息
        if (msg.fromUID == WKIM.shared.options.uid) {
          return;
        }

        print('收到新消息: ${msg.messageID}');
        print('发送者: ${msg.fromUID}');
        print('频道: ${msg.channelID}');
        print('消息类型: ${msg.contentType}');

        // 处理新消息
        handleNewMessage(msg);
      },
    );
  }

  /// 处理新消息
  void handleNewMessage(WKMsg msg) {
    // 播放提示音
    playNotificationSound();

    // 震动
    vibrate();

    // 如果应用在后台，显示系统通知
    if (!_isInForeground) {
      showSystemNotification(msg);
    }

    // 增加未读角标
    incrementBadgeCount();
  }

  /// 播放提示音
  Future<void> playNotificationSound() async {
    try {
      // 检查是否开启了声音
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool soundEnabled = prefs.getBool('notification_sound') ?? true;

      if (!soundEnabled) {
        return;
      }

      // 播放默认提示音
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      print('播放提示音成功');
    } catch (e) {
      print('播放提示音失败: $e');
    }
  }

  /// 震动
  Future<void> vibrate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool vibrateEnabled = prefs.getBool('notification_vibrate') ?? true;

      if (!vibrateEnabled) {
        return;
      }

      // 检查设备是否支持震动
      bool hasVibrator = await Vibration.hasVibrator() ?? false;

      if (hasVibrator) {
        Vibration.vibrate(duration: 200);
        print('震动成功');
      }
    } catch (e) {
      print('震动失败: $e');
    }
  }

  /// 显示系统通知
  void showSystemNotification(WKMsg msg) {
    // 使用 flutter_local_notifications 插件
    // 示例代码略
    print('显示系统通知: ${msg.messageContent?.displayText()}');
  }

  /// 增加未读角标
  Future<void> incrementBadgeCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('badge_count') ?? 0;
    prefs.setInt('badge_count', currentCount + 1);
    print('未读角标: ${currentCount + 1}');
  }

  /// 设置应用在前台/后台
  void setForeground(bool isInForeground) {
    _isInForeground = isInForeground;
    
    if (isInForeground) {
      // 应用回到前台，清除角标
      clearBadgeCount();
    }
  }

  /// 清除角标
  Future<void> clearBadgeCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('badge_count', 0);
    print('清除角标');
  }

  /// 销毁资源
  void dispose() {
    _audioPlayer.dispose();
    WKIM.shared.messageManager.removeOnNewMsgListener('new_msg_key');
  }
}
```

#### 8.3.5 使用场景

| 场景 | 处理方式 |
|-----|---------|
| 播放提示音 | 收到新消息时播放提示音 |
| 震动反馈 | 收到新消息时震动手机 |
| 显示通知栏通知 | 应用在后台时显示系统通知 |
| 更新应用角标 | 更新桌面应用的未读角标 |

### 8.4 监听器 3: Message Inserted Listener

#### 8.4.1 用途说明

监听消息保存到数据库的事件。此时消息已经完整保存，可以安全地用于刷新 UI。

#### 8.4.2 触发时机

- 消息已保存到本地数据库
- 消息已添加到会话列表（如果适用）
- 消息数据完整，可以用于 UI 渲染

#### 8.4.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `msg` | WKMsg | 已保存到数据库的消息对象 |

#### 8.4.4 完整代码实现

```dart
class MessageInsertedHandler {
  final Map<String, List<WKMsg>> _channelMessages = {};

  /// 初始化消息入库监听器
  void init() {
    WKIM.shared.messageManager.addOnMsgInsertedListener(
      (WKMsg msg) {
        print('消息已入库: ${msg.messageID}');
        print('发送者: ${msg.fromUID}');
        print('频道: ${msg.channelID}');
        print('消息内容: ${msg.messageContent?.displayText()}');

        // 处理消息入库
        handleMessageInserted(msg);
      },
    );
  }

  /// 处理消息入库
  void handleMessageInserted(WKMsg msg) {
    String channelKey = '${msg.channelID}_${msg.channelType}';

    // 按频道存储消息
    if (!_channelMessages.containsKey(channelKey)) {
      _channelMessages[channelKey] = [];
    }
    _channelMessages[channelKey]!.add(msg);

    // 通知 UI 刷新
    notifyUI(msg);
  }

  /// 通知 UI 刷新
  void notifyUI(WKMsg msg) {
    // 检查是否是当前打开的聊天页面
    String currentChannel = getCurrentOpenChannel();
    
    if (currentChannel == '${msg.channelID}_${msg.channelType}') {
      // 刷新当前聊天页面的消息列表
      refreshChatMessages();
    } else {
      // 刷新会话列表
      refreshConversationList();
    }
  }

  /// 获取当前打开的频道
  String getCurrentOpenChannel() {
    // 从你的状态管理中获取当前打开的频道
    // 示例：
    return GlobalState.currentChannelKey ?? '';
  }

  /// 刷新聊天消息
  void refreshChatMessages() {
    // 通知当前聊天页面刷新
    // 示例：使用事件总线或状态管理
    EventBus.emit('refresh_chat_messages');
  }

  /// 刷新会话列表
  void refreshConversationList() {
    // 通知会话列表刷新
    EventBus.emit('refresh_conversation_list');
  }

  /// 获取某频道的消息
  List<WKMsg> getChannelMessages(String channelID, int channelType) {
    String channelKey = '${channelID}_$channelType';
    return _channelMessages[channelKey] ?? [];
  }

  /// 销毁监听器
  void dispose() {
    _channelMessages.clear();
  }
}
```

> ⚠️ **注意**: `addOnMsgInsertedListener` 不需要 key 参数，因为只有一个全局监听器。

#### 8.4.5 使用场景

| 场景 | 处理方式 |
|-----|---------|
| 刷新聊天列表 | 消息入库后，在聊天列表中显示新消息 |
| 更新会话列表 | 消息入库后，更新会话列表的最后一条消息 |
| 更新未读数 | 消息入库后，更新会话的未读数 |
| 滚动到底部 | 在当前聊天页面，收到消息后滚动到底部 |

### 8.5 监听器 4: CMD Message Listener

#### 8.5.1 用途说明

处理系统命令消息（CMD），包括消息撤回、频道信息更新、未读数清除等。

#### 8.5.2 触发时机

- 服务器发送 CMD 消息通知客户端执行特定操作

#### 8.5.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `cmd` | WKCmd | CMD 消息对象，包含 cmd 类型和参数 |

**WKCmd 字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `cmd` | String | CMD 类型（messageRevoke/channelUpdate/unreadClear） |
| `param` | Map | CMD 参数 |

#### 8.5.4 3 种 CMD 消息详解

##### CMD 1: messageRevoke - 消息撤回

**触发时机**: 消息被撤回时

**参数说明**:

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `channel_id` | String | 频道 ID |
| `channel_type` | int | 频道类型（1=个人，2=群组） |

**处理逻辑**:

```
1. 获取当前频道的最大扩展版本号
2. 调用后端 API 同步消息扩展
3. SDK 自动更新消息状态（显示"消息已撤回"）
```

##### CMD 2: channelUpdate - 频道更新

**触发时机**: 用户/群组信息变更时

**参数说明**:

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `channel_id` | String | 频道 ID |
| `channel_type` | int | 频道类型（1=个人，2=群组） |

**处理逻辑**:

```
如果 channelType == 1 (个人)：
  调用后端 API 获取用户信息
  更新本地频道信息（昵称、头像等）
  
如果 channelType == 2 (群组)：
  调用后端 API 获取群组信息
  更新本地频道信息（群名、头像等）
```

##### CMD 3: unreadClear - 未读数清除

**触发时机**: 未读数被清除时（用户在另一个设备阅读了消息）

**参数说明**:

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `channel_id` | String | 频道 ID |
| `channel_type` | int | 频道类型（1=个人，2=群组） |
| `unread` | int | 新的未读数 |

**处理逻辑**:

```
调用 SDK 方法更新本地未读数
```

#### 8.5.5 完整代码实现（来自官方示例 im.dart）

```dart
/// 初始化 CMD 消息监听器
void initCMDListener() {
  WKIM.shared.cmdManager.addOnCmdListener(
    'sys_im',  // 唯一标识
    (WKCmd cmd) async {
      print('收到 CMD 消息: ${cmd.cmd}');
      print('参数: ${cmd.param}');

      // 根据 cmd 类型处理
      if (cmd.cmd == 'messageRevoke') {
        await handleMessageRevoke(cmd);
      } else if (cmd.cmd == 'channelUpdate') {
        await handleChannelUpdate(cmd);
      } else if (cmd.cmd == 'unreadClear') {
        handleUnreadClear(cmd);
      }
    },
  );
}

/// 处理消息撤回
Future<void> handleMessageRevoke(WKCmd cmd) async {
  String channelID = cmd.param['channel_id'] ?? '';
  int channelType = cmd.param['channel_type'] ?? 0;
  
  print('收到消息撤回通知: $channelID, $channelType');
  
  if (channelID.isEmpty) {
    return;
  }
  
  // 获取当前频道的最大扩展版本号
  int maxVersion = await WKIM.shared.messageManager.getMaxExtraVersionWithChannel(
    channelID,
    channelType,
  );
  
  print('当前最大扩展版本号: $maxVersion');
  
  // 调用后端 API 同步消息扩展
  await syncMessageExtra(channelID, channelType, maxVersion);
}

/// 处理频道更新
Future<void> handleChannelUpdate(WKCmd cmd) async {
  String channelID = cmd.param['channel_id'] ?? '';
  int channelType = cmd.param['channel_type'] ?? 0;
  
  print('收到频道更新通知: $channelID, $channelType');
  
  if (channelID.isEmpty) {
    return;
  }
  
  if (channelType == WKChannelType.personal) {
    // 个人频道：获取用户信息
    print('获取个人资料: $channelID');
    await getUserInfo(channelID);
  } else if (channelType == WKChannelType.group) {
    // 群组频道：获取群组信息
    print('获取群组资料: $channelID');
    await getGroupInfo(channelID);
  }
}

/// 处理未读数清除
void handleUnreadClear(WKCmd cmd) {
  String channelID = cmd.param['channel_id'] ?? '';
  int channelType = cmd.param['channel_type'] ?? 0;
  int unread = cmd.param['unread'] ?? 0;
  
  print('收到未读数清除通知: $channelID, $channelType, $unread');
  
  if (channelID.isEmpty) {
    return;
  }
  
  // 更新本地未读数
  WKIM.shared.conversationManager.updateRedDot(
    channelID,
    channelType,
    unread,
  );
  
  print('未读数已更新: $unread');
}

/// 移除 CMD 监听器
void removeCMDListener() {
  WKIM.shared.cmdManager.removeOnCmdListener('sys_im');
}
```

#### 8.5.6 后端 API 调用示例

```dart
import 'package:http/http.dart' as http;

/// 同步消息扩展（需要调用后端 API）
Future<void> syncMessageExtra(String channelID, int channelType, int version) async {
  try {
    // 调用你的后端 API
    // POST /api/message/extra/sync
    var response = await http.post(
      Uri.parse('https://api.example.com/message/extra/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_id': channelID,
        'channel_type': channelType,
        'version': version,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('同步消息扩展成功');
      
      // SDK 会自动更新消息状态
      // 被撤回的消息会显示为"消息已撤回"
    } else {
      print('同步消息扩展失败: ${response.statusCode}');
    }
  } catch (e) {
    print('同步消息扩展异常: $e');
  }
}

/// 获取用户信息
Future<void> getUserInfo(String uid) async {
  try {
    print('获取用户信息: $uid');
    
    // 调用你的后端 API
    // GET /api/user/{uid}
    var response = await http.get(
      Uri.parse('https://api.example.com/user/$uid'),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      
      // 更新或创建频道信息
      WKChannel channel = WKChannel(uid, WKChannelType.personal);
      channel.channelName = data['nickname'] ?? '';
      channel.avatar = data['avatar'] ?? '';
      
      // 保存到本地
      await WKIM.shared.channelManager.saveOrUpdateChannel(channel);
      
      print('用户信息更新成功: ${channel.channelName}');
      
      // 刷新 UI
      EventBus.emit('refresh_conversation_list');
    } else {
      print('获取用户信息失败: ${response.statusCode}');
    }
  } catch (e) {
    print('获取用户信息异常: $e');
  }
}

/// 获取群组信息
Future<void> getGroupInfo(String groupId) async {
  try {
    print('获取群组信息: $groupId');
    
    // 调用你的后端 API
    // GET /api/group/{groupId}
    var response = await http.get(
      Uri.parse('https://api.example.com/group/$groupId'),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      
      // 更新或创建频道信息
      WKChannel channel = WKChannel(groupId, WKChannelType.group);
      channel.channelName = data['group_name'] ?? '';
      channel.avatar = data['avatar'] ?? '';
      
      // 保存到本地
      await WKIM.shared.channelManager.saveOrUpdateChannel(channel);
      
      print('群组信息更新成功: ${channel.channelName}');
      
      // 刷新 UI
      EventBus.emit('refresh_conversation_list');
    } else {
      print('获取群组信息失败: ${response.statusCode}');
    }
  } catch (e) {
    print('获取群组信息异常: $e');
  }
}
```

#### 8.5.7 使用场景

| CMD 类型 | 使用场景 |
|---------|---------|
| messageRevoke | 消息撤回后，更新 UI 显示"消息已撤回" |
| channelUpdate | 用户/群组信息变更后，更新昵称、头像等信息 |
| unreadClear | 其他设备阅读消息后，更新当前设备的未读数 |

### 8.6 监听器 5: Sync Channel Messages Listener

#### 8.6.1 用途说明

监听历史消息同步请求。当 SDK 需要从后端获取历史消息时，会触发此监听器。

#### 8.6.2 触发时机

- 用户首次进入聊天页面
- 用户向上滚动消息列表，需要加载更多历史消息
- 连接成功后同步离线消息

#### 8.6.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `channelID` | String | 频道 ID |
| `channelType` | int | 频道类型（1=个人，2=群组） |
| `startMessageSeq` | int | 起始消息序号（不包含） |
| `endMessageSeq` | int | 结束消息序号（包含） |
| `limit` | int | 最大返回条数 |
| `pullMode` | int | 拉取模式 |
| `back` | Function | 回调函数，**必须调用**，参数为 `List<WKMsg>` |

#### 8.6.4 完整代码实现（来自官方示例 im.dart）

```dart
/// 初始化历史消息同步监听器
void initSyncChannelMsgListener() {
  WKIM.shared.messageManager.addOnSyncChannelMsgListener(
    (String channelID,
     int channelType,
     int startMessageSeq,
     int endMessageSeq,
     int limit,
     int pullMode,
     Function(List<WKMsg> msgs) back) {
      
      print('请求同步历史消息:');
      print('  频道ID: $channelID');
      print('  频道类型: $channelType');
      print('  起始序号: $startMessageSeq');
      print('  结束序号: $endMessageSeq');
      print('  限制条数: $limit');
      print('  拉取模式: $pullMode');
      
      // 调用后端 API 获取历史消息
      syncChannelMsg(
        channelID,
        channelType,
        startMessageSeq,
        endMessageSeq,
        limit,
        pullMode,
        back,
      );
    },
  );
}
```

#### 8.6.5 后端 API 调用示例

```dart
/// 同步历史消息（需要调用后端 API）
Future<void> syncChannelMsg(
  String channelID,
  int channelType,
  int startMessageSeq,
  int endMessageSeq,
  int limit,
  int pullMode,
  Function(List<WKMsg> msgs) back,
) async {
  try {
    // 调用你的后端 API
    // POST /api/message/sync
    var response = await http.post(
      Uri.parse('https://api.example.com/message/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_id': channelID,
        'channel_type': channelType,
        'start_message_seq': startMessageSeq,
        'end_message_seq': endMessageSeq,
        'limit': limit,
        'pull_mode': pullMode,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> messages = data['messages'] ?? [];
      
      // 解析消息列表
      List<WKMsg> wkMsgs = messages.map((msgJson) {
        return parseMessage(msgJson);
      }).toList();
      
      print('获取到 ${wkMsgs.length} 条历史消息');
      
      // ⚠️ 重要：必须调用 back() 返回消息列表
      back(wkMsgs);
    } else {
      print('同步历史消息失败: ${response.statusCode}');
      back([]);
    }
  } catch (e) {
    print('同步历史消息异常: $e');
    back([]);
  }
}

/// 解析后端返回的消息
WKMsg parseMessage(Map<String, dynamic> msgJson) {
  WKMsg msg = WKMsg();
  msg.messageID = msgJson['message_id'] ?? '';
  msg.messageSeq = msgJson['message_seq'] ?? 0;
  msg.clientMsgNO = msgJson['client_msg_no'] ?? '';
  msg.fromUID = msgJson['from_uid'] ?? '';
  msg.channelID = msgJson['channel_id'] ?? '';
  msg.channelType = msgJson['channel_type'] ?? 0;
  msg.contentType = msgJson['content_type'] ?? 0;
  msg.content = msgJson['content'] ?? '';
  msg.timestamp = msgJson['timestamp'] ?? 0;
  
  // 解析消息内容
  var contentJson = jsonDecode(msg.content);
  msg.messageContent = WKIM.shared.messageManager.getMessageModel(
    msg.contentType,
    contentJson,
  );
  
  return msg;
}
```

#### 8.6.6 使用场景

| 场景 | 处理方式 |
|-----|---------|
| 进入聊天页面 | 加载最近的 20 条历史消息 |
| 向上滚动 | 加载更多历史消息 |
| 离线重连 | 同步离线期间的消息 |

> ⚠️ **重要**: 必须调用 `back(List<WKMsg>)` 返回消息列表，否则 SDK 无法处理！

### 8.7 监听器 6: Get Channel Info Listener

#### 8.7.1 用途说明

监听获取频道信息的请求。当 SDK 需要显示用户或群组信息时，会触发此监听器。

#### 8.7.2 触发时机

- 显示消息列表时需要发送者信息
- 显示会话列表时需要频道信息
- SDK 发现本地没有频道信息时

#### 8.7.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `channelId` | String | 频道 ID |
| `channelType` | int | 频道类型（1=个人，2=群组） |
| `back` | Function | 回调函数（不需要调用） |

#### 8.7.4 完整代码实现（来自官方示例 im.dart）

```dart
/// 初始化获取频道信息监听器
void initGetChannelListener() {
  WKIM.shared.channelManager.addOnGetChannelListener(
    (String channelId, int channelType, Function back) {
      
      print('请求获取频道信息:');
      print('  频道ID: $channelId');
      print('  频道类型: $channelType');
      
      if (channelType == WKChannelType.personal) {
        // 获取个人资料
        print('获取个人资料: $channelId');
        getUserInfo(channelId);
      } else if (channelType == WKChannelType.group) {
        // 获取群组资料
        print('获取群组资料: $channelId');
        getGroupInfo(channelId);
      }
    },
  );
}
```

#### 8.7.5 后端 API 调用示例

参见 8.5.6 节的 `getUserInfo()` 和 `getGroupInfo()` 方法。

#### 8.7.6 使用场景

| 场景 | 处理方式 |
|-----|---------|
| 显示发送者信息 | 从后端获取用户昵称、头像 |
| 显示群组信息 | 从后端获取群名、群头像 |

### 8.8 监听器 7: Sync Conversations Listener

#### 8.8.1 用途说明

监听会话列表同步请求。当 SDK 需要从后端同步会话列表时，会触发此监听器。

#### 8.8.2 触发时机

- 首次连接成功后
- 会话列表需要刷新

#### 8.8.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `lastSsgSeqs` | List<int> | 会话列表序号（用于增量同步） |
| `msgCount` | int | 消息数量 |
| `version` | int | 会话版本号 |
| `complete` | Function | 回调函数，**必须调用**，参数为 `List<WKUIConversationMsg>` |

#### 8.8.4 完整代码实现（来自官方示例 im.dart）

```dart
/// 初始化会话同步监听器
void initSyncConversationListener() {
  WKIM.shared.conversationManager.addOnSyncConversationListener(
    (List<int> lastSsgSeqs, int msgCount, int version, Function(List<WKUIConversationMsg>) complete) {
      
      print('请求同步会话列表:');
      print('  会话列表序号: $lastSsgSeqs');
      print('  消息数量: $msgCount');
      print('  版本号: $version');
      
      // 调用后端 API 同步会话列表
      syncConversation(lastSsgSeqs, msgCount, version, complete);
    },
  );
}
```

#### 8.8.5 后端 API 调用示例

```dart
/// 同步会话列表（需要调用后端 API）
Future<void> syncConversation(
  List<int> lastSsgSeqs,
  int msgCount,
  int version,
  Function(List<WKUIConversationMsg>) complete,
) async {
  try {
    // 调用你的后端 API
    // POST /api/conversation/sync
    var response = await http.post(
      Uri.parse('https://api.example.com/conversation/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'last_ssg_seqs': lastSsgSeqs,
        'msg_count': msgCount,
        'version': version,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> convList = data['conversations'] ?? [];
      
      // 解析会话列表
      List<WKUIConversationMsg> conversations = convList.map((convJson) {
        return parseConversation(convJson);
      }).toList();
      
      print('同步了 ${conversations.length} 个会话');
      
      // ⚠️ 重要：必须调用 complete() 返回会话列表
      complete(conversations);
    } else {
      print('同步会话失败: ${response.statusCode}');
      complete([]);
    }
  } catch (e) {
    print('同步会话异常: $e');
    complete([]);
  }
}

/// 解析后端返回的会话
WKUIConversationMsg parseConversation(Map<String, dynamic> convJson) {
  WKUIConversationMsg conversation = WKUIConversationMsg();
  conversation.channelID = convJson['channel_id'] ?? '';
  conversation.channelType = convJson['channel_type'] ?? 0;
  conversation.unreadCount = convJson['unread_count'] ?? 0;
  conversation.lastMsgTimestamp = convJson['last_msg_timestamp'] ?? 0;
  
  // 解析频道信息
  var channelJson = convJson['channel'];
  if (channelJson != null) {
    WKChannel channel = WKChannel(conversation.channelID, conversation.channelType);
    channel.channelName = channelJson['channel_name'] ?? '';
    channel.avatar = channelJson['avatar'] ?? '';
    conversation.wkChannel = channel;
  }
  
  // 解析最后一条消息
  var msgJson = convJson['last_msg'];
  if (msgJson != null) {
    conversation.wkMsg = parseMessage(msgJson);
  }
  
  return conversation;
}
```

#### 8.8.6 使用场景

| 场景 | 处理方式 |
|-----|---------|
| 首次连接 | 同步所有会话列表 |
| 会话刷新 | 增量同步新增/更新的会话 |

> ⚠️ **重要**: 必须调用 `complete(List<WKUIConversationMsg>)` 返回会话列表！

### 8.9 监听器 8: Upload Attachment Listener

#### 8.9.1 用途说明

监听附件上传请求。当发送图片、语音、视频消息时，SDK 会触发此监听器，要求上传附件到服务器。

#### 8.9.2 触发时机

- 发送图片消息时
- 发送语音消息时
- 发送视频消息时

#### 8.9.3 参数说明

| 参数名 | 类型 | 说明 |
|-------|------|------|
| `wkMsg` | WKMsg | 待发送的消息对象 |
| `back` | Function | 回调函数，**必须调用**，参数为 `(bool isSuccess, WKMsg uploadedMsg)` |

#### 8.9.4 完整代码实现（来自官方示例 im.dart）

```dart
/// 初始化附件上传监听器
void initUploadAttachmentListener() {
  WKIM.shared.messageManager.addOnUploadAttachmentListener(
    (WKMsg wkMsg, Function(bool isSuccess, WKMsg uploadedMsg) back) {
      
      print('请求上传附件:');
      print('  消息类型: ${wkMsg.contentType}');
      print('  本地路径: ${wkMsg.messageContent is WKMediaMessageContent ? (wkMsg.messageContent as WKMediaMessageContent).localPath : ''}');
      
      if (wkMsg.contentType == WkMessageContentType.image) {
        // 上传图片
        uploadImage(wkMsg, back);
      } else if (wkMsg.contentType == WkMessageContentType.voice) {
        // 上传语音
        uploadVoice(wkMsg, back);
      } else if (wkMsg.contentType == WkMessageContentType.video) {
        // 上传视频
        uploadVideo(wkMsg, back);
      }
    },
  );
}

/// 上传图片
Future<void> uploadImage(WKMsg wkMsg, Function(bool, WKMsg) back) async {
  WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
  String localPath = imageContent.localPath;
  
  print('上传图片: $localPath');
  
  try {
    // 调用你的后端 API 上传图片
    String? uploadedUrl = await uploadFileToServer(localPath, 'image');
    
    if (uploadedUrl == null) {
      // 上传失败
      print('图片上传失败');
      back(false, wkMsg);
      return;
    }
    
    // 上传成功，更新 URL
    imageContent.url = uploadedUrl;
    wkMsg.messageContent = imageContent;
    
    print('图片上传成功: $uploadedUrl');
    
    // ⚠️ 重要：必须调用 back(true, wkMsg) 返回
    back(true, wkMsg);
    
  } catch (e) {
    print('图片上传异常: $e');
    back(false, wkMsg);
  }
}

/// 上传语音
Future<void> uploadVoice(WKMsg wkMsg, Function(bool, WKMsg) back) async {
  WKVoiceContent voiceContent = wkMsg.messageContent! as WKVoiceContent;
  String localPath = voiceContent.localPath;
  
  print('上传语音: $localPath');
  
  try {
    // 调用你的后端 API 上传语音
    String? uploadedUrl = await uploadFileToServer(localPath, 'voice');
    
    if (uploadedUrl == null) {
      // 上传失败
      print('语音上传失败');
      back(false, wkMsg);
      return;
    }
    
    // 上传成功，更新 URL
    voiceContent.url = uploadedUrl;
    wkMsg.messageContent = voiceContent;
    
    print('语音上传成功: $uploadedUrl');
    
    // ⚠️ 重要：必须调用 back(true, wkMsg) 返回
    back(true, wkMsg);
    
  } catch (e) {
    print('语音上传异常: $e');
    back(false, wkMsg);
  }
}

/// 上传视频
Future<void> uploadVideo(WKMsg wkMsg, Function(bool, WKMsg) back) async {
  WKVideoContent videoContent = wkMsg.messageContent! as WKVideoContent;
  String localPath = videoContent.localPath;
  String coverLocalPath = videoContent.coverLocalPath;
  
  print('上传视频: $localPath');
  print('上传封面: $coverLocalPath');
  
  try {
    // 上传封面
    String? coverUrl = await uploadFileToServer(coverLocalPath, 'image');
    
    if (coverUrl == null) {
      print('封面上传失败');
      back(false, wkMsg);
      return;
    }
    
    // 上传视频
    String? videoUrl = await uploadFileToServer(localPath, 'video');
    
    if (videoUrl == null) {
      print('视频上传失败');
      back(false, wkMsg);
      return;
    }
    
    // 上传成功，更新 URL
    videoContent.cover = coverUrl;
    videoContent.url = videoUrl;
    wkMsg.messageContent = videoContent;
    
    print('视频上传成功: $videoUrl');
    print('封面上传成功: $coverUrl');
    
    // ⚠️ 重要：必须调用 back(true, wkMsg) 返回
    back(true, wkMsg);
    
  } catch (e) {
    print('视频上传异常: $e');
    back(false, wkMsg);
  }
}

/// 上传文件到服务器
Future<String?> uploadFileToServer(String localPath, String fileType) async {
  try {
    File file = File(localPath);
    
    // 创建 FormData
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.example.com/file/upload'),
    );
    
    // 添加文件
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
    ));
    
    // 添加文件类型
    request.fields['type'] = fileType;
    
    // 发送请求
    var response = await request.send();
    
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      return data['url'];  // 返回服务器 URL
    } else {
      print('上传失败: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('上传异常: $e');
    return null;
  }
}
```

#### 8.9.5 使用场景

| 消息类型 | 处理方式 |
|---------|---------|
| 图片消息 | 上传图片文件，更新 url 字段 |
| 语音消息 | 上传语音文件，更新 url 字段 |
| 视频消息 | 上传视频文件和封面图片，更新 url 和 cover 字段 |

> ⚠️ **重要**: 必须调用 `back(bool isSuccess, WKMsg uploadedMsg)` 返回！
> - `isSuccess = true`: 上传成功，SDK 会继续发送消息
> - `isSuccess = false`: 上传失败，SDK 会标记消息为发送失败

### 8.10 完整监听器初始化示例

将所有 8 个监听器整合到一个初始化方法中：

```dart
class IMListenerManager {
  /// 初始化所有监听器
  static void initAllListeners() {
    // 1. 连接状态监听器
    WKIM.shared.connectionManager.addOnConnectionStatus(
      'connection_key',
      (status, reason, connectInfo) {
        // TODO: 处理连接状态变化
        print('连接状态: $status');
      },
    );
    
    // 2. 新消息监听器
    WKIM.shared.messageManager.addOnNewMsgListener(
      'new_msg_key',
      (WKMsg msg) {
        // TODO: 处理新消息（播放提示音、震动、通知等）
        print('收到新消息: ${msg.messageID}');
      },
    );
    
    // 3. 消息入库监听器
    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      // TODO: 刷新 UI（聊天列表、会话列表）
      print('消息已入库: ${msg.messageID}');
    });
    
    // 4. CMD 消息监听器
    WKIM.shared.cmdManager.addOnCmdListener('cmd_key', (WKCmd cmd) async {
      if (cmd.cmd == 'messageRevoke') {
        // TODO: 处理消息撤回
        var channelID = cmd.param['channel_id'];
        var channelType = cmd.param['channel_type'];
        if (channelID != '') {
          var maxVersion = await WKIM.shared.messageManager.getMaxExtraVersionWithChannel(channelID, channelType);
          BackendAPI.syncMessageExtra(channelID, channelType, maxVersion);
        }
      } else if (cmd.cmd == 'channelUpdate') {
        // TODO: 处理频道更新
        var channelID = cmd.param['channel_id'];
        var channelType = cmd.param['channel_type'];
        if (channelType == WKChannelType.personal) {
          BackendAPI.getUserInfo(channelID);
        } else if (channelType == WKChannelType.group) {
          BackendAPI.getGroupInfo(channelID);
        }
      } else if (cmd.cmd == 'unreadClear') {
        // TODO: 处理未读数清除
        var channelID = cmd.param['channel_id'];
        var channelType = cmd.param['channel_type'];
        var unread = cmd.param['unread'];
        if (channelID != '') {
          WKIM.shared.conversationManager.updateRedDot(channelID, channelType, unread);
        }
      }
    });
    
    // 5. 历史消息同步监听器
    WKIM.shared.messageManager.addOnSyncChannelMsgListener((
      channelID,
      channelType,
      startMessageSeq,
      endMessageSeq,
      limit,
      pullMode,
      back,
    ) {
      BackendAPI.syncChannelMsg(
        channelID,
        channelType,
        startMessageSeq,
        endMessageSeq,
        limit,
        pullMode,
        back,
      );
    });
    
    // 6. 获取频道信息监听器
    WKIM.shared.channelManager.addOnGetChannelListener((channelId, channelType, back) {
      if (channelType == WKChannelType.personal) {
        BackendAPI.getUserInfo(channelId);
      } else if (channelType == WKChannelType.group) {
        BackendAPI.getGroupInfo(channelId);
      }
    });
    
    // 7. 会话同步监听器
    WKIM.shared.conversationManager.addOnSyncConversationListener((
      lastSsgSeqs,
      msgCount,
      version,
      back,
    ) {
      BackendAPI.syncConversation(lastSsgSeqs, msgCount, version, back);
    });
    
    // 8. 附件上传监听器
    WKIM.shared.messageManager.addOnUploadAttachmentListener((wkMsg, back) {
      if (wkMsg.contentType == WkMessageContentType.image) {
        WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
        BackendAPI.uploadImage(imageContent.localPath, (url) {
          imageContent.url = url;
          wkMsg.messageContent = imageContent;
          back(url != null, wkMsg);
        });
      } else if (wkMsg.contentType == WkMessageContentType.voice) {
        WKVoiceContent voiceContent = wkMsg.messageContent! as WKVoiceContent;
        BackendAPI.uploadFile(voiceContent.localPath, 'voice', (url) {
          voiceContent.url = url;
          wkMsg.messageContent = voiceContent;
          back(url != null, wkMsg);
        });
      } else if (wkMsg.contentType == WkMessageContentType.video) {
        WKVideoContent videoContent = wkMsg.messageContent! as WKVideoContent;
        BackendAPI.uploadVideo(
          videoContent.localPath,
          videoContent.coverLocalPath,
          (videoUrl, coverUrl) {
            videoContent.url = videoUrl;
            videoContent.cover = coverUrl;
            wkMsg.messageContent = videoContent;
            back(videoUrl != null && coverUrl != null, wkMsg);
          },
        );
      }
    });
    
    print('所有监听器初始化完成');
  }

  /// 移除所有监听器
  static void removeAllListeners() {
    WKIM.shared.connectionManager.removeOnConnectionStatus('connection_key');
    WKIM.shared.messageManager.removeOnNewMsgListener('new_msg_key');
    // 注意：addOnMsgInsertedListener 没有 remove 方法
    WKIM.shared.cmdManager.removeOnCmdListener('cmd_key');
    // 注意：其他监听器可能也没有 remove 方法
    
    print('所有监听器已移除');
  }
}
```

### 8.11 监听器注册时机建议

| 监听器 | 注册时机 | 移除时机 |
|-------|---------|---------|
| Connection Status | SDK 初始化后 | 应用退出 |
| New Message | SDK 初始化后 | 应用退出 |
| Message Inserted | SDK 初始化后 | 应用退出 |
| CMD Message | SDK 初始化后 | 应用退出 |
| Sync Channel Messages | SDK 初始化后 | 应用退出 |
| Get Channel Info | SDK 初始化后 | 应用退出 |
| Sync Conversations | SDK 初始化后 | 应用退出 |
| Upload Attachment | SDK 初始化后 | 应用退出 |

**最佳实践**: 在 SDK 初始化后立即注册所有监听器，在应用退出时移除监听器。

---

**下一章**: [9. 后端API集成](#9-后端api集成) - 详细讲解5个必需的后端 API 的请求/响应格式和调用方法。

## 9. 后端 API 集成

WuKongIM SDK 需要配合后端 API 才能正常运行。本章将详细介绍 5 个必需的后端 API 的请求/响应格式和调用方法。

### 9.1 必需的后端 API 列表

| 编号 | API | 方法 | 用途 | 优先级 |
|-----|-----|------|------|-------|
| 1 | `/api/im/server` | GET | 获取 IM 服务器地址 | 中 |
| 2 | `/api/message/sync` | POST | 同步历史消息 | 高 |
| 3 | `/api/conversation/sync` | POST | 同步会话列表 | 高 |
| 4 | `/api/user/{uid}` | GET | 获取用户信息 | 高 |
| 5 | `/api/group/{groupId}` | GET | 获取群组信息 | 高 |
| 6 | `/api/file/upload` | POST | 上传文件附件 | 高 |

> ⚠️ **重要**: 所有 API 必须在用户认证后访问，需要在请求头中包含用户的认证信息（如 JWT token）。

### 9.2 API 1: 获取 IM 服务器地址

获取 IM 服务器的连接地址。

#### 9.2.1 请求

```http
GET /api/im/server HTTP/1.1
Host: api.example.com
Authorization: Bearer <user_token>
Content-Type: application/json
```

#### 9.2.2 响应

**成功响应** (200 OK):

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "address": "ws://im.example.com:5100"
  }
}
```

**响应字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `address` | String | IM 服务器地址，格式：`ws://IP:PORT` 或 `ws://域名:端口` |

#### 9.2.3 客户端调用示例

```dart
import 'package:http/http.dart' as http;

class HttpUtils {
  /// 获取 IM 服务器地址
  static Future<String> getIP(String uid) async {
    try {
      var response = await http.get(
        Uri.parse('https://api.example.com/im/server'),
        headers: {
          'Authorization': 'Bearer $uid',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String address = data['data']['address'] ?? '';
        print('获取到 IM 服务器地址: $address');
        return address;
      } else {
        print('获取 IM 服务器地址失败: ${response.statusCode}');
        return 'ws://im.example.com:5100';  // 返回默认地址
      }
    } catch (e) {
      print('获取 IM 服务器地址异常: $e');
      return 'ws://im.example.com:5100';  // 返回默认地址
    }
  }
}

// 在 SDK 配置中使用
WKIM.shared.options.getAddr = (Function(String address) complete) async {
  String ip = await HttpUtils.getIP(UserInfo.uid);
  complete(ip);
};
```

### 9.3 API 2: 同步历史消息

同步指定频道的历史消息。

#### 9.3.1 请求

```http
POST /api/message/sync HTTP/1.1
Host: api.example.com
Authorization: Bearer <user_token>
Content-Type: application/json

{
  "channel_id": "user_123",
  "channel_type": 1,
  "start_message_seq": 100,
  "end_message_seq": 150,
  "limit": 20,
  "pull_mode": 0
}
```

**请求参数说明**:

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| `channel_id` | String | ✅ | 频道 ID |
| `channel_type` | int | ✅ | 频道类型（1=个人，2=群组） |
| `start_message_seq` | int | ❌ | 起始消息序号（不包含） |
| `end_message_seq` | int | ❌ | 结束消息序号（包含） |
| `limit` | int | ❌ | 最大返回条数（默认 20） |
| `pull_mode` | int | ❌ | 拉取模式（0=向下，1=向上） |

#### 9.3.2 响应

**成功响应** (200 OK):

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "messages": [
      {
        "message_id": "1234567890",
        "message_seq": 100,
        "client_msg_no": "user123_1640995200000_5678",
        "from_uid": "user_456",
        "channel_id": "user_123",
        "channel_type": 1,
        "content_type": 1,
        "content": "{\"content\":\"你好\"}",
        "timestamp": 1640995200000
      }
    ]
  }
}
```

**消息字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `message_id` | String | 服务器消息 ID |
| `message_seq` | int | 消息序号（频道内顺序） |
| `client_msg_no` | String | 客户端消息编号 |
| `from_uid` | String | 发送者 UID |
| `channel_id` | String | 频道 ID |
| `channel_type` | int | 频道类型（1=个人，2=群组） |
| `content_type` | int | 内容类型（1=文本，2=图片，4=语音，5=视频） |
| `content` | String | 消息内容（JSON 字符串） |
| `timestamp` | int | 消息时间戳（毫秒） |

#### 9.3.3 客户端调用示例

```dart
/// 同步历史消息
Future<void> syncChannelMsg(
  String channelID,
  int channelType,
  int startMessageSeq,
  int endMessageSeq,
  int limit,
  int pullMode,
  Function(List<WKMsg>) back,
) async {
  try {
    var response = await http.post(
      Uri.parse('https://api.example.com/message/sync'),
      headers: {
        'Authorization': 'Bearer ${UserInfo.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'channel_id': channelID,
        'channel_type': channelType,
        'start_message_seq': startMessageSeq,
        'end_message_seq': endMessageSeq,
        'limit': limit,
        'pull_mode': pullMode,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> messages = data['data']['messages'] ?? [];

      // 解析消息列表
      List<WKMsg> wkMsgs = messages.map((msgJson) {
        return parseMessage(msgJson);
      }).toList();

      print('获取到 ${wkMsgs.length} 条历史消息');

      // 调用回调，返回消息列表
      back(wkMsgs);
    } else {
      print('同步历史消息失败: ${response.statusCode}');
      back([]);
    }
  } catch (e) {
    print('同步历史消息异常: $e');
    back([]);
  }
}

/// 解析后端返回的消息
WKMsg parseMessage(Map<String, dynamic> msgJson) {
  WKMsg msg = WKMsg();
  msg.messageID = msgJson['message_id'] ?? '';
  msg.messageSeq = msgJson['message_seq'] ?? 0;
  msg.clientMsgNO = msgJson['client_msg_no'] ?? '';
  msg.fromUID = msgJson['from_uid'] ?? '';
  msg.channelID = msgJson['channel_id'] ?? '';
  msg.channelType = msgJson['channel_type'] ?? 0;
  msg.contentType = msgJson['content_type'] ?? 0;
  msg.content = msgJson['content'] ?? '';
  msg.timestamp = msgJson['timestamp'] ?? 0;

  // 解析消息内容
  var contentJson = jsonDecode(msg.content);
  msg.messageContent = WKIM.shared.messageManager.getMessageModel(
    msg.contentType,
    contentJson,
  );

  return msg;
}
```

### 9.4 API 3: 同步会话列表

同步用户的会话列表。

#### 9.4.1 请求

```http
POST /api/conversation/sync HTTP/1.1
Host: api.example.com
Authorization: Bearer <user_token>
Content-Type: application/json

{
  "last_ssg_seqs": [100, 200, 300],
  "msg_count": 1000,
  "version": 100
}
```

**请求参数说明**:

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| `last_ssg_seqs` | List<int> | ❌ | 会话列表序号（用于增量同步） |
| `msg_count` | int | ❌ | 消息数量 |
| `version` | int | ❌ | 会话版本号 |

#### 9.4.2 响应

**成功响应** (200 OK):

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "conversations": [
      {
        "channel_id": "user_123",
        "channel_type": 1,
        "last_msg_seq": 100,
        "last_msg_timestamp": 1640995200000,
        "unread_count": 5,
        "version": 100,
        "channel": {
          "channel_id": "user_123",
          "channel_type": 1,
          "channel_name": "张三",
          "avatar": "https://cdn.example.com/avatar/123.jpg"
        },
        "last_msg": {
          "message_id": "1234567890",
          "message_seq": 100,
          "content_type": 1,
          "content": "{\"content\":\"你好\"}",
          "timestamp": 1640995200000
        }
      }
    ]
  }
}
```

**会话字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `channel_id` | String | 频道 ID |
| `channel_type` | int | 频道类型（1=个人，2=群组） |
| `last_msg_seq` | int | 最后一条消息序号 |
| `last_msg_timestamp` | int | 最后一条消息时间戳 |
| `unread_count` | int | 未读消息数量 |
| `version` | int | 会话版本号 |
| `channel` | Object | 频道信息（昵称、头像等） |
| `last_msg` | Object | 最后一条消息 |

#### 9.4.3 客户端调用示例

```dart
/// 同步会话列表
Future<void> syncConversation(
  List<int> lastSsgSeqs,
  int msgCount,
  int version,
  Function(List<WKUIConversationMsg>) complete,
) async {
  try {
    var response = await http.post(
      Uri.parse('https://api.example.com/conversation/sync'),
      headers: {
        'Authorization': 'Bearer ${UserInfo.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'last_ssg_seqs': lastSsgSeqs,
        'msg_count': msgCount,
        'version': version,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> convList = data['data']['conversations'] ?? [];

      // 解析会话列表
      List<WKUIConversationMsg> conversations = convList.map((convJson) {
        return parseConversation(convJson);
      }).toList();

      print('同步了 ${conversations.length} 个会话');

      // 调用回调，返回会话列表
      complete(conversations);
    } else {
      print('同步会话失败: ${response.statusCode}');
      complete([]);
    }
  } catch (e) {
    print('同步会话异常: $e');
    complete([]);
  }
}

/// 解析后端返回的会话
WKUIConversationMsg parseConversation(Map<String, dynamic> convJson) {
  WKUIConversationMsg conversation = WKUIConversationMsg();
  conversation.channelID = convJson['channel_id'] ?? '';
  conversation.channelType = convJson['channel_type'] ?? 0;
  conversation.unreadCount = convJson['unread_count'] ?? 0;
  conversation.lastMsgTimestamp = convJson['last_msg_timestamp'] ?? 0;

  // 解析频道信息
  var channelJson = convJson['channel'];
  if (channelJson != null) {
    WKChannel channel = WKChannel(conversation.channelID, conversation.channelType);
    channel.channelName = channelJson['channel_name'] ?? '';
    channel.avatar = channelJson['avatar'] ?? '';
    conversation.wkChannel = channel;
  }

  // 解析最后一条消息
  var msgJson = convJson['last_msg'];
  if (msgJson != null) {
    conversation.wkMsg = parseMessage(msgJson);
  }

  return conversation;
}
```

### 9.5 API 4: 获取用户信息

获取指定用户的个人信息。

#### 9.5.1 请求

```http
GET /api/user/{uid} HTTP/1.1
Host: api.example.com
Authorization: Bearer <user_token>
Content-Type: application/json
```

#### 9.5.2 响应

**成功响应** (200 OK):

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "uid": "user_123",
    "nickname": "张三",
    "avatar": "https://cdn.example.com/avatar/123.jpg",
    "username": "zhangsan"
  }
}
```

**用户字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `uid` | String | 用户 ID |
| `nickname` | String | 用户昵称 |
| `avatar` | String | 用户头像 URL |
| `username` | String | 用户名 |

#### 9.5.3 客户端调用示例

```dart
/// 获取用户信息
Future<void> getUserInfo(String uid) async {
  try {
    print('获取用户信息: $uid');

    var response = await http.get(
      Uri.parse('https://api.example.com/user/$uid'),
      headers: {
        'Authorization': 'Bearer ${UserInfo.token}',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var userData = data['data'];

      // 更新或创建频道信息
      WKChannel channel = WKChannel(uid, WKChannelType.personal);
      channel.channelName = userData['nickname'] ?? '';
      channel.avatar = userData['avatar'] ?? '';

      // 保存到本地
      await WKIM.shared.channelManager.saveOrUpdateChannel(channel);

      print('用户信息更新成功: ${channel.channelName}');

      // 刷新 UI
      EventBus.emit('refresh_conversation_list');
    } else {
      print('获取用户信息失败: ${response.statusCode}');
    }
  } catch (e) {
    print('获取用户信息异常: $e');
  }
}
```

### 9.6 API 5: 获取群组信息

获取指定群组的详细信息。

#### 9.6.1 请求

```http
GET /api/group/{groupId} HTTP/1.1
Host: api.example.com
Authorization: Bearer <user_token>
Content-Type: application/json
```

#### 9.6.2 响应

**成功响应** (200 OK):

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "group_id": "group_456",
    "group_name": "工作群",
    "avatar": "https://cdn.example.com/avatar/group_456.jpg",
    "member_count": 50
  }
}
```

**群组字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `group_id` | String | 群组 ID |
| `group_name` | String | 群组名称 |
| `avatar` | String | 群组头像 URL |
| `member_count` | int | 群组成员数量 |

#### 9.6.3 客户端调用示例

```dart
/// 获取群组信息
Future<void> getGroupInfo(String groupId) async {
  try {
    print('获取群组信息: $groupId');

    var response = await http.get(
      Uri.parse('https://api.example.com/group/$groupId'),
      headers: {
        'Authorization': 'Bearer ${UserInfo.token}',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var groupData = data['data'];

      // 更新或创建频道信息
      WKChannel channel = WKChannel(groupId, WKChannelType.group);
      channel.channelName = groupData['group_name'] ?? '';
      channel.avatar = groupData['avatar'] ?? '';

      // 保存到本地
      await WKIM.shared.channelManager.saveOrUpdateChannel(channel);

      print('群组信息更新成功: ${channel.channelName}');

      // 刷新 UI
      EventBus.emit('refresh_conversation_list');
    } else {
      print('获取群组信息失败: ${response.statusCode}');
    }
  } catch (e) {
    print('获取群组信息异常: $e');
  }
}
```

### 9.7 API 6: 上传文件附件

上传图片、语音、视频等附件到服务器。

#### 9.7.1 请求

```http
POST /api/file/upload HTTP/1.1
Host: api.example.com
Authorization: Bearer <user_token>
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="image.jpg"
Content-Type: image/jpeg

<binary file data>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="type"

image
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

**请求参数说明**:

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| `file` | File | ✅ | 上传的文件 |
| `type` | String | ✅ | 文件类型（image/voice/video） |

#### 9.7.2 响应

**成功响应** (200 OK):

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "url": "https://cdn.example.com/files/abc123.jpg",
    "size": 123456
  }
}
```

**响应字段说明**:

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `url` | String | 文件的访问 URL |
| `size` | int | 文件大小（字节） |

#### 9.7.3 客户端调用示例

```dart
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class FileUploader {
  /// 上传文件到服务器
  static Future<String?> uploadFile(String localPath, String fileType) async {
    try {
      File file = File(localPath);
      String fileName = path.basename(localPath);

      // 创建 FormData
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.example.com/file/upload'),
      );

      // 添加文件
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));

      // 添加文件类型
      request.fields['type'] = fileType;

      // 添加认证头
      request.headers['Authorization'] = 'Bearer ${UserInfo.token}';

      // 发送请求
      var response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        String url = data['data']['url'] ?? '';
        print('文件上传成功: $url');
        return url;
      } else {
        print('文件上传失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('文件上传异常: $e');
      return null;
    }
  }

  /// 上传图片
  static Future<String?> uploadImage(String localPath) async {
    return await uploadFile(localPath, 'image');
  }

  /// 上传语音
  static Future<String?> uploadVoice(String localPath) async {
    return await uploadFile(localPath, 'voice');
  }

  /// 上传视频
  static Future<String?> uploadVideo(String localPath) async {
    return await uploadFile(localPath, 'video');
  }
}
```

### 9.8 完整的 HttpUtils 类

将所有 API 调用整合到一个类中：

```dart
import 'package:http/http.dart' as http;
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/type/const.dart';

class HttpUtils {
  static String get baseUrl => 'https://api.example.com';
  static String get token => UserInfo.token;

  /// 获取 IM 服务器地址
  static Future<String> getIP(String uid) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/im/server'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['data']['address'] ?? 'ws://im.example.com:5100';
      }
    } catch (e) {
      print('获取 IP 失败: $e');
    }
    return 'ws://im.example.com:5100';
  }

  /// 同步历史消息
  static Future<void> syncChannelMsg(
    String channelID,
    int channelType,
    int startMessageSeq,
    int endMessageSeq,
    int limit,
    int pullMode,
    Function(List<WKMsg>) back,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/message/sync'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'channel_id': channelID,
          'channel_type': channelType,
          'start_message_seq': startMessageSeq,
          'end_message_seq': endMessageSeq,
          'limit': limit,
          'pull_mode': pullMode,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> messages = data['data']['messages'] ?? [];

        List<WKMsg> wkMsgs = messages.map((msgJson) {
          return parseMessage(msgJson);
        }).toList();

        print('获取到 ${wkMsgs.length} 条历史消息');
        back(wkMsgs);
      } else {
        back([]);
      }
    } catch (e) {
      print('同步历史消息异常: $e');
      back([]);
    }
  }

  /// 同步会话列表
  static Future<void> syncConversation(
    List<int> lastSsgSeqs,
    int msgCount,
    int version,
    Function(List<WKUIConversationMsg>) complete,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/conversation/sync'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'last_ssg_seqs': lastSsgSeqs,
          'msg_count': msgCount,
          'version': version,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> convList = data['data']['conversations'] ?? [];

        List<WKUIConversationMsg> conversations = convList.map((convJson) {
          return parseConversation(convJson);
        }).toList();

        print('同步了 ${conversations.length} 个会话');
        complete(conversations);
      } else {
        complete([]);
      }
    } catch (e) {
      print('同步会话异常: $e');
      complete([]);
    }
  }

  /// 获取用户信息
  static Future<void> getUserInfo(String uid) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/user/$uid'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var userData = data['data'];

        WKChannel channel = WKChannel(uid, WKChannelType.personal);
        channel.channelName = userData['nickname'] ?? '';
        channel.avatar = userData['avatar'] ?? '';

        await WKIM.shared.channelManager.saveOrUpdateChannel(channel);

        EventBus.emit('refresh_conversation_list');
      }
    } catch (e) {
      print('获取用户信息异常: $e');
    }
  }

  /// 获取群组信息
  static Future<void> getGroupInfo(String groupId) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/group/$groupId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var groupData = data['data'];

        WKChannel channel = WKChannel(groupId, WKChannelType.group);
        channel.channelName = groupData['group_name'] ?? '';
        channel.avatar = groupData['avatar'] ?? '';

        await WKIM.shared.channelManager.saveOrUpdateChannel(channel);

        EventBus.emit('refresh_conversation_list');
      }
    } catch (e) {
      print('获取群组信息异常: $e');
    }
  }

  /// 上传文件
  static Future<String?> uploadFile(String localPath, String fileType) async {
    try {
      File file = File(localPath);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/file/upload'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['type'] = fileType;
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        return data['data']['url'];
      }
    } catch (e) {
      print('上传文件异常: $e');
    }
    return null;
  }

  /// 解析消息
  static WKMsg parseMessage(Map<String, dynamic> msgJson) {
    WKMsg msg = WKMsg();
    msg.messageID = msgJson['message_id'] ?? '';
    msg.messageSeq = msgJson['message_seq'] ?? 0;
    msg.clientMsgNO = msgJson['client_msg_no'] ?? '';
    msg.fromUID = msgJson['from_uid'] ?? '';
    msg.channelID = msgJson['channel_id'] ?? '';
    msg.channelType = msgJson['channel_type'] ?? 0;
    msg.contentType = msgJson['content_type'] ?? 0;
    msg.content = msgJson['content'] ?? '';
    msg.timestamp = msgJson['timestamp'] ?? 0;

    var contentJson = jsonDecode(msg.content);
    msg.messageContent = WKIM.shared.messageManager.getMessageModel(
      msg.contentType,
      contentJson,
    );

    return msg;
  }

  /// 解析会话
  static WKUIConversationMsg parseConversation(Map<String, dynamic> convJson) {
    WKUIConversationMsg conversation = WKUIConversationMsg();
    conversation.channelID = convJson['channel_id'] ?? '';
    conversation.channelType = convJson['channel_type'] ?? 0;
    conversation.unreadCount = convJson['unread_count'] ?? 0;
    conversation.lastMsgTimestamp = convJson['last_msg_timestamp'] ?? 0;

    var channelJson = convJson['channel'];
    if (channelJson != null) {
      WKChannel channel = WKChannel(conversation.channelID, conversation.channelType);
      channel.channelName = channelJson['channel_name'] ?? '';
      channel.avatar = channelJson['avatar'] ?? '';
      conversation.wkChannel = channel;
    }

    var msgJson = convJson['last_msg'];
    if (msgJson != null) {
      conversation.wkMsg = parseMessage(msgJson);
    }

    return conversation;
  }
}
```

---

**下一章**: [10. 完整实现示例](#10-完整实现示例) - 详细讲解 IMService 类的完整实现、Flutter 应用集成和聊天 UI 示例。

## 10. 完整实现示例

本章将提供一个完整的 IM 功能实现示例，包括 IMService 类、Flutter 应用集成和聊天 UI 示例。

### 10.1 创建 IMService 类

`IMService` 是一个封装所有 IM 功能的单例类，提供统一的接口。

```dart
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/model/wk_image_content.dart';
import 'package:wukongimfluttersdk/model/wk_voice_content.dart';
import 'package:wukongimfluttersdk/model/wk_video_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:flutter/foundation.dart';

class IMService {
  // 单例
  IMService._internal();
  static final IMService _instance = IMService._internal();
  factory IMService() => _instance;

  // 连接状态
  bool _isConnected = false;
  bool _isConnecting = false;

  // 当前用户信息
  String _uid = '';
  String _token = '';

  // 获取器
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;

  /// 初始化 SDK
  Future<bool> init(String uid, String token) async {
    _uid = uid;
    _token = token;

    try {
      // 1. 创建配置
      Options options = Options.newDefault(uid, token);
      options.debug = kDebugMode;  // 调试模式下开启日志

      // 2. 配置动态获取服务器地址
      options.getAddr = (Function(String address) complete) async {
        String ip = await _fetchIMServerAddress();
        complete(ip);
      };

      // 3. 初始化 SDK
      bool success = await WKIM.shared.setup(options);

      if (success) {
        // 4. 注册监听器
        _registerListeners();

        // 5. 连接 IM
        connect();

        print('IMService 初始化成功');
      } else {
        print('IMService 初始化失败');
      }

      return success;
    } catch (e) {
      print('IMService 初始化异常: $e');
      return false;
    }
  }

  /// 连接 IM
  void connect() {
    if (_isConnecting) {
      print('正在连接中，请勿重复调用');
      return;
    }

    _isConnecting = true;
    WKIM.shared.connectionManager.connect();
  }

  /// 断开连接
  void disconnect({bool isLogout = false}) {
    WKIM.shared.connectionManager.disconnect(isLogout);
    _isConnected = false;
    _isConnecting = false;

    if (isLogout) {
      _uid = '';
      _token = '';
    }
  }

  /// 注册所有监听器
  void _registerListeners() {
    // 1. 连接状态监听器
    WKIM.shared.connectionManager.addOnConnectionStatus(
      'im_connection',
      (status, reason, connectInfo) {
        _handleConnectionStatus(status, reason, connectInfo);
      },
    );

    // 2. 新消息监听器
    WKIM.shared.messageManager.addOnNewMsgListener(
      'im_new_msg',
      (WKMsg msg) {
        _handleNewMessage(msg);
      },
    );

    // 3. 消息入库监听器
    WKIM.shared.messageManager.addOnMsgInsertedListener((WKMsg msg) {
      _handleMessageInserted(msg);
    });

    // 4. CMD 消息监听器
    WKIM.shared.cmdManager.addOnCmdListener(
      'im_cmd',
      (WKCmd cmd) async {
        await _handleCmdMessage(cmd);
      },
    );

    // 5. 历史消息同步监听器
    WKIM.shared.messageManager.addOnSyncChannelMsgListener(
      (channelID, channelType, startSeq, endSeq, limit, pullMode, back) {
        _syncChannelMessages(channelID, channelType, startSeq, endSeq, limit, pullMode, back);
      },
    );

    // 6. 获取频道信息监听器
    WKIM.shared.channelManager.addOnGetChannelListener(
      (channelId, channelType, back) {
        _getChannelInfo(channelId, channelType);
      },
    );

    // 7. 会话同步监听器
    WKIM.shared.conversationManager.addOnSyncConversationListener(
      (lastSsgSeqs, msgCount, version, back) {
        _syncConversations(lastSsgSeqs, msgCount, version, back);
      },
    );

    // 8. 附件上传监听器
    WKIM.shared.messageManager.addOnUploadAttachmentListener(
      (wkMsg, back) {
        _uploadAttachment(wkMsg, back);
      },
    );

    print('所有监听器注册完成');
  }

  /// 处理连接状态
  void _handleConnectionStatus(int status, int? reason, ConnectionInfo? connectInfo) {
    switch (status) {
      case WKConnectStatus.connecting:
        _isConnecting = true;
        _isConnected = false;
        print('IM 连接中...');
        break;

      case WKConnectStatus.success:
        _isConnecting = false;
        _isConnected = true;
        String nodeId = connectInfo?.nodeId.toString() ?? '未知';
        print('IM 连接成功，节点ID: $nodeId');
        break;

      case WKConnectStatus.fail:
        _isConnecting = false;
        _isConnected = false;
        print('IM 连接失败，原因: $reason');
        break;

      case WKConnectStatus.noNetwork:
        _isConnecting = false;
        _isConnected = false;
        print('IM 无网络');
        break;

      case WKConnectStatus.kicked:
        _isConnecting = false;
        _isConnected = false;
        print('IM 被踢下线');
        break;

      case WKConnectStatus.syncMsg:
        print('IM 正在同步消息...');
        break;

      case WKConnectStatus.syncCompleted:
        print('IM 消息同步完成');
        break;
    }
  }

  /// 处理新消息
  void _handleNewMessage(WKMsg msg) {
    // 不处理自己的消息
    if (msg.fromUID == _uid) {
      return;
    }

    print('收到新消息: ${msg.messageID}');

    // TODO: 播放提示音、震动、显示通知等
  }

  /// 处理消息入库
  void _handleMessageInserted(WKMsg msg) {
    print('消息已入库: ${msg.messageID}');

    // TODO: 刷新 UI
  }

  /// 处理 CMD 消息
  Future<void> _handleCmdMessage(WKCmd cmd) async {
    print('收到 CMD 消息: ${cmd.cmd}');

    if (cmd.cmd == 'messageRevoke') {
      var channelID = cmd.param['channel_id'];
      var channelType = cmd.param['channel_type'];
      if (channelID != '') {
        var maxVersion = await WKIM.shared.messageManager.getMaxExtraVersionWithChannel(channelID, channelType);
        await BackendAPI.syncMessageExtra(channelID, channelType, maxVersion);
      }
    } else if (cmd.cmd == 'channelUpdate') {
      var channelID = cmd.param['channel_id'];
      var channelType = cmd.param['channel_type'];
      if (channelID != '') {
        if (channelType == WKChannelType.personal) {
          await BackendAPI.getUserInfo(channelID);
        } else if (channelType == WKChannelType.group) {
          await BackendAPI.getGroupInfo(channelID);
        }
      }
    } else if (cmd.cmd == 'unreadClear') {
      var channelID = cmd.param['channel_id'];
      var channelType = cmd.param['channel_type'];
      var unread = cmd.param['unread'];
      if (channelID != '') {
        WKIM.shared.conversationManager.updateRedDot(channelID, channelType, unread);
      }
    }
  }

  /// 同步历史消息
  void _syncChannelMessages(
    String channelID,
    int channelType,
    int startSeq,
    int endSeq,
    int limit,
    int pullMode,
    Function(List<WKMsg>) back,
  ) async {
    print('同步历史消息: $channelID');

    List<WKMsg> messages = await BackendAPI.syncChannelMessages(
      channelID,
      channelType,
      startSeq,
      endSeq,
      limit,
      pullMode,
    );

    back(messages);
  }

  /// 获取频道信息
  void _getChannelInfo(String channelId, int channelType) async {
    print('获取频道信息: $channelId, $channelType');

    if (channelType == WKChannelType.personal) {
      await BackendAPI.getUserInfo(channelId);
    } else if (channelType == WKChannelType.group) {
      await BackendAPI.getGroupInfo(channelId);
    }
  }

  /// 同步会话列表
  void _syncConversations(
    List<int> lastSsgSeqs,
    int msgCount,
    int version,
    Function(List<WKUIConversationMsg>) back,
  ) async {
    print('同步会话列表');

    List<WKUIConversationMsg> conversations = await BackendAPI.syncConversations(
      lastSsgSeqs,
      msgCount,
      version,
    );

    back(conversations);
  }

  /// 上传附件
  void _uploadAttachment(WKMsg wkMsg, Function(bool, WKMsg) back) async {
    if (wkMsg.contentType == WkMessageContentType.image) {
      WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
      String? url = await BackendAPI.uploadImage(imageContent.localPath);

      if (url != null) {
        imageContent.url = url;
        wkMsg.messageContent = imageContent;
        back(true, wkMsg);
      } else {
        back(false, wkMsg);
      }
    } else if (wkMsg.contentType == WkMessageContentType.voice) {
      WKVoiceContent voiceContent = wkMsg.messageContent! as WKVoiceContent;
      String? url = await BackendAPI.uploadVoice(voiceContent.localPath);

      if (url != null) {
        voiceContent.url = url;
        wkMsg.messageContent = voiceContent;
        back(true, wkMsg);
      } else {
        back(false, wkMsg);
      }
    } else if (wkMsg.contentType == WkMessageContentType.video) {
      WKVideoContent videoContent = wkMsg.messageContent! as WKVideoContent;
      String? videoUrl = await BackendAPI.uploadVideo(videoContent.localPath);
      String? coverUrl = await BackendAPI.uploadImage(videoContent.coverLocalPath);

      if (videoUrl != null && coverUrl != null) {
        videoContent.url = videoUrl;
        videoContent.cover = coverUrl;
        wkMsg.messageContent = videoContent;
        back(true, wkMsg);
      } else {
        back(false, wkMsg);
      }
    }
  }

  /// 获取 IM 服务器地址
  Future<String> _fetchIMServerAddress() async {
    return await BackendAPI.getIMServerAddress();
  }

  /// 发送文本消息
  Future<WKMsg?> sendTextMessage(String text, String channelID, int channelType) async {
    try {
      WKTextContent textContent = WKTextContent(text);
      WKChannel channel = WKChannel(channelID, channelType);

      WKMsg msg = await WKIM.shared.messageManager.sendMessage(textContent, channel);
      print('文本消息发送成功: ${msg.messageID}');

      return msg;
    } catch (e) {
      print('文本消息发送失败: $e');
      return null;
    }
  }

  /// 发送图片消息
  Future<WKMsg?> sendImageMessage(String imagePath, String channelID, int channelType) async {
    try {
      // 获取图片尺寸
      var decodedImage = await decodeImageFromList(await File(imagePath).readAsBytes());
      int width = decodedImage.width;
      int height = decodedImage.height;

      WKImageContent imageContent = WKImageContent(width, height);
      imageContent.localPath = imagePath;

      WKChannel channel = WKChannel(channelID, channelType);

      WKMsg msg = await WKIM.shared.messageManager.sendMessage(imageContent, channel);
      print('图片消息发送中...');

      return msg;
    } catch (e) {
      print('图片消息发送失败: $e');
      return null;
    }
  }

  /// 发送语音消息
  Future<WKMsg?> sendVoiceMessage(String voicePath, int duration, String channelID, int channelType) async {
    try {
      WKVoiceContent voiceContent = WKVoiceContent(duration);
      voiceContent.localPath = voicePath;

      WKChannel channel = WKChannel(channelID, channelType);

      WKMsg msg = await WKIM.shared.messageManager.sendMessage(voiceContent, channel);
      print('语音消息发送中...');

      return msg;
    } catch (e) {
      print('语音消息发送失败: $e');
      return null;
    }
  }

  /// 获取会话列表
  Future<List<WKUIConversationMsg>> getConversationList() async {
    List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.queryConversationList();
    print('查询到 ${conversations.length} 个会话');
    return conversations;
  }

  /// 获取历史消息
  Future<List<WKMsg>> getHistoryMessages(String channelID, int channelType, {int limit = 20}) async {
    List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
      channelID,
      channelType,
      limit: limit,
      order: WKOrder.desc,
    );
    print('查询到 ${messages.length} 条历史消息');
    return messages.reversed;  // 转换为升序
  }

  /// 标记已读
  Future<void> markAsRead(String channelID, int channelType) async {
    await WKIM.shared.messageManager.clearUnread(channelID, channelType);
    print('标记已读: $channelID');
  }

  /// 置顶会话
  Future<void> setConversationTop(String channelID, int channelType, bool isTop) async {
    await WKIM.shared.conversationManager.setTop(channelID, channelType, isTop);
    print('会话 $channelID ${isTop ? "已置顶" : "已取消置顶"}');
  }

  /// 设置免打扰
  Future<void> setConversationMute(String channelID, int channelType, bool isMute) async {
    await WKIM.shared.conversationManager.setMute(channelID, channelType, isMute);
    print('会话 $channelID ${isMute ? "已免打扰" : "已取消免打扰"}');
  }

  /// 删除会话
  Future<void> deleteConversation(String channelID, int channelType) async {
    await WKIM.shared.conversationManager.deleteConversation(channelID, channelType);
    print('会话 $channelID 已删除');
  }

  /// 销毁
  void dispose() {
    WKIM.shared.connectionManager.removeOnConnectionStatus('im_connection');
    WKIM.shared.messageManager.removeOnNewMsgListener('im_new_msg');
    WKIM.shared.cmdManager.removeOnCmdListener('im_cmd');
    // 注意：其他监听器可能没有 remove 方法

    print('IMService 已销毁');
  }
}
```

### 10.2 在 Flutter 应用中集成 IMService

#### 10.2.1 main.dart 初始化

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'im_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 IM
  bool success = await IMService().init('user_123', 'user_token');

  if (!success) {
    print('IM 初始化失败');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WuKongIM Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConversationListPage(),
    );
  }
}
```

### 10.3 聊天界面 UI 示例

#### 10.3.1 会话列表页面

```dart
class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  final List<WKUIConversationMsg> _conversations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);

    List<WKUIConversationMsg> conversations = await IMService().getConversationList();

    setState(() {
      _conversations.clear();
      _conversations.addAll(conversations);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? const Center(child: Text('暂无消息'))
              : ListView.builder(
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    return _buildConversationItem(_conversations[index]);
                  },
                ),
    );
  }

  Widget _buildConversationItem(WKUIConversationMsg conversation) {
    String title = conversation.wkChannel?.channelName ?? '未知';
    String lastMessage = conversation.wkMsg?.messageContent?.displayText() ?? '';
    int unreadCount = conversation.unreadCount;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: conversation.wkChannel?.avatar != null
            ? NetworkImage(conversation.wkChannel!.avatar!)
            : null,
        child: conversation.wkChannel?.avatar == null ? Text(title[0]) : null,
      ),
      title: Text(title),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              channelID: conversation.channelID,
              channelType: conversation.channelType,
            ),
          ),
        );
      },
    );
  }
}
```

#### 10.3.2 聊天页面

```dart
class ChatPage extends StatefulWidget {
  final String channelID;
  final int channelType;

  const ChatPage({
    required this.channelID,
    required this.channelType,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<WKMsg> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    List<WKMsg> messages = await IMService().getHistoryMessages(
      widget.channelID,
      widget.channelType,
      limit: 20,
    );

    setState(() {
      _messages.clear();
      _messages.addAll(messages);
      _isLoading = false;
    });

    // 滚动到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });

    // 标记已读
    await IMService().markAsRead(widget.channelID, widget.channelType);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendTextMessage() async {
    String text = _textController.text.trim();

    if (text.isEmpty) {
      return;
    }

    _textController.clear();

    WKMsg? msg = await IMService().sendTextMessage(
      text,
      widget.channelID,
      widget.channelType,
    );

    if (msg != null) {
      setState(() {
        _messages.add(msg);
      });

      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聊天'),
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // 输入框
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '输入消息...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendTextMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(WKMsg msg) {
    bool isSelf = msg.fromUID == WKIM.shared.options.uid;

    return Align(
      alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelf ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.messageContent?.displayText() ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              formatTimestamp(msg.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
```

---

**下一章**: [11. 进阶功能](#11-进阶功能) - 详细讲解自定义消息类型、消息扩展、阅后即焚、消息回执、@提醒等功能。

## 11. 进阶功能

本章将介绍 WuKongIM SDK 的进阶功能，包括自定义消息类型、消息扩展、阅后即焚、消息回执、@提醒等。

### 11.1 自定义消息类型

SDK 允许开发者自定义消息类型，用于满足特殊业务需求。

#### 11.1.1 创建自定义消息内容类

自定义消息类型需要继承 `WKMessageContent` 基类。

**示例：订单消息**

```dart
import 'package:wukongimfluttersdk/model/wk_message_content.dart';

/// 订单消息内容
class OrderMessageContent extends WKMessageContent {
  String orderNo;          // 订单号
  String orderTitle;       // 订单标题
  double orderAmount;       // 订单金额
  String orderStatus;       // 订单状态

  OrderMessageContent({
    required this.orderNo,
    required this.orderTitle,
    required this.orderAmount,
    required this.orderStatus,
  }) {
    contentType = 100;  // 自定义消息类型（100以上）
  }

  @override
  Map<String, dynamic> encodeJson() {
    return {
      'order_no': orderNo,
      'order_title': orderTitle,
      'order_amount': orderAmount,
      'order_status': orderStatus,
    };
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    orderNo = json['order_no'] ?? '';
    orderTitle = json['order_title'] ?? '';
    orderAmount = (json['order_amount'] ?? 0).toDouble();
    orderStatus = json['order_status'] ?? '';
    return this;
  }

  @override
  String displayText() {
    return '[订单] $orderTitle - ¥$orderAmount';
  }

  @override
  String searchableWord() {
    return '$orderNo $orderTitle';
  }
}
```

#### 11.1.2 注册自定义消息类型

在 SDK 初始化时注册自定义消息类型。

```dart
void registerCustomMessageTypes() {
  // 注册订单消息
  WKIM.shared.messageManager.registerMsgContent(
    100,  // 消息类型
    (dynamic data) => OrderMessageContent().decodeJson(data),
  );

  print('自定义消息类型注册完成');
}
```

#### 11.1.3 发送自定义消息

```dart
Future<void> sendOrderMessage() async {
  // 创建订单消息内容
  OrderMessageContent orderContent = OrderMessageContent(
    orderNo: 'ORDER20240101001',
    orderTitle: 'iPhone 15 Pro Max',
    orderAmount: 9999.00,
    orderStatus: '待付款',
  );

  // 创建频道
  WKChannel channel = WKChannel('user_456', WKChannelType.personal);

  // 发送消息
  WKMsg msg = await WKIM.shared.messageManager.sendMessage(orderContent, channel);
  
  print('订单消息发送成功: ${msg.messageID}');
}
```

#### 11.1.4 显示自定义消息

```dart
Widget _buildMessageBubble(WKMsg msg) {
  // 判断消息类型
  if (msg.contentType == 100) {
    // 订单消息
    return _buildOrderMessageBubble(msg);
  } else if (msg.contentType == WkMessageContentType.text) {
    // 文本消息
    return _buildTextMessageBubble(msg);
  } else if (msg.contentType == WkMessageContentType.image) {
    // 图片消息
    return _buildImageMessageBubble(msg);
  } else {
    // 默认显示
    return _buildDefaultMessageBubble(msg);
  }
}

Widget _buildOrderMessageBubble(WKMsg msg) {
  OrderMessageContent? orderContent = msg.messageContent as OrderMessageContent?;

  if (orderContent == null) {
    return const SizedBox.shrink();
  }

  bool isSelf = msg.fromUID == WKIM.shared.options.uid;

  return Align(
    alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_cart, size: 20, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                '订单消息',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('订单号：${orderContent.orderNo}'),
          const SizedBox(height: 4),
          Text('订单标题：${orderContent.orderTitle}'),
          const SizedBox(height: 4),
          Text('订单金额：¥${orderContent.orderAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 4),
          Text('订单状态：${orderContent.orderStatus}'),
        ],
      ),
    ),
  );
}
```

### 11.2 消息扩展

`WKMsgExtra` 用于存储消息的扩展信息，如点赞数、回复数等。

#### 11.2.1 获取消息扩展

```dart
Future<WKMsgExtra?> getMessageExtra(String messageID) async {
  WKMsgExtra? extra = await WKIM.shared.messageManager.getMsgExtra(messageID);
  
  if (extra != null) {
    print('消息扩展: ${extra.messageID}');
    print('已读人数: ${extra.readed}');
    print('未读人数: ${extra.unreadCount}');
  }
  
  return extra;
}
```

#### 11.2.2 更新消息扩展

```dart
Future<void> updateMessageExtra(String messageID) async {
  // 获取消息扩展
  WKMsgExtra? extra = await getMessageExtra(messageID);
  
  if (extra != null) {
    // 更新已读人数
    extra.readed = extra.readed + 1;
    
    // 保存到本地
    await WKIM.shared.messageManager.saveOrUpdateExtra(extra);
    
    print('消息扩展已更新: 已读人数 ${extra.readed}');
  }
}
```

### 11.3 阅后即焚（Flame Messages）

阅后即焚消息是指消息被对方阅读后自动删除，适合发送敏感内容。

#### 11.3.1 发送阅后即焚消息

```dart
Future<void> sendFlameMessage() async {
  // 创建文本消息
  WKTextContent textContent = WKTextContent('这是一条阅后即焚消息，30秒后自动删除');
  
  // 创建频道
  WKChannel channel = WKChannel('user_456', WKChannelType.personal);
  
  // 创建发送配置
  WKSendOptions options = WKSendOptions();
  options.expire = 30;  // 30秒后过期
  
  // 发送消息
  WKMsg msg = await WKIM.shared.messageManager.sendWithOption(
    textContent,
    channel,
    options,
  );
  
  print('阅后即焚消息发送成功: ${msg.messageID}');
}
```

#### 11.3.2 处理阅后即焚消息

SDK 会自动处理阅后即焚消息的过期删除，开发者无需额外处理。

### 11.4 消息回执

消息回执功能可以让发送者知道消息是否已被对方阅读。

#### 11.4.1 开启消息回执

```dart
Future<void> sendMessageWithReceipt() async {
  // 创建文本消息
  WKTextContent textContent = WKTextContent('重要消息，请查收');
  
  // 创建频道
  WKChannel channel = WKChannel('user_456', WKChannelType.personal);
  
  // 创建发送配置，开启消息回执
  WKSendOptions options = WKSendOptions();
  options.setting.receipt = 1;  // 开启消息回执
  
  // 发送消息
  WKMsg msg = await WKIM.shared.messageManager.sendWithOption(
    textContent,
    channel,
    options,
  );
  
  print('消息发送成功（开启回执）: ${msg.messageID}');
}
```

#### 11.4.2 标记消息已读

当用户阅读消息后，需要调用 SDK 方法标记已读。

```dart
Future<void> markMessagesAsRead(List<WKMsg> messages) async {
  for (WKMsg msg in messages) {
    // 更新消息扩展的已读人数
    WKMsgExtra? extra = await WKIM.shared.messageManager.getMsgExtra(msg.messageID);
    
    if (extra != null) {
      extra.readed = extra.readed + 1;
      await WKIM.shared.messageManager.saveOrUpdateExtra(extra);
    }
  }
  
  print('已标记 ${messages.length} 条消息为已读');
}
```

### 11.5 @提醒功能

@提醒功能（@Mention）用于在群聊中提醒特定成员。

#### 11.5.1 发送 @消息

```dart
Future<void> sendMentionMessage() async {
  // 创建文本消息，包含 @成员
  WKTextContent textContent = WKTextContent('@user_456 请查看这条消息');
  
  // 创建频道
  WKChannel channel = WKChannel('group_789', WKChannelType.group);
  
  // 发送消息
  WKMsg msg = await WKIM.shared.messageManager.sendMessage(textContent, channel);
  
  print('@消息发送成功: ${msg.messageID}');
}
```

#### 11.5.2 监听 @提醒

使用 `ReminderManager` 监听 @提醒事件。

```dart
void initReminderListener() {
  // 注册 @提醒监听器
  WKIM.shared.reminderManager.addReminderListener((List<WKReminder> reminders) {
    for (WKReminder reminder in reminders) {
      print('收到 @提醒:');
      print('  频道: ${reminder.channelID}');
      print('  提醒类型: ${reminder.type}');
      print('  提醒内容: ${reminder.text}');
      
      // 处理 @提醒
      handleReminder(reminder);
    }
  });
}

void handleReminder(WKReminder reminder) {
  // 显示 @提醒通知
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('@提醒'),
      content: Text(reminder.text),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('确定'),
        ),
      ],
    ),
  );
}
```

### 11.6 完整进阶功能示例

```dart
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/type/const.dart';

class AdvancedFeatures {
  /// 初始化进阶功能
  static void init() {
    // 1. 注册自定义消息类型
    registerCustomMessages();
    
    // 2. 注册 @提醒监听器
    registerReminderListener();
  }

  /// 注册自定义消息类型
  static void registerCustomMessages() {
    // 订单消息
    WKIM.shared.messageManager.registerMsgContent(
      100,
      (data) => OrderMessageContent().decodeJson(data),
    );
    
    // 红包消息
    WKIM.shared.messageManager.registerMsgContent(
      101,
      (data) => RedPacketMessageContent().decodeJson(data),
    );
    
    print('自定义消息类型注册完成');
  }

  /// 注册 @提醒监听器
  static void registerReminderListener() {
    WKIM.shared.reminderManager.addReminderListener((reminders) {
      for (var reminder in reminders) {
        print('收到 @提醒: ${reminder.text}');
      }
    });
  }

  /// 发送订单消息
  static Future<void> sendOrderMessage({
    required String orderNo,
    required String orderTitle,
    required double orderAmount,
    required String channelID,
    required int channelType,
  }) async {
    OrderMessageContent orderContent = OrderMessageContent(
      orderNo: orderNo,
      orderTitle: orderTitle,
      orderAmount: orderAmount,
      orderStatus: '待付款',
    );

    WKChannel channel = WKChannel(channelID, channelType);

    WKMsg msg = await WKIM.shared.messageManager.sendMessage(orderContent, channel);
    print('订单消息发送成功: ${msg.messageID}');
  }

  /// 发送阅后即焚消息
  static Future<void> sendFlameMessage({
    required String text,
    required String channelID,
    required int channelType,
    int expireSeconds = 30,
  }) async {
    WKTextContent textContent = WKTextContent(text);
    WKChannel channel = WKChannel(channelID, channelType);

    WKSendOptions options = WKSendOptions();
    options.expire = expireSeconds;

    WKMsg msg = await WKIM.shared.messageManager.sendWithOption(
      textContent,
      channel,
      options,
    );

    print('阅后即焚消息发送成功: ${msg.messageID}');
  }

  /// 发送带回执的消息
  static Future<void> sendMessageWithReceipt({
    required String text,
    required String channelID,
    required int channelType,
  }) async {
    WKTextContent textContent = WKTextContent(text);
    WKChannel channel = WKChannel(channelID, channelType);

    WKSendOptions options = WKSendOptions();
    options.setting.receipt = 1;

    WKMsg msg = await WKIM.shared.messageManager.sendWithOption(
      textContent,
      channel,
      options,
    );

    print('带回执消息发送成功: ${msg.messageID}');
  }
}

// 红包消息示例
class RedPacketMessageContent extends WKMessageContent {
  double amount;          // 红包金额
  String remark;         // 红包备注

  RedPacketMessageContent({
    required this.amount,
    required this.remark,
  }) {
    contentType = 101;
  }

  @override
  Map<String, dynamic> encodeJson() {
    return {
      'amount': amount,
      'remark': remark,
    };
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    amount = (json['amount'] ?? 0).toDouble();
    remark = json['remark'] ?? '';
    return this;
  }

  @override
  String displayText() {
    return '[红包] ¥$amount';
  }

  @override
  String searchableWord() {
    return '红包 $remark';
  }
}
```

---

**下一章**: [12. 常见问题与最佳实践](#12-常见问题与最佳实践) - 详细讲解常见错误、性能优化、调试技巧和最佳实践。

## 12. 常见问题与最佳实践

本章将介绍使用 WuKongIM SDK 过程中常见的错误、性能优化建议、调试技巧和最佳实践。

### 12.1 常见错误

#### 12.1.1 错误 1: 未注册 8 个监听器

**症状**: 功能异常，无法正常收发消息。

**原因**: SDK 需要 8 个监听器才能正常工作，如果未注册会导致功能异常。

**解决方案**:

```dart
// ✅ 正确做法：在 SDK 初始化后立即注册所有监听器
void initIM() {
  WKIM.shared.setup(options);
  
  // 注册所有 8 个监听器
  _registerAllListeners();
  
  WKIM.shared.connectionManager.connect();
}

void _registerAllListeners() {
  // 1. 连接状态监听器
  WKIM.shared.connectionManager.addOnConnectionStatus('key', (status, reason, info) {
    // 处理连接状态
  });
  
  // 2. 新消息监听器
  WKIM.shared.messageManager.addOnNewMsgListener('key', (msg) {
    // 处理新消息
  });
  
  // 3. 消息入库监听器
  WKIM.shared.messageManager.addOnMsgInsertedListener((msg) {
    // 处理消息入库
  });
  
  // 4. CMD 消息监听器
  WKIM.shared.cmdManager.addOnCmdListener('key', (cmd) async {
    // 处理 CMD 消息
  });
  
  // 5. 历史消息同步监听器
  WKIM.shared.messageManager.addOnSyncChannelMsgListener((...args) {
    // 处理历史消息同步
  });
  
  // 6. 获取频道信息监听器
  WKIM.shared.channelManager.addOnGetChannelListener((...args) {
    // 处理获取频道信息
  });
  
  // 7. 会话同步监听器
  WKIM.shared.conversationManager.addOnSyncConversationListener((...args) {
    // 处理会话同步
  });
  
  // 8. 附件上传监听器
  WKIM.shared.messageManager.addOnUploadAttachmentListener((...args) {
    // 处理附件上传
  });
}

// ❌ 错误做法：未注册监听器
void initIMWrong() {
  WKIM.shared.setup(options);
  WKIM.shared.connectionManager.connect();
  // 忘记注册监听器，导致功能异常
}
```

#### 12.1.2 错误 2: clientMsgNO 重复

**症状**: 消息去重失败，消息显示异常。

**原因**: `clientMsgNO` 用于消息去重，如果重复会导致 SDK 认为是同一条消息。

**解决方案**:

```dart
// ✅ 正确做法：生成唯一的 clientMsgNO
String generateClientMsgNO() {
  // 格式: {uid}_{timestamp}_{random}
  String uid = WKIM.shared.options.uid;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int random = Random().nextInt(10000);
  
  return '${uid}_$timestamp_$random';
}

// 发送消息时使用
WKMsg msg = WKMsg();
msg.clientMsgNO = generateClientMsgNO();  // 每次都生成新的

// ❌ 错误做法：使用固定的 clientMsgNO
WKMsg msg = WKMsg();
msg.clientMsgNO = 'fixed_client_msg_no';  // 错误：所有消息都使用相同的 NO
```

#### 12.1.3 错误 3: 上传附件后未更新 url 字段

**症状**: 图片、语音、视频消息发送失败。

**原因**: 上传附件后必须更新 `url` 字段，否则 SDK 无法发送消息。

**解决方案**:

```dart
// ✅ 正确做法：上传后更新 url 字段
WKIM.shared.messageManager.addOnUploadAttachmentListener((wkMsg, back) async {
  if (wkMsg.contentType == WkMessageContentType.image) {
    WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
    
    // 上传图片
    String? uploadedUrl = await uploadImage(imageContent.localPath);
    
    if (uploadedUrl != null) {
      // ✅ 更新 url 字段
      imageContent.url = uploadedUrl;
      wkMsg.messageContent = imageContent;
      
      // 调用 back 返回
      back(true, wkMsg);
    } else {
      back(false, wkMsg);
    }
  }
});

// ❌ 错误做法：未更新 url 字段
WKIM.shared.messageManager.addOnUploadAttachmentListener((wkMsg, back) async {
  if (wkMsg.contentType == WkMessageContentType.image) {
    WKImageContent imageContent = wkMsg.messageContent! as WKImageContent;
    
    // 上传图片
    await uploadImage(imageContent.localPath);
    
    // ❌ 错误：忘记更新 url 字段
    // imageContent.url = uploadedUrl;  // 忘记更新
    
    back(true, wkMsg);  // SDK 会发送 url 为空的消息
  }
});
```

#### 12.1.4 错误 4: 连接状态判断错误

**症状**: 在未连接时尝试发送消息，导致消息发送失败。

**原因**: 未检查连接状态就直接发送消息。

**解决方案**:

```dart
// ✅ 正确做法：检查连接状态后再发送
Future<void> sendMessage(String text) async {
  // 检查连接状态
  bool isConnected = IMService().isConnected;
  
  if (!isConnected) {
    // 显示提示
    showToast('网络未连接，请稍后重试');
    return;
  }
  
  // 发送消息
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel('user_456', WKChannelType.personal);
  
  await WKIM.shared.messageManager.sendMessage(textContent, channel);
}

// ❌ 错误做法：未检查连接状态
Future<void> sendMessageWrong(String text) async {
  // ❌ 错误：直接发送，未检查连接状态
  WKTextContent textContent = WKTextContent(text);
  WKChannel channel = WKChannel('user_456', WKChannelType.personal);
  
  await WKIM.shared.messageManager.sendMessage(textContent, channel);
}
```

### 12.2 性能优化

#### 12.2.1 消息列表分页加载

**问题**: 一次性加载所有历史消息会导致内存占用过高。

**解决方案**: 使用分页加载，每次只加载 20-50 条消息。

```dart
class MessageLoader {
  final int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMore = true;

  /// 加载历史消息（分页）
  Future<void> loadMoreMessages(String channelID, int channelType) async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;

    // 获取当前最早的消息序号
    int oldestSeq = await _getOldestMessageSeq(channelID, channelType);

    // 从更早的消息开始加载
    List<WKMsg> messages = await WKIM.shared.messageManager.getHistoryMessages(
      channelID,
      channelType,
      oldestOrderSeq: oldestSeq,
      limit: _pageSize,
      order: WKOrder.asc,
    );

    if (messages.length < _pageSize) {
      _hasMore = false;
    }

    _isLoading = false;

    // 添加到消息列表
    addMessagesToUI(messages);
  }

  Future<int> _getOldestMessageSeq(String channelID, int channelType) async {
    List<WKMsg> messages = await getCurrentMessages();
    if (messages.isEmpty) {
      return 0;
    }
    return messages.first.messageSeq;
  }
}
```

#### 12.2.2 图片压缩

**问题**: 发送大图片会导致流量消耗过大，传输缓慢。

**解决方案**: 在发送前压缩图片。

```dart
import 'package:image/image.dart' as img;

/// 压缩图片
Future<Uint8List> compressImage(File imageFile) async {
  // 读取图片
  final bytes = await imageFile.readAsBytes();
  final image = img.decodeImage(bytes)!;

  // 压缩到最大宽度 1280 像素
  final compressed = img.copyResize(
    image,
    width: image.width > 1280 ? 1280 : null,
    maintainAspect: true,
  );

  // 压缩质量 85%
  final compressedBytes = img.encodeJpg(compressed, quality: 85);

  return Uint8List.fromList(compressedBytes);
}

/// 发送图片消息（带压缩）
Future<void> sendCompressedImage(String imagePath, String channelID) async {
  // 压缩图片
  Uint8List compressedBytes = await compressImage(File(imagePath));

  // 保存压缩后的图片到临时文件
  final tempDir = await getTemporaryDirectory();
  final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await compressedFile.writeAsBytes(compressedBytes);

  // 获取压缩后的尺寸
  var decodedImage = await decodeImageFromList(compressedBytes);

  // 创建图片消息
  WKImageContent imageContent = WKImageContent(
    decodedImage.width,
    decodedImage.height,
  );
  imageContent.localPath = compressedFile.path;

  // 发送
  WKChannel channel = WKChannel(channelID, WKChannelType.personal);
  await WKIM.shared.messageManager.sendMessage(imageContent, channel);
}
```

#### 12.2.3 内存管理

**问题**: 消息列表和图片缓存占用过多内存。

**解决方案**:

1. **限制内存中的消息数量**: 只保留最近 200 条消息。

```dart
class MessageManager {
  final int _maxMessages = 200;
  final List<WKMsg> _messages = [];

  void addMessage(WKMsg msg) {
    _messages.add(msg);

    // 超过最大数量，移除旧消息
    if (_messages.length > _maxMessages) {
      _messages.removeRange(0, _messages.length - _maxMessages);
    }
  }
}
```

2. **使用缓存图片库**: 使用 `cached_network_image` 库缓存图片。

```dart
dependencies:
  cached_network_image: ^3.0.0

// 使用
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 12.3 调试技巧

#### 12.3.1 开启调试模式

```dart
// 在 SDK 初始化时开启调试模式
Options options = Options.newDefault(uid, token);
options.debug = true;  // 开启调试模式

WKIM.shared.setup(options);
```

调试模式下，SDK 会输出详细的日志信息，帮助定位问题。

#### 12.3.2 查看日志

日志信息会在控制台输出，可以通过 `flutter logs` 命令查看。

```bash
# 查看所有日志
flutter logs

# 只查看 WuKongIM SDK 的日志
flutter logs | grep 'WuKongIM'
```

#### 12.3.3 监听连接状态

通过监听连接状态，了解 SDK 的工作状态。

```dart
WKIM.shared.connectionManager.addOnConnectionStatus('debug_key', (status, reason, info) {
  print('连接状态: $status');
  print('失败原因: $reason');
  print('连接信息: $info');
});
```

### 12.4 最佳实践

#### 12.4.1 监听器注册时机

**最佳实践**: 在 SDK 初始化后立即注册所有监听器。

```dart
void initIM() async {
  // 1. 初始化 SDK
  await WKIM.shared.setup(options);

  // 2. 注册所有监听器
  registerAllListeners();

  // 3. 连接 IM
  WKIM.shared.connectionManager.connect();
}
```

#### 12.4.2 资源清理规范

**最佳实践**: 在页面销毁时移除监听器，避免内存泄漏。

```dart
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    // 注册监听器
    _registerListeners();
  }

  @override
  void dispose() {
    // ✅ 最佳实践：移除监听器
    _removeListeners();
    super.dispose();
  }

  void _registerListeners() {
    WKIM.shared.connectionManager.addOnConnectionStatus('chat_key', (status, reason, info) {
      // 处理连接状态
    });

    WKIM.shared.messageManager.addOnNewMsgListener('chat_key', (msg) {
      // 处理新消息
    });
  }

  void _removeListeners() {
    WKIM.shared.connectionManager.removeOnConnectionStatus('chat_key');
    WKIM.shared.messageManager.removeOnNewMsgListener('chat_key');
  }
}
```

#### 12.4.3 错误处理模式

**最佳实践**: 对所有 SDK 调用进行 try-catch 包装，统一处理错误。

```dart
class SafeIMService {
  /// 安全发送消息
  static Future<WKMsg?> safeSendMessage(WKMessageContent content, WKChannel channel) async {
    try {
      WKMsg msg = await WKIM.shared.messageManager.sendMessage(content, channel);
      return msg;
    } catch (e) {
      print('发送消息失败: $e');
      
      // 统一错误处理
      handleError(e);
      
      return null;
    }
  }

  /// 安全查询会话列表
  static Future<List<WKUIConversationMsg>> safeQueryConversationList() async {
    try {
      List<WKUIConversationMsg> conversations = await WKIM.shared.conversationManager.queryConversationList();
      return conversations;
    } catch (e) {
      print('查询会话列表失败: $e');
      handleError(e);
      return [];
    }
  }

  /// 统一错误处理
  static void handleError(dynamic error) {
    // 记录错误日志
    print('IM 错误: $error');

    // 上报错误到监控系统
    reportError(error);

    // 显示用户友好的错误提示
    showErrorToUser(error);
  }

  static void reportError(dynamic error) {
    // TODO: 上报错误到 Sentry/Firebase Crashlytics
  }

  static void showErrorToUser(dynamic error) {
    // TODO: 根据错误类型显示不同的提示
  }
}
```

#### 12.4.4 键名管理

**最佳实践**: 使用有意义的监听器键名，便于管理和移除。

```dart
// ✅ 好的做法：使用有意义的键名
const String _connectionListenerKey = 'home_page_connection';
const String _newMsgListenerKey = 'home_page_new_msg';

// 注册
WKIM.shared.connectionManager.addOnConnectionStatus(_connectionListenerKey, (status, reason, info) {
  // 处理
});

// 移除
WKIM.shared.connectionManager.removeOnConnectionStatus(_connectionListenerKey);

// ❌ 不好的做法：使用无意义的键名
const String _key1 = 'key_1';
const String _key2 = 'key_2';
```

---

**下一章**: [13. 附录](#13-附录) - 完整 API 索引、枚举值速查表、更新日志摘要和相关资源。

## 13. 附录

本章提供完整的 API 索引、枚举值速查表、更新日志摘要和相关资源链接。

### 13.1 完整 API 索引

#### 13.1.1 ConnectManager - 连接管理器

| 方法 | 说明 |
|-----|------|
| `connect()` | 连接 IM 服务器 |
| `disconnect(bool isLogout)` | 断开连接 |
| `addOnConnectionStatus(String key, Function back)` | 监听连接状态 |
| `removeOnConnectionStatus(String key)` | 移除连接状态监听器 |

#### 13.1.2 MessageManager - 消息管理器

| 方法 | 说明 |
|-----|------|
| `sendMessage(WKMessageContent content, WKChannel channel)` | 发送消息 |
| `sendWithOption(WKMessageContent content, WKChannel channel, WKSendOptions options)` | 发送消息（带配置） |
| `getHistoryMessages(...)` | 获取历史消息 |
| `clearUnread(String channelID, int channelType)` | 清除未读数 |
| `addOnNewMsgListener(String key, Function back)` | 监听新消息 |
| `removeOnNewMsgListener(String key)` | 移除新消息监听器 |
| `addOnMsgInsertedListener(Function back)` | 监听消息入库 |
| `addOnRefreshMsgListener(String key, Function back)` | 监听消息刷新 |
| `removeOnRefreshMsgListener(String key)` | 移除消息刷新监听器 |
| `addOnSyncChannelMsgListener(Function back)` | 监听历史消息同步 |
| `addOnUploadAttachmentListener(Function back)` | 监听附件上传 |
| `registerMsgContent(int type, Function factory)` | 注册自定义消息类型 |

#### 13.1.3 ConversationManager - 会话管理器

| 方法 | 说明 |
|-----|------|
| `queryConversationList()` | 查询会话列表 |
| `queryWithChannelID(String channelID, int channelType)` | 查询单个会话 |
| `setTop(String channelID, int channelType, bool isTop)` | 置顶会话 |
| `setMute(String channelID, int channelType, bool isMute)` | 设置免打扰 |
| `deleteConversation(String channelID, int channelType)` | 删除会话 |
| `updateRedDot(String channelID, int channelType, int unread)` | 更新未读数 |
| `getAllUnreadCount()` | 获取总未读数 |
| `addOnRefreshListener(String key, Function back)` | 监听会话列表刷新 |
| `removeOnRefreshListener(String key)` | 移除会话列表刷新监听器 |
| `addOnSyncConversationListener(Function back)` | 监听会话同步 |

#### 13.1.4 ChannelManager - 频道管理器

| 方法 | 说明 |
|-----|------|
| `getChannelInfo(String channelID, int channelType)` | 获取频道信息 |
| `saveOrUpdateChannel(WKChannel channel)` | 保存或更新频道信息 |
| `addOnGetChannelListener(Function back)` | 监听获取频道信息请求 |

#### 13.1.5 CmdManager - 命令管理器

| 方法 | 说明 |
|-----|------|
| `addOnCmdListener(String key, Function back)` | 监听 CMD 消息 |
| `removeOnCmdListener(String key)` | 移除 CMD 消息监听器 |

#### 13.1.6 ReminderManager - 提醒管理器

| 方法 | 说明 |
|-----|------|
| `addReminderListener(Function back)` | 监听 @提醒 |

### 13.2 枚举值速查表

#### 13.2.1 WKChannelType - 频道类型

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKChannelType.personal` | 1 | 个人频道 |
| `WKChannelType.group` | 2 | 群组频道 |

#### 13.2.2 WkMessageContentType - 消息内容类型

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WkMessageContentType.text` | 1 | 文本消息 |
| `WkMessageContentType.image` | 2 | 图片消息 |
| `WkMessageContentType.voice` | 4 | 语音消息 |
| `WkMessageContentType.video` | 5 | 视频消息 |
| `WkMessageContentType.insideMsg` | 99 | 内部消息 |

**自定义消息类型**: 100 及以上

#### 13.2.3 WKConnectStatus - 连接状态

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKConnectStatus.fail` | 0 | 连接失败 |
| `WKConnectStatus.success` | 1 | 连接成功 |
| `WKConnectStatus.kicked` | 2 | 被踢下线 |
| `WKConnectStatus.syncMsg` | 3 | 同步消息中 |
| `WKConnectStatus.connecting` | 4 | 正在连接 |
| `WKConnectStatus.noNetwork` | 5 | 无网络 |
| `WKConnectStatus.syncCompleted` | 6 | 同步完成 |

#### 13.2.4 WKSendMsgResult - 发送消息结果

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKSendMsgResult.sendLoading` | 0 | 发送中 |
| `WKSendMsgResult.sendSuccess` | 1 | 发送成功 |
| `WKSendMsgResult.sendFail` | 2 | 发送失败 |

#### 13.2.5 WKOrder - 排序方向

| 常量名 | 值 | 说明 |
|---------|-----|------|
| `WKOrder.asc` | 0 | 升序（从小到大） |
| `WKOrder.desc` | 1 | 降序（从大到小） |

### 13.3 更新日志摘要

最新版本更新内容（请查看完整的 [CHANGELOG.md](https://github.com/WuKongIM/WuKongIMFlutterSDK/blob/master/CHANGELOG.md)）：

- 支持自定义消息类型
- 优化连接稳定性
- 新增 @提醒功能
- 支持消息回执
- 支持阅后即焚消息
- 性能优化：减少内存占用

### 13.4 相关资源

| 资源名称 | 链接 | 说明 |
|---------|------|------|
| GitHub 仓库 | https://github.com/WuKongIM/WuKongIMFlutterSDK | SDK 源码、问题反馈 |
| 官方文档 | https://github.com/WuKongIM/WuKongIMDocs | 详细文档、API 参考 |
| 示例项目 | https://github.com/WuKongIM/WuKongIMFlutterSDK/tree/master/example | 完整示例代码 |
| WuKongIM Server | https://github.com/WuKongIM/WuKongIMServer | 后端服务器源码 |
| Pub.dev | https://pub.dev/packages/wukongimfluttersdk | Dart 包发布页面 |

### 13.5 版本信息

| 项目 | 版本 |
|-----|------|
| Flutter SDK | >= 3.0.0 |
| Dart SDK | >= 2.17.0 |
| iOS | >= 12.0 |
| Android | >= 5.0 (API 21) |

---

## 文档结束

恭喜！您已经完成了 WuKongIM Flutter SDK 的完整学习。现在您可以：

1. ✅ 集成 SDK 到 Flutter 项目
2. ✅ 实现消息收发功能
3. ✅ 管理会话列表
4. ✅ 处理进阶功能
5. ✅ 使用最佳实践优化性能

如有任何问题，欢迎访问 [GitHub Issues](https://github.com/WuKongIM/WuKongIMFlutterSDK/issues) 提问。

**祝您开发顺利！**
