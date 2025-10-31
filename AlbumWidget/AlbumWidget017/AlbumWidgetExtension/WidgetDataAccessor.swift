//
//  WidgetDataAccessor.swift
//  AlbumWidgetExtension
//
//  Created by Mason Sun on 2025/10/27.
//

import Foundation
import SwiftData
import UIKit
import Combine

/// Widget Extension 中的数据访问器
/// 用于从共享的 SwiftData 容器中读取数据
@MainActor
class WidgetDataAccessor: ObservableObject {
    static let shared = WidgetDataAccessor()
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    private init() {
        do {
            // 使用与主应用相同的共享容器
            let schema = Schema([AlbumWidgetData.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                groupContainer: .identifier("group.masonsun.albumwidget")
            )
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("无法创建 Widget SwiftData 容器: \(error)")
        }
    }
    
    // MARK: - 数据获取方法
    
    /// 获取所有可见的 Widget 数据
    func getAllVisibleWidgets() async -> [AlbumWidgetData] {
        do {
            let descriptor = FetchDescriptor<AlbumWidgetData>(
                predicate: #Predicate { $0.isVisible },
                sortBy: [SortDescriptor(\.displayOrder), SortDescriptor(\.createdAt)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("获取 Widget 数据失败: \(error)")
            return []
        }
    }
    
    /// 获取指定类型的 Widget 数据
    func getWidgetsByType(_ type: WidgetType) async -> [AlbumWidgetData] {
        let allWidgets = await getAllVisibleWidgets()
        
        switch type {
        case .all:
            return allWidgets
        case .albums:
            return allWidgets.filter { $0.isAlbum }
        case .songs:
            return allWidgets.filter { $0.isSong }
        }
    }
    
    /// 获取指定索引的 Widget 数据
    func getWidget(at index: Int) async -> AlbumWidgetData? {
        let widgets = await getAllVisibleWidgets()
        guard index >= 0 && index < widgets.count else { return nil }
        return widgets[index]
    }
    
    /// 获取随机 Widget 数据
    func getRandomWidget() async -> AlbumWidgetData? {
        let widgets = await getAllVisibleWidgets()
        return widgets.randomElement()
    }
    
    /// 获取最常播放的 Widget 数据
    func getMostPlayedWidget() async -> AlbumWidgetData? {
        let widgets = await getAllVisibleWidgets()
        return widgets.max { $0.playCount < $1.playCount }
    }
    
    /// 获取最近播放的 Widget 数据
    func getRecentlyPlayedWidget() async -> AlbumWidgetData? {
        let widgets = await getAllVisibleWidgets()
        return widgets.max { 
            ($0.lastPlayedAt ?? Date.distantPast) < ($1.lastPlayedAt ?? Date.distantPast)
        }
    }
    
    /// 搜索 Widget 数据
    func searchWidgets(query: String) async -> [AlbumWidgetData] {
        let allWidgets = await getAllVisibleWidgets()
        
        if query.isEmpty {
            return allWidgets
        }
        
        return allWidgets.filter { widget in
            widget.displayTitle.localizedCaseInsensitiveContains(query) ||
            widget.displayArtist.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - 统计信息
    
    /// 获取 Widget 总数
    func getTotalWidgets() async -> Int {
        return await getAllVisibleWidgets().count
    }
    
    /// 获取专辑 Widget 数量
    func getAlbumWidgets() async -> Int {
        return await getWidgetsByType(.albums).count
    }
    
    /// 获取歌曲 Widget 数量
    func getSongWidgets() async -> Int {
        return await getWidgetsByType(.songs).count
    }
    
    /// 获取总播放次数
    func getTotalPlayCount() async -> Int {
        return await getAllVisibleWidgets().reduce(0) { $0 + $1.playCount }
    }
}

// MARK: - Widget 类型（与主应用保持一致）
enum WidgetType: String, CaseIterable {
    case all = "all"
    case albums = "albums"
    case songs = "songs"
    
    var displayName: String {
        switch self {
        case .all: return "全部"
        case .albums: return "专辑"
        case .songs: return "歌曲"
        }
    }
}
