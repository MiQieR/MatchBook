# 姻缘册 (MatchBook)

> 🚩 **Project Status: Archived**  
> 本项目最初为解决友人特定需求及 Flutter 练手而作。因已有成熟替代方案，现正式停止维护。

<div align="center">

<img src="img/app.png" width="200"/>

一个专业的红娘客户管理系统，基于 Flutter 开发，帮助红娘高效管理和查询客户信息。

[![English Docs](https://img.shields.io/badge/docs-English-blue.svg)](README_EN.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)](https://dart.dev)
[![Version](https://img.shields.io/badge/Version-1.1.1-green.svg)](https://github.com/MiQieR/MatchBook)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)](https://flutter.dev)
[![Database](https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite)](https://www.sqlite.org)
[![State Management](https://img.shields.io/badge/State-Provider-orange)](https://pub.dev/packages/provider)

</div>

## 📱 功能特性

### 核心功能

- **客户信息录入**
  - 支持手动输入 17 个客户字段
  - 🎯 一键识别功能：智能解析非结构化文本，自动填充表单
  - 安全的剪贴板粘贴（处理微信富文本）
  - 输入验证和警告提示（红色=错误，橙色=警告）
  - 响应式布局（竖屏/横屏自适应）

- **高级搜索**
  - 统一关键词搜索栏
  - 高级筛选面板（可展开/收起）
  - 双重搜索模式：
    - 模糊搜索（或逻辑）：匹配任意条件
    - 精确搜索（与逻辑）：匹配所有条件
  - 多维度筛选：性别、年龄/出生年份、身高、体重、学历、职业、居住地、婚姻状况、车房情况
  - 卡片式展示，支持网格/列表视图

- **客户管理**
  - 查看完整客户档案
  - 编辑现有客户信息
  - 删除客户（带确认对话框）
  - 响应式详情页面

- **数据管理**
  - 📤 导出：将所有客户数据导出为 JSON 格式（带时间戳）
  - 📥 导入：从 JSON 文件恢复数据
  - 冲突解决：处理客户 ID 重复时提供可视化选择界面

- **主题定制**
  - 浅色模式
  - 深色模式
  - 跟随系统
  - 持久化保存用户偏好

### 数据字段

每个客户包含以下信息：
- 客户 ID（唯一标识符）
- 推荐人
- 性别（男/女）
- 出生年份
- 籍贯
- 居住地
- 身高（厘米）
- 体重（斤）
- 学历（初中/高中/中专/大专/本科/硕士/博士/博士后）
- 职业
- 家庭情况
- 年收入
- 车
- 房
- 婚姻状况（未婚/短婚未育/离异/丧偶/其他）
- 子女情况
- 自我评价
- 择偶要求

## 🛠 技术栈

### 框架与语言
- **Flutter** (SDK ^3.9.2) - 跨平台 UI 框架
- **Dart** - 编程语言
- **Material Design 3** - UI 设计规范

### 核心依赖
- **drift** (^2.28.1) - SQLite ORM 数据库框架
- **drift_flutter** (^0.2.6) - Flutter 适配器
- **sqlite3_flutter_libs** (^0.5.39) - SQLite 原生库
- **provider** (^6.1.2) - 状态管理
- **file_picker** (^8.1.6) - 文件选择器（导入/导出）
- **url_launcher** (^6.3.1) - 打开外部链接
- **path_provider** (^2.1.5) - 文件路径管理
- **cupertino_icons** (^1.0.8) - iOS 风格图标

### 开发工具
- **build_runner** (^2.7.2) - 代码生成
- **drift_dev** (^2.28.2) - Drift 代码生成器
- **flutter_lints** (^5.0.0) - 代码规范检查
- **flutter_launcher_icons** (^0.14.2) - 应用图标生成

### 架构特点
- **本地数据库**：Drift + SQLite 实现离线数据持久化
- **响应式设计**：自适应不同屏幕尺寸和方向
- **状态管理**：Provider 模式
- **智能文本解析**：基于正则表达式的非结构化文本识别
- **模块化架构**：清晰的页面、模型、工具分层

## 🚀 开发环境配置

### 前置要求

1. **安装 Flutter SDK**
   - 版本要求：>=3.9.2
   - 下载地址：https://flutter.dev/docs/get-started/install

2. **安装 IDE（任选其一）**
   - Android Studio（推荐）+ Flutter 插件
   - VS Code + Flutter 扩展

3. **配置开发环境**
   ```bash
   # 检查 Flutter 环境
   flutter doctor

   # 确保所有检查项通过（Android/iOS 根据需要）
   ```

### 克隆项目

```bash
git clone <repository-url>
cd MatchBook
```

### 安装依赖

```bash
# 获取所有依赖包
flutter pub get

# 生成 Drift 数据库代码
flutter pub run build_runner build --delete-conflicting-outputs
```

### 运行项目

```bash
# 查看可用设备
flutter devices

# 运行到指定设备（Debug 模式）
flutter run

# 运行到 Android
flutter run -d android

# 运行到 iOS（需要 macOS）
flutter run -d ios

# 运行到 Chrome（Web）
flutter run -d chrome
```

## 📦 编译发布

### Android APK

```bash
# 构建 Release APK
flutter build apk --release

# 构建分架构 APK（更小体积）
flutter build apk --split-per-abi

# 输出位置：build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (AAB)

```bash
# 构建 AAB（Google Play 推荐格式）
flutter build appbundle --release

# 输出位置：build/app/outputs/bundle/release/app-release.aab
```

### iOS (需要 macOS + Xcode)

```bash
# 构建 iOS 应用
flutter build ios --release

# 使用 Xcode 打开项目进行签名和发布
open ios/Runner.xcworkspace
```

## 📁 项目结构

```
lib/
├── main.dart                      # 应用入口
├── database/
│   ├── database.dart              # Drift 数据库实例
│   ├── client.dart                # 数据模型和枚举
│   └── database.g.dart            # 生成的数据库代码
├── pages/
│   ├── input_page.dart            # 客户录入页面
│   ├── search_page.dart           # 搜索查询页面
│   ├── settings_page.dart         # 设置页面
│   ├── client_detail_page.dart    # 客户详情页面
│   ├── client_edit_page.dart      # 客户编辑页面
│   └── about_page.dart            # 关于页面
├── widgets/
│   ├── modern_card.dart           # 自定义卡片组件
│   └── gradient_button.dart       # 渐变按钮组件
└── utils/
    ├── text_parser.dart           # 智能文本解析器
    ├── theme_provider.dart        # 主题状态管理
    ├── clipboard_helper.dart      # 剪贴板工具
    └── plain_text_formatter.dart  # 文本格式化工具
```

## 🎨 设计规范

- **主色调**：中国红 (#D0021B)
- **次要色**：珊瑚红 (#F75C5C)
- **第三色**：胭脂红 (#C41E3A)
- **圆角**：12-24px
- **布局**：卡片式设计，渐变效果
- **字体**：系统默认字体

## 📝 使用说明

### 添加客户

1. 点击底部导航栏"添加客户"
2. 两种录入方式：
   - **手动输入**：逐项填写表单
   - **一键识别**：粘贴或输入非结构化文本，点击"一键识别"自动解析

### 查询客户

1. 点击底部导航栏"查询客户"
2. 使用关键词搜索或高级筛选
3. 选择搜索模式：
   - 模糊搜索：满足任一条件即可
   - 精确搜索：必须满足所有条件
4. 点击客户卡片查看详情

### 导出/导入数据

1. 进入"设置"页面
2. 数据管理区域：
   - **导出**：选择保存位置，生成 JSON 文件
   - **导入**：选择 JSON 文件，自动导入数据
   - 如有冲突，系统会提示选择保留版本

## 📄 许可证

MIT © MiQieR
