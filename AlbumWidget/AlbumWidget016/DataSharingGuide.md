# AlbumWidget 数据共享指南

## 概述

本项目已成功实现了主应用和 Widget Extension 之间的 SwiftData 数据共享，使用 App Group `group.masonsun.albumwidget` 作为共享容器。

## 实现的功能

### 1. 数据共享配置
- ✅ 配置了 App Group 共享容器
- ✅ 主应用的 `WidgetDataManager` 使用共享容器存储数据
- ✅ Widget Extension 可以读取共享数据

### 2. 数据访问层
- ✅ `WidgetDataAccessor`: Widget Extension 中的数据访问器
- ✅ 支持获取所有可见 Widget
- ✅ 支持按类型过滤（专辑/歌曲）
- ✅ 支持搜索功能
- ✅ 提供统计信息

### 3. Widget 功能
- ✅ Widget 显示真实的用户数据
- ✅ 支持显示/隐藏信息
- ✅ 支持选择特定专辑/歌曲
- ✅ 支持轮播显示所有专辑/歌曲
- ✅ 自动刷新机制
- ✅ 占位符显示（无数据时）

## 文件结构

```
AlbumWidget/
├── Model/
│   ├── AlbumWidgetData.swift          # 数据模型
│   └── WidgetDataManager.swift        # 主应用数据管理器（使用共享容器）

AlbumWidgetExtension/
├── AlbumWidgetData.swift              # 数据模型（与主应用相同）
├── WidgetDataAccessor.swift           # Widget 数据访问器
├── WidgetTestHelper.swift             # 测试辅助类
└── AlbumWidgetExtension.swift         # Widget 实现

Share/Widget/
└── AlbumWidgetView.swift              # 共享的 Widget 视图
```

## 使用方法

### 在主应用中添加 Widget 数据

```swift
// 添加专辑 Widget
let albumWidget = try await WidgetDataManager.shared.addWidget(
    from: album,
    showInfo: true,
    artworkImage: albumArtwork
)

// 添加歌曲 Widget
let songWidget = try await WidgetDataManager.shared.addWidget(
    from: song,
    showInfo: true,
    artworkImage: songArtwork
)
```

### Widget 配置选项

用户可以在 iPhone 主屏幕上长按 Widget 并选择"编辑小组件"来配置：

1. **显示信息**: 控制是否显示专辑标题和艺术家名称
2. **选择专辑/歌曲**: 选择要显示的特定专辑或歌曲
   - 如果选择了特定专辑/歌曲，Widget 将只显示该内容
   - 如果没有选择，Widget 将轮播显示所有添加的专辑/歌曲

### 在 Widget Extension 中访问数据

```swift
let dataAccessor = WidgetDataAccessor.shared

// 获取所有可见 Widget
let allWidgets = await dataAccessor.getAllVisibleWidgets()

// 获取专辑 Widget
let albumWidgets = await dataAccessor.getWidgetsByType(.albums)

// 获取随机 Widget
let randomWidget = await dataAccessor.getRandomWidget()

// 搜索 Widget
let searchResults = await dataAccessor.searchWidgets(query: "Taylor Swift")

// 获取统计信息
let totalWidgets = await dataAccessor.getTotalWidgets()
let albumCount = await dataAccessor.getAlbumWidgets()
let songCount = await dataAccessor.getSongWidgets()
let totalPlays = await dataAccessor.getTotalPlayCount()
```

## 数据同步

- 主应用和 Widget Extension 使用相同的 SwiftData 容器
- 数据修改在主应用中完成
- Widget Extension 只读访问数据
- Widget 会自动刷新以显示最新数据

## 注意事项

1. **App Group 配置**: 确保主应用和 Widget Extension 都配置了相同的 App Group
2. **数据模型一致性**: 主应用和 Widget Extension 必须使用相同的数据模型
3. **权限管理**: Widget Extension 只能读取数据，不能修改
4. **性能考虑**: Widget Extension 的数据访问应该尽可能高效

## 测试

使用 `WidgetTestHelper` 类来测试数据共享和配置功能：

```swift
// 验证数据共享
await WidgetTestHelper.shared.verifyDataSharing()

// 测试 Widget 配置功能
await WidgetTestHelper.shared.testWidgetConfiguration()
```

## 下一步

1. 在主应用中实现添加 Widget 的 UI
2. 添加更多 Widget 配置选项
3. 实现 Widget 的交互功能（如播放音乐）
4. 优化 Widget 的刷新策略
