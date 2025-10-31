//
//  AlbumWidgetData.swift
//  AlbumWidgetExtension
//
//  Created by Mason Sun on 2025/10/27.
//

import Foundation
import SwiftData
import MusicKit
import UIKit

@Model
class AlbumWidgetData {
    // 基本信息
    var id: UUID
    var name: String
    var createdAt: Date
    var updatedAt: Date
    
    // 音乐信息
    var albumId: String?
    var songId: String?
    var albumTitle: String?
    var songTitle: String?
    var artistName: String?
    var albumArtistName: String?
    
    // 显示设置
    var showInfo: Bool
    
    // 图片数据
    var albumArtworkData: Data?
    var songArtworkData: Data?
    
    // 播放相关
    var isPlayable: Bool
    var lastPlayedAt: Date?
    var playCount: Int
    
    // 排序和显示
    var displayOrder: Int
    var isVisible: Bool
    
    init(
        name: String,
        albumId: String? = nil,
        songId: String? = nil,
        albumTitle: String? = nil,
        songTitle: String? = nil,
        artistName: String? = nil,
        albumArtistName: String? = nil,
        showInfo: Bool = true,
        albumArtworkData: Data? = nil,
        songArtworkData: Data? = nil,
        isPlayable: Bool = true,
        displayOrder: Int = 0,
        isVisible: Bool = true
    ) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.updatedAt = Date()
        self.albumId = albumId
        self.songId = songId
        self.albumTitle = albumTitle
        self.songTitle = songTitle
        self.artistName = artistName
        self.albumArtistName = albumArtistName
        self.showInfo = showInfo
        self.albumArtworkData = albumArtworkData
        self.songArtworkData = songArtworkData
        self.isPlayable = isPlayable
        self.lastPlayedAt = nil
        self.playCount = 0
        self.displayOrder = displayOrder
        self.isVisible = isVisible
    }
    
    // 便利方法
    var displayTitle: String {
        return songTitle ?? albumTitle ?? "未知标题"
    }
    
    var displayArtist: String {
        return artistName ?? albumArtistName ?? "未知艺术家"
    }
    
    var artworkImage: UIImage? {
        if let data = songArtworkData ?? albumArtworkData {
            return UIImage(data: data)
        }
        return nil
    }
    
    var isAlbum: Bool {
        return albumId != nil
    }
    
    var isSong: Bool {
        return songId != nil && albumId == nil
    }
    
    func updatePlayCount() {
        playCount += 1
        lastPlayedAt = Date()
        updatedAt = Date()
    }
    
    func updateArtwork(_ image: UIImage?) {
        guard let image = image else { return }
        if let data = image.jpegData(compressionQuality: 0.8) {
            if isAlbum {
                albumArtworkData = data
            } else {
                songArtworkData = data
            }
            updatedAt = Date()
        }
    }
}

// MARK: - 扩展方法
extension AlbumWidgetData {
    static func from(album: Album, showInfo: Bool = true) -> AlbumWidgetData {
        return AlbumWidgetData(
            name: album.title,
            albumId: album.id.rawValue,
            albumTitle: album.title,
            artistName: album.artistName,
            albumArtistName: album.artistName,
            showInfo: showInfo
        )
    }
    
    static func from(song: Song, showInfo: Bool = true) -> AlbumWidgetData {
        return AlbumWidgetData(
            name: song.title,
            songId: song.id.rawValue,
            songTitle: song.title,
            artistName: song.artistName,
            showInfo: showInfo
        )
    }
}
