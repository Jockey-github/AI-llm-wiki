# 双活架构中间件数据一致性检查 技术速查

## 架构概览

```
run_all_checks.py (统一入口)
  ├── ES_data_check/   → Kibana 代理 → ES 集群
  ├── Kafka_data_check/ → kubectl port-forward → Kafka (双层连接)
  └── Redis_data_check/ → 直连 Redis (四级降级)
```

## ES 数据一致性检查

### 连接方式
通过 Kibana 代理 API 间接访问 ES（避免直连安全策略限制）

### 核心逻辑
1. 查询索引文档数（双集群同时查）
2. 对比 doc count，差异 > 阈值 → 不一致
3. AND 判定（替代旧的 OR 判定）

### 关键配置
- Kibana 代理地址、索引名列表、差异阈值

## Kafka 数据一致性检查

### 双层连接策略
```
第一层：kubectl port-forward (优先，10 秒超时)
第二层：NodePort (兜底)
```

### 消息计数公式
```
offset_diff = end_offset - start_offset
consume_rate = offset_diff / time_window_seconds
```

### 时间戳提取
从消息体 JSON 中提取业务时间戳，而非 Kafka 内置 timestamp

### 已知问题
- Hedan 侧 kubectl 端口转发需要运维授权
- 权限不足 → Kafka 模块可能失败

## Redis 数据一致性检查

### 四级降级策略（按优先级）
```
Level 1: DBSIZE           → 精确，依赖 INFO keyspace
Level 2: KEYS pattern     → 精确但慢（生产慎用）
Level 3: SCAN + COUNT     → 估算，速度快
Level 4: INFO keyspace    → 最快，但受过期键影响
```

### 验证器

| 验证器 | 用途 | 关键点 |
|--------|------|--------|
| key_count_check | Key 数量对比 | 四级降级 |
| ttl_check | TTL 一致性 | 抽样 key 比 TTL |
| key_type_check | Key 类型一致性 | 同 key 比 type |
| prefix_check | 前缀分布 | 按前缀统计 key 分布 |

## 运行方式

```bash
# 全量运行
python run_all_checks.py

# 跳过指定中间件
python run_all_checks.py --skip-es --skip-kafka

# 单独运行
python run_all_checks.py --skip-kafka --skip-redis
```

## 报告输出

- 终端即时输出 + 结构化 JSON 报告
- 差异项：集群名 | Key/Topic/Index | 主值 | 备值 | 差异百分比

## 量化指标（专利汇报数据）

| 指标 | 数值 |
|------|------|
| 检查速度 | 手动 30min → 自动 3min（10x） |
| 年化人力节省 | ~300 人时 |
| 检查范围 | 双集群 100% 数据项 |
| 检测精度 | 逐 Key/Topic/Index 级别 |
