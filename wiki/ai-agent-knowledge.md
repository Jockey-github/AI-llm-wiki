---
title: AI Agent 架构知识
category: 技术
created: 2026-06-24
updated: 2026-06-24
sources: [raw/articles/ai-agent-architecture.md, raw/articles/mcp-server-middleware-healthcheck.md]
---

# AI Agent 架构知识

## 一句话总结

**LLM 是大脑（想），Tools 是手脚（做），MCP 是工具的标准接口（连），Skill 是经验手册（知）。Agent 就是把这四者串成一个自主决策循环。**

## 四大组件

| 组件 | 角色 | 类比 |
|------|------|------|
| LLM | 推理、规划、决策 | 大脑 |
| Tools | 执行具体操作 | 手脚 |
| MCP Server | 标准化的工具提供协议 | USB 接口标准 |
| Skill | 打包好的领域知识 | 经验手册 |

**关键区分**：Skill 是"知道怎么做"，Tool 是"能做到"。两者缺一不可。

## Agent 三种实现模式

| 模式 | LLM 自主性 | 适用场景 |
|------|-----------|---------|
| 单次调用 | 无循环 | 分类、摘要、提取 |
| 工作流（Workflow） | 代码控制调用顺序 | 固定流程的多步任务 |
| 自主 Agent | LLM 自己决定调什么、几次 | 开放式、探索性任务 |

Claude Code 本身就是自主 Agent——给它任务，它自己决定读哪些文件、改哪些代码、跑什么命令。

## MCP Server 实战经验

基于中间件健康检查工具的改造实践：

### 工具设计原则
1. 一个工具只做一件事（职责分离）
2. 参数有默认值（减少调用负担）
3. 返回类型明确（小数据 dict，大数据 str）
4. docstring 第一句话就是 tool description

### 踩坑记录
- MCP Python SDK 的 API 变化频繁，注意版本
- 常驻 Server 要考虑配置热加载
- 外部接口超时要有降级策略（10s 超时 + "超时跳过"）
- Nacos GET 请求可能重定向循环，需 `allow_redirects=False`

## 我的 Agent 生态

| 项目 | 类型 | 状态 |
|------|------|------|
| Claude Code + Skills | 自主 Agent + 知识包 | 主力使用中 |
| 中间件巡检 MCP Server | MCP Server（CLI+MCP 双模） | 开发中 |
| TES 报销自动化 | Skill + Playwright 工具 | 调试中 |
| 每日邮件推送 | Skill + Python 脚本 | 运行中 |
| learn-claude-code | 学习项目（拆解 Harness） | 学习中 |
| claw0 | 学习项目（从零构建 Agent 网关） | 学习中 |

## 相关页面

- [[tech-stack]] — AI 工具链
- [[learning]] — Agent 学习路径
- [[projects]] — Agent 相关项目
- [[ai-testing-patterns]] — AI 辅助测试
