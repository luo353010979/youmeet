# 登录注册 PRD（示例）

- **slug**: login-register
- **状态**: 草稿（示例，待你按真实需求修改）
- **更新日期**: 2026-06-29

> 这是基于现有代码 `lib/pages/system/login/` 反推 + 补充的示例 PRD，
> 用来演示文档驱动流程。请按你的真实需求增删。

## 1. 目标
用户用手机号 + 密码登录 youmeet；新用户可进入注册流程。

## 2. 用户故事
- 作为用户，我输入手机号和密码，勾选协议，点"登录"，进入主页（`systemMain`）
- 作为新用户，我点"注册"，进入注册流程（`systemRegisterRegisterIndex`）
- 作为用户，登录失败时我能看到明确的错误提示

## 3. 页面 / 入口
- 登录页：`lib/pages/system/login/`，路由 `RouteNames.systemLogin`
- 进入：启动页 `systemSplash` 判断未登录后跳入
- 成功后：`Get.offAllNamed(RouteNames.systemMain)`

## 4. 业务规则
- 必须勾选《用户协议》《隐私政策》才能登录
- 手机号、密码非空才允许提交
- 登录成功保存 token / 用户信息（`UserService`）

## 5. 接口
| 用途 | 方法 | 路径 |
|------|------|------|
| 登录 | POST | `/jeecg-boot/api/txs/login` |
| 注册 | POST | `/jeecg-boot/api/txs/registered` |

## 6. 验收要点（用户视角）
- 正确账号密码 → 进入主页
- 错误密码 → 提示错误，停留登录页
- 未勾选协议 → 无法登录并有提示

## 7. 不确定 / 待定
- 是否支持验证码登录？
- 密码强度规则？
（更多歧义见 `questions/login-register.q.md`）
