# AI 辅助调试实战：Kafka 消费开关启动时序竞争

## 场景

服务在 putuo 侧集群启动时，Nacos 中 Kafka 消费开关配置为关闭（`"ordermtserv_putuo": true`），但启动瞬间仍会消费到少量数据，随后才停止消费。

## 提供给 AI 的信息（3 类）

| 类型 | 内容 |
|------|------|
| 现象描述 | 启动时短暂消费，随后停止；配置应为关闭状态 |
| 代码上下文 | 指明了服务名、集群名、Nacos 配置 key |
| 已有假设 | "是不是刚启动时没加载好 Nacos 开关状态" |

## AI 定位过程

1. 拉取最新代码，grep 关键词 `ordermtserv_putuo`、`consumer.*switch`、`pause/resume`
2. 定位到 3 个核心类：`McdKafkaListenerEndpointRegistry`、`ForbidSelfRequestSwitch`、`SelfRequestSwitchListener`
3. 分析 `isAutoStartup()` 调用时序与 Nacos 异步加载的竞争关系
4. 锁定根因：`ForbidSelfRequestSwitch.isDegrade()` 在 config 为空时默认返回 `false`（不降级 = 允许消费）

## 根因

```java
// ForbidSelfRequestSwitch.java:34-38
public boolean isDegrade(String currentCluster) {
    if (MapUtils.isEmpty(config)) {
        return false;  // ← 配置未加载时默认"不降级"，导致消费者启动
    }
    return config.getOrDefault(currentCluster, false);
}
```

**时序：** Spring Lifecycle 调用 `isAutoStartup()` → config 为 null → `isDegrade()` 返回 false → `isAutoStartup()` 返回 true → 消费者启动 → Nacos 加载完成 → `SelfRequestSwitchListener` 触发 stop

## 修复方案

- 方案 A：`isDegrade()` 默认返回 `true`（fail-safe，1 行改动）
- 方案 B：启用已注释的 `KafkaConsumerStartupListener` + `setAutoStartup(false)`（延迟启动）
- 方案 C：A + B 双保险

## 经验总结

| 维度 | 总结 |
|------|------|
| AI 准确率 | 一轮分析直接命中根因，无需反复 |
| AI 擅长 | 跨多文件的时序分析、Spring 生命周期机制推理 |
| 人的价值 | 提供精准的现象描述和初始假设方向，大幅缩小搜索范围 |
| 调试模式 | 现象 + 上下文 + 假设 → AI 验证/推翻假设 → 定位根因 |

## 适用场景

- 配置中心（Nacos/Apollo）与框架生命周期的竞争问题
- Spring Bean 初始化顺序导致的 NPE 或默认值问题
- 任何"启动时短暂异常，随后恢复正常"的现象
