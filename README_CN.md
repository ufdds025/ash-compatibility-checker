# ASH 兼容性检查器

[English](README.md) | 中文

## 概述

ASH 兼容性检查器是一个强大的工具，用于检查和验证应用程序与 ASH（Application State History）框架的兼容性。该工具帮助开发者确保他们的应用程序能够正确地与 ASH 框架集成和协作。

## 主要功能

- **兼容性检测**：自动检测应用程序与 ASH 框架的兼容性
- **详细报告**：生成详细的兼容性分析报告
- **快速诊断**：快速识别和诊断兼容性问题
- **建议提示**：提供解决兼容性问题的建议
- **多版本支持**：支持检查多个 ASH 框架版本的兼容性

## 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/ufdds025/ash-compatibility-checker.git
cd ash-compatibility-checker

# 安装依赖
npm install
```

### 基本使用

```bash
# 检查当前项目的兼容性
npm run check

# 指定特定目录
npm run check -- --path ./src

# 生成详细报告
npm run check -- --report detailed
```

## 配置

### 配置文件

在项目根目录创建 `ash-config.json` 文件：

```json
{
  "targetFramework": "ash@latest",
  "checkLevel": "strict",
  "includePatterns": ["src/**/*.js", "lib/**/*.js"],
  "excludePatterns": ["node_modules/**", "dist/**"],
  "reportFormat": "json"
}
```

### 配置选项说明

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `targetFramework` | 目标 ASH 框架版本 | `latest` |
| `checkLevel` | 检查严格程度（loose/normal/strict） | `normal` |
| `includePatterns` | 包含的文件模式 | `["src/**/*.js"]` |
| `excludePatterns` | 排除的文件模式 | `["node_modules/**"]` |
| `reportFormat` | 报告格式（json/html/text） | `json` |

## 命令行选项

```bash
# 显示帮助信息
npm run check -- --help

# 检查特定版本的兼容性
npm run check -- --version 1.2.0

# 修复自动可修复的问题
npm run check -- --fix

# 输出详细日志
npm run check -- --verbose

# 设置退出代码
npm run check -- --strict
```

## 输出报告

检查完成后，工具会生成包含以下信息的报告：

### 兼容性概览
- 总体兼容性分数
- 检查的文件数量
- 发现的问题数量

### 详细问题列表
- 问题类型
- 严重程度（Info/Warning/Error）
- 文件位置和行号
- 问题描述
- 解决建议

### 示例报告

```json
{
  "summary": {
    "compatible": true,
    "score": 95,
    "filesChecked": 42,
    "issuesFound": 3
  },
  "issues": [
    {
      "type": "deprecatedAPI",
      "severity": "warning",
      "file": "src/components/App.js",
      "line": 25,
      "message": "使用了已弃用的 API: setStateAsync",
      "suggestion": "请使用 setState 替代"
    }
  ]
}
```

## 常见问题

### Q: 如何解决兼容性问题？

A: 
1. 查看详细报告中的建议
2. 根据建议更新代码
3. 重新运行检查验证修复

### Q: 支持哪些 ASH 框架版本？

A: 工具支持 ASH 1.0 及以上所有版本。使用 `--version` 选项指定特定版本。

### Q: 能否自动修复问题？

A: 某些问题可以自动修复。使用 `--fix` 选项启用自动修复功能。

### Q: 如何排除特定文件？

A: 在配置文件中使用 `excludePatterns` 或命令行选项 `--exclude` 指定排除的文件模式。

## 高级用法

### 集成到 CI/CD 流程

```yaml
# GitHub Actions 示例
name: ASH Compatibility Check
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: npm install
      - run: npm run check -- --strict
```

### 自定义检查规则

创建 `.ash-rules.js` 文件定义自定义规则：

```javascript
module.exports = {
  rules: {
    customRule: {
      check: (node) => {
        // 自定义检查逻辑
        return true;
      },
      message: '自定义规则提示信息'
    }
  }
};
```

## API 参考

### JavaScript API

```javascript
const AshChecker = require('ash-compatibility-checker');

const checker = new AshChecker({
  targetFramework: 'ash@2.0.0',
  checkLevel: 'strict'
});

const result = await checker.check('./src');
console.log(result);
```

## 贡献指南

我们欢迎贡献！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 获取帮助

- **问题报告**：在 [GitHub Issues](https://github.com/ufdds025/ash-compatibility-checker/issues) 中报告问题
- **讨论区**：在 [GitHub Discussions](https://github.com/ufdds025/ash-compatibility-checker/discussions) 中提出问题
- **文档**：查看 [完整文档](./docs/README_CN.md)

## 相关链接

- [ASH 官方文档](https://ash-framework.dev)
- [项目主页](https://github.com/ufdds025/ash-compatibility-checker)
- [变更日志](CHANGELOG_CN.md)

## 更新日志

### v1.0.0 (2025-12-30)
- 初始版本发布
- 支持 ASH 框架兼容性检查
- 提供详细的报告和建议

---

**最后更新**：2025-12-30

如有任何问题或建议，欢迎联系我们！