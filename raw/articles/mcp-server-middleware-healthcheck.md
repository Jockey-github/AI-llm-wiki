# MCP Server 实战：中间件健康检查工具改造

## 背景

将一个 CLI-only 的中间件健康检查工具改造成 MCP Server，让 AI 助手能直接调用巡检能力。

## 改造架构

```
原架构：CLI → checker_*.py → report
改造后：CLI + MCP 双模式
  ├── CLI 模式：python main.py run --middleware redis
  └── MCP 模式：python mcp_server.py (注册 4 个工具)
```

## MCP 工具注册

### 工具清单

```python
# mcp_server.py
from mcp.server import Server

server = Server("middleware-healthcheck")

@server.tool("run_healthcheck")
def run_healthcheck(middleware: str, env: str = "prod") -> dict:
    """执行指定中间件健康检查"""
    ...

@server.tool("check_middleware")
def check_middleware(middleware: str, check_type: str) -> dict:
    """执行特定检查项"""
    ...

@server.tool("generate_report")
def generate_report(env: str = "all") -> str:
    """生成格式化巡检报告"""
    ...

@server.tool("list_config")
def list_config() -> dict:
    """列出当前监控配置"""
    ...
```

### 工具设计原则

1. **一个工具只做一件事** — `run_healthcheck` vs `generate_report` 职责分离
2. **参数有默认值** — `env="prod"` 减少调用负担
3. **返回类型明确** — 小数据用 dict，大数据用 str（JSON 文本）
4. **描述即文档** — docstring 的第一句话就是 tool description

## 中间件检查器清单

| 检查器 | 检查内容 | 备注 |
|--------|---------|------|
| ES | 集群状态、节点数、索引状态 | Kibana 代理 |
| Kafka | Topic 状态、Consumer Group Lag | JMX 指标 |
| MySQL | 连接数、慢查询、主从延迟 | SHOW STATUS |
| Nacos | 服务注册数、配置一致性 | /nacos API |
| Redis | 内存使用、Key 数量、连接数 | INFO 命令 |
| Sentinel | 规则数、限流命中率 | Sentinel API |
| XXL-Job | 任务执行状态、失败重试 | Job log 接口 |

## 关键踩坑

### 1. MCP 协议版本
- 用 `mcp` Python SDK，注意 `Server` 和 `Tool` 的 API 变化
- 工具注册用装饰器 `@server.tool()`，不用手动 `list_tools()`

### 2. 配置热加载
- CLI 模式每次读 `config.yaml`
- MCP 模式下 Server 常驻，`list_config` 工具实际读当前配置

### 3. 超时处理
- XXL-Job 的 `joblog/pageList` 接口在 putuo 环境超时 30s+
- 设置 10s 超时 + 降级返回"超时跳过"

### 4. 重定向循环
- Nacos 某些 GET 请求在特定环境出现重定向循环
- 用 `allow_redirects=False` 或设置 max_redirects

## 下一步

- [ ] 增量巡检（只查变化的）
- [ ] 历史趋势存储（SQLite）
- [ ] 定时巡检 + 邮件推送集成
