---
title: AI 辅助测试方法论
category: 技术
created: 2026-06-24
updated: 2026-06-24
sources: [raw/articles/ai-test-generation-patterns.md, raw/articles/zero-shot-vs-few-shot-test-cases.md, raw/articles/multi-round-decomposition-test-plan.md, raw/articles/ai-test-report-template.md]
---

# AI 辅助测试方法论

## 核心方法：三级 Prompt 策略

根据需求复杂度选择不同策略：

| 复杂度 | 策略 | 耗时 | 适用场景 |
|--------|------|------|---------|
| 简单 | Zero-shot | 5min | 需求明确、功能单一 |
| 中等 | Few-shot 结构化 | 10min | 正规项目、需要特定风格 |
| 复杂 | 多轮拆解法 | 30-60min | 跨系统、多子系统、大型需求 |

## Zero-shot vs Few-shot 实测结论

基于美团套餐可选组同步需求的对比实验：

- **Zero-shot**：10 条用例，单一维度，预期结果模糊，需大量补充
- **Few-shot 结构化**：20 条用例，4 维度分组，具体可验证，基本可直接用

**核心差异**：Few-shot 的本质不是"给例子"，而是帮 AI 建立正确的心智模型。提供"当前现状 + 具体示例 + 期望效果"比单纯描述需求有效 10 倍。

## 多轮拆解法（复杂需求杀手锏）

三轮流程：

### 第 1 轮：理清范围（5-10min）
- 给 AI 背景材料，让它输出理解而非方案
- **关键**：第 1 轮的价值不是产出，是对齐。纠偏成本远低于返工成本

### 第 2 轮：设计框架（5-10min）
- 只到二级标题，不填细节
- **关键**：框架是最便宜的纠偏窗口。结构错了，细节再好也白搭

### 第 3 轮：填充内容（20-40min）
- 前两轮确认结论作为约束，按模块分段输出
- **关键**：产出后必须审查。AI 不知道你"默认知道"的隐性知识

## AI 辅助测试报告

三步迭代法：骨架确认(2min) → 初稿生成(3-5min) → 迭代润色(5min)

效率对比：手写 ~2h → AI 辅助 ~10min

**注意**：AI 生成的数据统计需人工核对，风险等级和结论判定需人工确认。

## Bug 调试三要素法

```
【现象】精确描述看到了什么（日志/报错/行为）
【上下文】环境版本 + 触发条件 + 时间点
【假设】怀疑哪里有问题（不确定就说不确定）
```

## 可复用模板

详见原始素材：
- `raw/articles/ai-test-generation-patterns.md` — 完整 Prompt 模板集
- `raw/articles/multi-round-decomposition-test-plan.md` — 多轮拆解完整模板
- `raw/articles/ai-test-report-template.md` — 报告生成工作流

## 相关页面

- [[lessons]] — 实战踩坑
- [[ai-agent-knowledge]] — Agent 架构理解
- [[work]] — 工作场景
- [[tech-stack]] — 测试工具链
