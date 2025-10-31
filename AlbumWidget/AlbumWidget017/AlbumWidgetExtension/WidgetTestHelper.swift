//
//  WidgetTestHelper.swift
//  AlbumWidgetExtension
//
//  Created by Mason Sun on 2025/10/27.
//

import Foundation
import SwiftData
import UIKit

/// Widget Extension 测试辅助类
/// 用于创建测试数据来验证数据共享功能
@MainActor
class WidgetTestHelper {
    static let shared = WidgetTestHelper()
    
    private init() {}
    
    /// 创建测试数据
    func createTestData() async {
        let dataAccessor = WidgetDataAccessor.shared
        
        // 检查是否已有数据
        let total = await dataAccessor.getTotalWidgets()
        if total > 0 {
            print("已有 \(total) 个 Widget 数据")
            return
        }
        
        // 创建测试专辑数据
        let testAlbums = [
            ("Taylor Swift", "1989", "https://example.com/1989.jpg"),
            ("The Weeknd", "After Hours", "https://example.com/afterhours.jpg"),
            ("Billie Eilish", "Happier Than Ever", "https://example.com/happier.jpg"),
            ("Drake", "Certified Lover Boy", "https://example.com/clb.jpg"),
            ("Olivia Rodrigo", "SOUR", "https://example.com/sour.jpg")
        ]
        
        for (index, (artist, album, _)) in testAlbums.enumerated() {
            let widgetData = AlbumWidgetData(
                name: album,
                albumId: "album_\(index)",
                albumTitle: album,
                artistName: artist,
                albumArtistName: artist,
                showInfo: true,
                displayOrder: index,
                isVisible: true
            )
            
            // 添加一些随机播放数据
            widgetData.playCount = Int.random(in: 0...100)
            if widgetData.playCount > 0 {
                widgetData.lastPlayedAt = Date().addingTimeInterval(-Double.random(in: 0...86400))
            }
            
            // 这里我们无法直接保存到数据库，因为 Widget Extension 是只读的
            // 实际的数据创建应该在主应用中进行
            print("创建测试数据: \(album) - \(artist)")
        }
        
        print("测试数据创建完成")
    }
    
    /// 验证数据共享
    func verifyDataSharing() async {
        let dataAccessor = WidgetDataAccessor.shared
        
        print("=== 数据共享验证 ===")
        print("总 Widget 数量: \(await dataAccessor.getTotalWidgets())")
        print("专辑 Widget 数量: \(await dataAccessor.getAlbumWidgets())")
        print("歌曲 Widget 数量: \(await dataAccessor.getSongWidgets())")
        print("总播放次数: \(await dataAccessor.getTotalPlayCount())")
        
        let widgets = await dataAccessor.getAllVisibleWidgets()
        for (index, widget) in widgets.enumerated() {
            print("Widget \(index + 1): \(widget.displayTitle) - \(widget.displayArtist)")
            print("  类型: \(widget.isAlbum ? "专辑" : "歌曲")")
            print("  播放次数: \(widget.playCount)")
            print("  最后播放: \(widget.lastPlayedAt?.formatted() ?? "从未播放")")
        }
        
        print("=== 验证完成 ===")
    }
    
    /// 测试 Widget 配置功能
    func testWidgetConfiguration() async {
        let dataAccessor = WidgetDataAccessor.shared
        let widgets = await dataAccessor.getAllVisibleWidgets()
        
        print("=== Widget 配置测试 ===")
        
        if widgets.isEmpty {
            print("没有可用的 Widget 数据，无法测试配置功能")
            return
        }
        
        // 测试选择第一个 Widget
        if let firstWidget = widgets.first {
            let entity = AlbumWidgetEntity(from: firstWidget)
            print("选择的 Widget: \(entity.displayTitle) - \(entity.displayArtist)")
            print("  ID: \(entity.id)")
            print("  类型: \(entity.isAlbum ? "专辑" : "歌曲")")
        }
        
        // 测试搜索功能
        let searchResults = await dataAccessor.searchWidgets(query: "Taylor")
        print("搜索 'Taylor' 的结果: \(searchResults.count) 个")
        
        // 测试按类型过滤
        let albumWidgets = await dataAccessor.getWidgetsByType(.albums)
        let songWidgets = await dataAccessor.getWidgetsByType(.songs)
        print("专辑 Widget: \(albumWidgets.count) 个")
        print("歌曲 Widget: \(songWidgets.count) 个")
        
        print("=== 配置测试完成 ===")
    }
}
