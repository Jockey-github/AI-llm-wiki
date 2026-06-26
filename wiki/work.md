---
title: 工作
category: 工作
created: 2026-06-24
updated: 2026-06-26
sources: [Claude Code Memory, delta-coreserv 代码分析, 用户提供]
---

# 工作

## 当前职位

- 角色：中台系统测试整体负责人（无正式 title）
- 公司：麦当劳中国（McDonald's China）
- 汇报对象：Leader Danny
- 管辖范围：中台 8 个系统的整体测试管理工作

## 主要职责

### 核心职责（中台统筹）

- 统筹管理中台 8 个系统（Order / Payment / CRM / Promotion / PCM / Menu / Suggestion / Campaign）的测试工作
- 协调各系统测试负责人的工作安排和资源分配
- 跨系统质量风险识别和管控
- 向 Leader Danny 汇报中台整体工作情况

### 历史职责（渠道系统，逐步交接中）

- 渠道系统（delta）的质量保障 — **后续可能逐步不再参与**
- 涉及美团、饿了么、京东等外卖渠道的对接测试
- 门店商品可售/售罄状态管理相关测试
- 菜单同步、库存同步等核心流程的验证

## 汇报关系

```
Danny (Leader)
  └── 我（中台测试整体负责人）
        ├── 陈家林 / 陈文宇 / 史维强（Order）
        ├── 郑慧（Payment）
        ├── 郭瑞娜（CRM）
        ├── 徐勇 / 修学文（Promotion）
        ├── 朱珂（PCM）
        ├── 崔淑华（Menu）
        ├── 赖婷婷（Suggestion）
        └── 孔亮 / 徐佩颖（Campaign）
```

## 日常协调机制

| 机制 | 频率 | 说明 |
|------|------|------|
| 中台周会 | 每周四下午 | 我组织，8 系统测试负责人参加 |
| 向 Danny 汇报 | 每周五上午 | 中台整体工作情况同步 |

## 日常接触的系统

- **中台 8 系统**：详见 [[platform-systems]]
- **delta-coreserv**：渠道核心服务（历史，逐步交接）
  - Git 仓库：gitlab-ex.mcd.com.cn
  - 涉及表：t_product_inv_out（商品售罄）、t_store_not_sale_product_doc（门店不可售商品）等
  - 技术栈：Java / Spring Boot / MyBatis-Plus / Kafka / ES / Redis / Nacos

## 工作模式

- 使用 sit 环境进行测试验证
- 经常需要分析代码逻辑来理解业务行为
- 会主动用 AI 工具辅助代码分析、用例生成、自动化脚本编写
- 统筹角色下更多关注全局视图、风险管控、资源协调

## 待补充

- [ ] 团队规模和结构（总人数）
- [ ] 上下游协作团队（产品、研发 Leader）
- [ ] KPI / OKR
- [ ] Delta 交接时间线

## 相关页面

- [[me]] — 个人信息
- [[platform-systems]] — 中台 8 系统全景图
- [[projects]] — 项目清单
- [[tech-stack]] — 技术栈
