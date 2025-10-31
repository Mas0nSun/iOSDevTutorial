//
//  SharedPlaybackManager.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/27.
//

import Foundation
import MusicKit
import AppIntents
import Combine

/// 共享的播放管理器，供 App 和 Widget 使用
@MainActor
class SharedPlaybackManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = SharedPlaybackManager()
    
    private init() {}
    
    // MARK: - Published Properties
    
    /// 当前播放状态
    @Published var isPlaying: Bool = false
    
    /// 当前播放的音乐信息
    @Published var currentMusicTitle: String?
    @Published var currentMusicArtist: String?
    
    // MARK: - Private Properties
    
    private let musicManager = MusicKitManager.shared
    
    // MARK: - Public Methods
    
    /// 播放指定的音乐资源
    func playMusic(albumId: String?, songId: String?) async {
        // 检查权限
        if !musicManager.isAuthorized {
            await musicManager.requestMusicPermission()
            guard musicManager.isAuthorized else {
                print("未获得 Apple Music 权限，无法播放")
                return
            }
        }
        
        do {
            if let songId = songId, !songId.isEmpty {
                try await playSong(id: songId)
            } else if let albumId = albumId, !albumId.isEmpty {
                try await playAlbum(id: albumId)
            } else {
                print("无效的音乐资源 ID")
            }
        } catch {
            print("播放失败：\(error.localizedDescription)")
        }
    }
    
    /// 播放指定的 Widget 数据
    func playWidget(_ widgetData: AlbumWidgetData) async {
        await playMusic(albumId: widgetData.albumId, songId: widgetData.songId)
    }
    
    /// 暂停播放
    func pause() async {
        let player = ApplicationMusicPlayer.shared
        await player.pause()
        isPlaying = false
    }
    
    /// 恢复播放
    func resume() async {
        let player = ApplicationMusicPlayer.shared
        do {
            try await player.play()
            isPlaying = true
        } catch {
            print("恢复播放失败：\(error.localizedDescription)")
        }
    }
    
    /// 切换播放/暂停状态
    func togglePlayPause() async {
        let player = ApplicationMusicPlayer.shared
        switch player.state.playbackStatus {
        case .playing:
            await pause()
        case .paused, .stopped:
            await resume()
        @unknown default:
            break
        }
    }
    
    // MARK: - Private Methods
    
    /// 通过 Apple Music 的 Song ID 播放歌曲
    private func playSong(id: String) async throws {
        let musicItemID = MusicItemID(id)
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: musicItemID)
        let response = try await request.response()
        guard let song = response.items.first else { throw MusicKitError.unknownError }
        
        let player = ApplicationMusicPlayer.shared
        player.queue = ApplicationMusicPlayer.Queue(for: [song])
        try await player.play()
        
        // 更新播放状态
        isPlaying = true
        currentMusicTitle = song.title
        currentMusicArtist = song.artistName
    }
    
    /// 通过 Apple Music 的 Album ID 播放整张专辑
    private func playAlbum(id: String) async throws {
        let musicItemID = MusicItemID(id)
        let request = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: musicItemID)
        let response = try await request.response()
        guard let album = response.items.first else { throw MusicKitError.unknownError }
        
        // 加载 tracks，直接用 tracks 构建播放队列
        let detailedAlbum = try await album.with([.tracks])
        let tracks = detailedAlbum.tracks ?? []
        guard !tracks.isEmpty else { throw MusicKitError.unknownError }
        
        let player = ApplicationMusicPlayer.shared
        player.queue = ApplicationMusicPlayer.Queue(for: tracks)
        try await player.play()
        
        // 更新播放状态
        isPlaying = true
        currentMusicTitle = album.title
        currentMusicArtist = album.artistName
    }
}

// MARK: - Custom Errors

enum MusicKitError: LocalizedError {
    case notAuthorized
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "未获得音乐权限，无法访问音乐库"
        case .networkError:
            return "网络连接错误"
        case .unknownError:
            return "未知错误"
        }
    }
}
