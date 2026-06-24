---
title: 自动化实战经验
category: 技术
created: 2026-06-24
updated: 2026-06-24
sources: [raw/articles/tes-playwright-automation-tips.md, raw/articles/data-consistency-check-architecture.md]
---

# 自动化实战经验

## Playwright + Ant Design 踩坑集

基于 TES 报销系统自动化实战，6 个核心坑：

| 问题 | 根因 | 解法 |
|------|------|------|
| 元素 click() 无效 | Ant Design 事件代理/冒泡 | 坐标点击 `mouse.click(x, y)` |
| JS set 值无效 | React 受控组件 | 必须 UI 交互（fill + Enter） |
| 元素定位失败 | 组件挂载到非标准容器 | 检查真实 DOM 结构再定位 |
| 多个同名按钮 | 页面多层级弹窗 | 加坐标过滤（如 x > 800） |
| 下拉选项定位不到 | 不在 body 层级 | `.searcher-list-item` 精确匹配 |
| 新标签页捕获不稳定 | expect_page 时机问题 | `context.pages[-1]` 轮询 |

## 数据一致性检查架构

三中间件自动检查方案，手动 30min 降到自动 3min（10x 提速）：

- **ES**：通过 Kibana 代理，对比双集群 doc count
- **Kafka**：双层连接（kubectl port-forward 优先 + NodePort 兜底）
- **Redis**：四级降级（DBSIZE > KEYS > SCAN > INFO keyspace）

详见：`raw/articles/data-consistency-check-architecture.md`

## 相关页面

- [[projects]] — TES 报销自动化、数据一致性检查
- [[ai-testing-patterns]] — AI 辅助测试
- [[lessons]] — 踩坑记录
