//
//  AppIntent.swift
//  AlbumWidgetExtension
//
//  Created by Mason Sun on 2025/10/27.
//

import WidgetKit
import AppIntents
import SwiftData
import MusicKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "专辑小组件配置" }
    static var description: IntentDescription { "配置专辑小组件的显示选项。" }

    // 控制是否显示专辑信息
    @Parameter(title: "显示信息", default: true)
    var showInfo: Bool
    
    // 选择要显示的专辑/歌曲
    @Parameter(title: "选择专辑/歌曲", default: nil)
    var selectedWidget: AlbumWidgetEntity?
}

// MARK: - AlbumWidgetEntity
struct AlbumWidgetEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "专辑/歌曲"
    static var defaultQuery = AlbumWidgetQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(displayTitle)",
            subtitle: "\(displayArtist)"
        )
    }
    
    let id: String
    let displayTitle: String
    let displayArtist: String
    let isAlbum: Bool
    let artworkImage: Data?
    
    init(from widgetData: AlbumWidgetData) {
        self.id = widgetData.id.uuidString
        self.displayTitle = widgetData.displayTitle
        self.displayArtist = widgetData.displayArtist
        self.isAlbum = widgetData.isAlbum
        self.artworkImage = widgetData.songArtworkData ?? widgetData.albumArtworkData
    }
}

// MARK: - AlbumWidgetQuery
struct AlbumWidgetQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [AlbumWidgetEntity] {
        let dataAccessor = WidgetDataAccessor.shared
        let widgets = await dataAccessor.getAllVisibleWidgets()
        
        return widgets.compactMap { widget in
            if identifiers.contains(widget.id.uuidString) {
                return AlbumWidgetEntity(from: widget)
            }
            return nil
        }
    }
    
    func suggestedEntities() async throws -> [AlbumWidgetEntity] {
        let dataAccessor = WidgetDataAccessor.shared
        let widgets = await dataAccessor.getAllVisibleWidgets()
        
        return widgets.map { AlbumWidgetEntity(from: $0) }
    }
    
    func defaultResult() async -> AlbumWidgetEntity? {
        let dataAccessor = WidgetDataAccessor.shared
        let widgets = await dataAccessor.getAllVisibleWidgets()
        
        // 返回第一个 Widget 作为默认选择
        return widgets.first.map { AlbumWidgetEntity(from: $0) }
    }
}
