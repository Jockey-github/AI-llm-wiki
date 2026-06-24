# Wiki Log

> 操作日志，按时间倒序记录。每条格式：`## [日期] 操作类型 | 说明`

## [2026-06-24] init | 知识库初始化

- 创建目录结构：raw/（articles, notes, assets）、wiki/
- 创建 CLAUDE.md schema 文件
- 创建 index.md 索引
- 创建初始 wiki 页面：me.md, work.md, tech-stack.md, projects.md, preferences.md, goals.md, decisions.md, lessons.md, learning.md, health.md, interests.md
- 初始内容来源：Claude Code Memory 中已有的用户信息 + 日常对话积累
- 待补充：大量页面仅有框架，需要用户提供更多素材来丰富

## [2026-06-24] ingest | 合并旧知识库 D:\AI\knowledge-base

- 来源：D:\AI\knowledge-base（10 篇 md + 2 个资源文件）
- 操作：
  - 10 篇 md 文件 → raw/articles/（原始素材保留不动）
  - 2 个非 md 文件（xmind, svg）→ raw/assets/
  - 新建 wiki 综合页面 3 个：ai-agent-knowledge.md、ai-testing-patterns.md、automation-tips.md
  - 更新 index.md 索引（新增原始素材索引段落）
- 旧知识库分类映射：
  - cases/ → 融入 ai-testing-patterns.md + automation-tips.md + lessons.md
  - cheatsheets/ → 融入 ai-agent-knowledge.md + automation-tips.md
  - prompt-patterns/ → 融入 ai-testing-patterns.md
  - workflows/ → 融入 ai-testing-patterns.md
- 旧知识库保留原样未删除，用户可自行决定是否清理
