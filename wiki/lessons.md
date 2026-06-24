---
title: 经验教训
category: 经验
created: 2026-06-24
updated: 2026-06-24
sources: [日常对话]
---

# 经验教训

> 踩坑记录、复盘总结。格式：日期 + 场景 + 教训 + 行动建议

## 技术踩坑

### [2026-06-23] del_flag 字段语义不一致的陷阱

- **场景**：分析 delta-coreserv 中 t_product_inv_out 和 t_store_not_sale_product_doc 两张表
- **教训**：同一个项目里，同名字段（del_flag）在不同表中语义可能完全不同。t_product_inv_out 中 del_flag=0 表示商品售罄（记录有效），=1 表示恢复供应（记录逻辑删除）；但同一个服务中 syncInv 方法的赋值逻辑与 realTimeNotify 方法矛盾
- **行动**：测试涉及逻辑删除字段时，必须逐个方法确认赋值逻辑，不能想当然

## 工作协作

（待补充）

## AI 使用经验

### [2026-ojects]] — 项目踩坑
- [[decisions]] — 决策反思
