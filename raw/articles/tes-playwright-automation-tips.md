# TES 报销平台 Playwright 自动化实战

## 背景

使用 Playwright 对内部 TES 报销系统做 UI 自动化，踩了不少 Ant Design + 定制组件的坑。

## 核心经验

### 1. 发票识别确认按钮

**坑**：确认按钮不在标准的 `.ant-modal-footer` 里。

**解决**：按钮在 `div.slide-footer` 内，用自定义容器定位。

```python
# 错误
page.locator(".ant-modal-footer button").click()

# 正确
page.locator("div.slide-footer button").click()
```

### 2. 加班类型选择器

**坑**：组件是 `ant-modal list-searcher`，下拉选项不在 body 层级。

**解决**：选项在 `.searcher-list-item` 中，需要先展开选择器再定位。

```python
# 展开选择器
page.locator(".ant-modal .list-searcher input").click()
# 选择选项
page.locator(".searcher-list-item").filter(has_text="加班").click()
```

### 3. OCR 发票上传按钮

**坑**：`div.ocr-upload-button` 的 click() 不生效（Ant Design 的 upload 组件事件冒泡问题）。

**解决**：用坐标点击（`click({position: {x, y}})`）代替元素点击。

```python
upload_btn = page.locator("div.ocr-upload-button")
box = upload_btn.bounding_box()
page.mouse.click(box["x"] + box["width"]/2, box["y"] + box["height"]/2)
```

### 4. 保存按钮定位

**坑**：页面底部有多个"保存"按钮（报销单底部 + 费用详情底部），`locator("保存")` 会匹配到第一个。

**解决**：通过 x 坐标 > 800 过滤，区分主页面按钮和弹窗按钮。

```python
# 弹窗内的保存按钮（通常在右侧，x > 800）
save_btn = page.locator("button").filter(has_text="保存")
# 遍历找到 x > 800 的那个
buttons = save_btn.all()
for btn in buttons:
    if btn.bounding_box()["x"] > 800:
        btn.click()
        break
```

### 5. Ant Design Calendar 日期输入

**坑**：用 JS 直接 set value 无效，Ant Design Calendar 组件必须通过 UI 交互触发。

**解决**：定位 `.ant-calendar-input`，fill() + 回车。

```python
# 错误
page.evaluate("document.querySelector('.ant-calendar-input').value = '2026-01-15'")

# 正确
input_el = page.locator(".ant-calendar-input")
input_el.fill("2026-01-15")
input_el.press("Enter")
```

### 6. BOSS 登录新标签页处理

**坑**：登录跳转开新标签页，`context.expect_page()` 有时捕获不到。

**解决**：用 `page.locator("#tes")` 选择器 + 新标签页轮询，比 expect_page 更稳定。

```python
# 点击登录
page.click("登录按钮")

# 等待新标签页
page.wait_for_timeout(2000)
new_page = context.pages[-1]  # 获取最新的页面
new_page.wait_for_load_state("networkidle")
```

## 通用教训

| 问题 | 根因 | 对策 |
|------|------|------|
| 元素点击无效 | Ant Design 事件代理 | 改用坐标点击 |
| JS set 值无效 | React 受控组件 | 必须 UI 交互 |
| 元素定位失败 | 组件挂载到 body 外 | 检查 DOM 结构再定位 |
| 多个同名按钮 | 页面多层级 | 加坐标/层级约束 |

## 配置

- Playwright + Python
- 浏览器：Chromium (headless=false 调试)
- 核心依赖：`playwright`, `pytest-playwright`
