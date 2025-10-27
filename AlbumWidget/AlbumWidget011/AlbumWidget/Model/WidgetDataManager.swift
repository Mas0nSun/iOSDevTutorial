//
//  WidgetDataManager.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/25.
//

import Foundation
import SwiftData
import MusicKit
import UIKit
import Combine
import SwiftUI

@MainActor
class WidgetDataManager: ObservableObject {
    static let shared = WidgetDataManager()
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @Published var widgets: [AlbumWidgetData] = []
    
    private init() {
        do {
            // 创建 SwiftData 模型容器
            let schema = Schema([AlbumWidgetData.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("无法创建 SwiftData 容器: \(error)")
        }
        
        loadWidgets()
    }
    
    // MARK: - 数据加载
    func loadWidgets() {
        do {
            let descriptor = FetchDescriptor<AlbumWidgetData>(
                sortBy: [SortDescriptor(\.displayOrder), SortDescriptor(\.createdAt)]
            )
            widgets = try modelContext.fetch(descriptor)
        } catch {
            print("加载 widgets 失败: \(error)")
            widgets = []
        }
    }
    
    // MARK: - 添加 Widget
    func addWidget(
        from album: Album? = nil,
        from song: Song? = nil,
        showInfo: Bool = true,
        artworkImage: UIImage? = nil
    ) async throws -> AlbumWidgetData {
        
        let widgetData: AlbumWidgetData
        
        if let album = album {
            widgetData = AlbumWidgetData.from(album: album, showInfo: showInfo)
        } else if let song = song {
            widgetData = AlbumWidgetData.from(song: song, showInfo: showInfo)
        } else {
            throw WidgetError.invalidData
        }
        
        // 设置显示顺序
        widgetData.displayOrder = widgets.count
        
        // 保存图片数据
        if let artworkImage = artworkImage {
            widgetData.updateArtwork(artworkImage)
        }
        
        // 保存到数据库
        modelContext.insert(widgetData)
        
        do {
            try modelContext.save()
            loadWidgets()
            return widgetData
        } catch {
            throw WidgetError.saveFailed(error)
        }
    }
    
    // MARK: - 删除 Widget
    func deleteWidget(_ widget: AlbumWidgetData) {
        modelContext.delete(widget)
        
        do {
            try modelContext.save()
            loadWidgets()
        } catch {
            print("删除 widget 失败: \(error)")
        }
    }
    
    // MARK: - 更新 Widget
    func updateWidget(_ widget: AlbumWidgetData) {
        widget.updatedAt = Date()
        
        do {
            try modelContext.save()
            loadWidgets()
        } catch {
            print("更新 widget 失败: \(error)")
        }
    }
    
    // MARK: - 重新排序
    func reorderWidgets(from source: IndexSet, to destination: Int) {
        widgets.move(fromOffsets: source, toOffset: destination)
        
        // 更新显示顺序
        for (index, widget) in widgets.enumerated() {
            widget.displayOrder = index
        }
        
        do {
            try modelContext.save()
        } catch {
            print("重新排序失败: \(error)")
        }
    }
    
    // MARK: - 播放相关
    func markAsPlayed(_ widget: AlbumWidgetData) {
        widget.updatePlayCount()
        updateWidget(widget)
    }
    
    // MARK: - 搜索和过滤
    func searchWidgets(query: String) -> [AlbumWidgetData] {
        if query.isEmpty {
            return widgets
        }
        
        return widgets.filter { widget in
            widget.displayTitle.localizedCaseInsensitiveContains(query) ||
            widget.displayArtist.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getWidgetsByType(_ type: WidgetType) -> [AlbumWidgetData] {
        switch type {
        case .all:
            return widgets
        case .albums:
            return widgets.filter { $0.isAlbum }
        case .songs:
            return widgets.filter { $0.isSong }
        }
    }
    
    // MARK: - 统计信息
    var totalWidgets: Int {
        return widgets.count
    }
    
    var albumWidgets: Int {
        return widgets.filter { $0.isAlbum }.count
    }
    
    var songWidgets: Int {
        return widgets.filter { $0.isSong }.count
    }
    
    var totalPlayCount: Int {
        return widgets.reduce(0) { $0 + $1.playCount }
    }
}

// MARK: - 错误类型
enum WidgetError: LocalizedError {
    case invalidData
    case saveFailed(Error)
    case loadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "无效的音乐数据"
        case .saveFailed(let error):
            return "保存失败: \(error.localizedDescription)"
        case .loadFailed(let error):
            return "加载失败: \(error.localizedDescription)"
        }
    }
}

// MARK: - Widget 类型
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
