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
        SimpleEntry(date: Date(), albumImage: nil, title: nil, artist: nil, showInfo: configuration.showInfo)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // TODO: 从 WidgetDataManager 获取专辑数据
        // let albumWidgetData = await fetchAlbumWidgetData()
        
        let currentDate = Date()
        
        // 生成时间线条目
        let entry = SimpleEntry(
            date: currentDate,
            albumImage: nil, // TODO: 加载专辑图片
            title: nil, // TODO: 使用实际的专辑标题
            artist: nil, // TODO: 使用实际的艺术家名称
            showInfo: configuration.showInfo
        )
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
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
        return intent
    }
    
    fileprivate static var hideInfo: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showInfo = false
        return intent
    }
}

#Preview(as: .systemSmall) {
    AlbumWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, albumImage: nil, title: "示例专辑", artist: "示例艺术家", showInfo: false)
    SimpleEntry(date: .now, albumImage: nil, title: "另一个专辑", artist: "另一位艺术家", showInfo: true)
}
