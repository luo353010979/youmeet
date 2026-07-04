# 文档驱动开发（Spec-Driven Development）

这套目录把"需求 → 实现 → 验证"沉淀成文件，取代纯聊天甩需求。
和 AI 协作时，**文档是唯一事实来源**，聊天只用于微调。

## 目录职责

| 目录 | 放什么 | 谁写 |
|------|--------|------|
| `docs/prd/` | PRD：这个功能"要什么"（目标、用户故事、规则） | **你**（可让 AI 协助起草） |
| `todos/` | 实现任务清单（带勾选） | AI（你跟踪进度） |
| `questions/` | AI 发现的歧义/待确认问题 | AI 写，**你回答** |
| `docs/task-log.md` | 任务批次日志（第几次任务 / #NNN） | AI |

> 同一功能用同一个名字（slug）贯穿三处，例如 `login-register`：
> `docs/prd/login-register.md`、`todos/login-register.todo.md`、`questions/login-register.q.md`

## 标准流程

```
1. 你写 docs/prd/<功能>.md           （要什么）
2. 让 AI：读 PRD → 拆 todo + 把歧义写进 questions
3. 你回答 questions/<功能>.q.md 里的问题
4. AI 按 todo 实现
5. AI 在聊天里用 md 总结改了哪些、怎么验
6. 你亲自在设备上验收
```

## 怎么用一句话启动

> "按 AGENTS.md 的工作流，实现 docs/prd/login-register.md 这个需求。"

AI 会自动读 PRD、拆 todo、把不确定的地方写进 questions 问你，而不是闷头乱做。

## 模板

`prd / todos / questions` 各有 `_template.md`，新建功能时复制改名即可。`login-register` 是一个已填好的真实示例（基于现有登录页代码），可直接参考。
