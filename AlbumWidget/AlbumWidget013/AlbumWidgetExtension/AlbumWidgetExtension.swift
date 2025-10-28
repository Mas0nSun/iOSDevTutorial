//
//  AlbumWidgetExtension.swift
//  AlbumWidgetExtension
//
//  Created by Mason Sun on 2025/10/27.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), albumImage: nil, title: nil, artist: nil, showInfo: false)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let dataAccessor = WidgetDataAccessor.shared
        
        // 优先使用用户选择的 Widget
        if let selectedWidget = configuration.selectedWidget {
            // 根据选择的 Widget ID 获取具体数据
            let widgets = await dataAccessor.getAllVisibleWidgets()
            if let widgetData = widgets.first(where: { $0.id.uuidString == selectedWidget.id }) {
                return SimpleEntry(
                    date: Date(),
                    albumImage: widgetData.artworkImage,
                    title: widgetData.displayTitle,
                    artist: widgetData.displayArtist,
                    showInfo: configuration.showInfo
                )
            }
        }
        
        // 如果没有选择或找不到，使用第一个可用的 Widget
        let widgets = await dataAccessor.getAllVisibleWidgets()
        if let firstWidget = widgets.first {
            return SimpleEntry(
                date: Date(),
                albumImage: firstWidget.artworkImage,
                title: firstWidget.displayTitle,
                artist: firstWidget.displayArtist,
                showInfo: configuration.showInfo
            )
        } else {
            return SimpleEntry(
                date: Date(),
                albumImage: nil,
                title: "暂无专辑",
                artist: "请添加专辑到 Widget",
                showInfo: configuration.showInfo
            )
        }
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let dataAccessor = WidgetDataAccessor.shared
        let currentDate = Date()
        
        // 优先使用用户选择的 Widget
        if let selectedWidget = configuration.selectedWidget {
            let widgets = await dataAccessor.getAllVisibleWidgets()
            if let widgetData = widgets.first(where: { $0.id.uuidString == selectedWidget.id }) {
                // 显示选中的 Widget
                let entry = SimpleEntry(
                    date: currentDate,
                    albumImage: widgetData.artworkImage,
                    title: widgetData.displayTitle,
                    artist: widgetData.displayArtist,
                    showInfo: configuration.showInfo
                )
                entries.append(entry)
            } else {
                // 如果选中的 Widget 不存在了，显示占位符
                let entry = SimpleEntry(
                    date: currentDate,
                    albumImage: nil,
                    title: "选择的专辑已删除",
                    artist: "请重新选择专辑",
                    showInfo: configuration.showInfo
                )
                entries.append(entry)
            }
        } else {
            // 如果没有选择特定 Widget，显示所有 Widget 的轮播
            let widgets = await dataAccessor.getAllVisibleWidgets()
            
            if widgets.isEmpty {
                // 如果没有数据，显示占位符
                let entry = SimpleEntry(
                    date: currentDate,
                    albumImage: nil,
                    title: "暂无专辑",
                    artist: "请添加专辑到 Widget",
                    showInfo: configuration.showInfo
                )
                entries.append(entry)
            } else {
                // 为每个 Widget 创建时间线条目（轮播显示）
                for (index, widget) in widgets.enumerated() {
                    let entryDate = Calendar.current.date(byAdding: .minute, value: index * 5, to: currentDate) ?? currentDate
                    
                    let entry = SimpleEntry(
                        date: entryDate,
                        albumImage: widget.artworkImage,
                        title: widget.displayTitle,
                        artist: widget.displayArtist,
                        showInfo: configuration.showInfo
                    )
                    entries.append(entry)
                }
            }
        }

        // 设置刷新策略：每 15 分钟刷新一次，或者当没有数据时每 5 分钟刷新一次
        let widgets = await dataAccessor.getAllVisibleWidgets()
        let refreshInterval: TimeInterval = widgets.isEmpty ? 300 : 900 // 5分钟或15分钟
        let nextRefreshDate = Calendar.current.date(byAdding: .second, value: Int(refreshInterval), to: currentDate) ?? currentDate
        
        return Timeline(entries: entries, policy: .after(nextRefreshDate))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let albumImage: UIImage?
    let title: String?
    let artist: String?
    let showInfo: Bool
}

struct AlbumWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        AlbumWidgetView(
            isWidget: true,
            albumImage: entry.albumImage,
            showInfo: entry.showInfo,
            title: entry.title,
            artist: entry.artist
        )
    }
}

struct AlbumWidgetExtension: Widget {
    let kind: String = "AlbumWidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AlbumWidgetExtensionEntryView(entry: entry)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var showInfo: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showInfo = true
        intent.selectedWidget = nil
        return intent
    }
    
    fileprivate static var hideInfo: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showInfo = false
        intent.selectedWidget = nil
        return intent
    }
    
    fileprivate static var withSelectedWidget: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showInfo = true
        // selectedWidget 会在运行时设置
        return intent
    }
}

#Preview(as: .systemSmall) {
    AlbumWidgetExtension()
} timeline: {
    // 使用静态数据创建预览，避免在 Preview 中使用动态数据
    SimpleEntry(date: .now, albumImage: nil, title: "示例专辑", artist: "示例艺术家", showInfo: false)
    SimpleEntry(date: .now, albumImage: nil, title: "另一个专辑", artist: "另一位艺术家", showInfo: true)
}
