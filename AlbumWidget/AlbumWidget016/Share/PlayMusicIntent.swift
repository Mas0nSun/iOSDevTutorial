//
//  PlayMusicIntent.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/29.
//

import Foundation
import AppIntents
import MusicKit

// MARK: - Play Music Intent

struct PlayMusicIntent: AppIntent {
    static var title: LocalizedStringResource = "播放/暂停音乐"
    static var description: IntentDescription = "播放或暂停选中的专辑或歌曲"
    
    @Parameter(title: "专辑ID")
    var albumId: String?
    
    @Parameter(title: "歌曲ID")
    var songId: String?
    
    @Parameter(title: "音乐标题")
    var musicTitle: String?
    
    @Parameter(title: "艺术家")
    var artist: String?
    
    func perform() async throws -> some IntentResult {
        // 检查权限
        let authorizationStatus = MusicAuthorization.currentStatus
        if authorizationStatus != .authorized {
            let newStatus = try await MusicAuthorization.request()
            guard newStatus == .authorized else {
                throw PlayMusicError.notAuthorized
            }
        }
        
        let player = ApplicationMusicPlayer.shared
        
        // 检查当前播放状态
        switch player.state.playbackStatus {
        case .playing:
            // 如果正在播放，则暂停
            await player.pause()
        case .paused, .stopped:
            // 如果暂停或停止，则播放音乐
            do {
                if let songId = songId, !songId.isEmpty {
                    try await playSong(id: songId)
                } else if let albumId = albumId, !albumId.isEmpty {
                    try await playAlbum(id: albumId)
                } else {
                    throw PlayMusicError.invalidMusicId
                }
            } catch {
                throw PlayMusicError.playbackFailed(error.localizedDescription)
            }
        @unknown default:
            // 对于未知状态，尝试播放
            do {
                if let songId = songId, !songId.isEmpty {
                    try await playSong(id: songId)
                } else if let albumId = albumId, !albumId.isEmpty {
                    try await playAlbum(id: albumId)
                } else {
                    throw PlayMusicError.invalidMusicId
                }
            } catch {
                throw PlayMusicError.playbackFailed(error.localizedDescription)
            }
        }
        
        return .result()
    }
    
    // MARK: - Private Methods
    
    /// 通过 Apple Music 的 Song ID 播放歌曲
    private func playSong(id: String) async throws {
        let musicItemID = MusicItemID(id)
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: musicItemID)
        let response = try await request.response()
        guard let song = response.items.first else { throw PlayMusicError.unknownError }
        
        let player = ApplicationMusicPlayer.shared
        player.queue = ApplicationMusicPlayer.Queue(for: [song])
        try await player.play()
    }
    
    /// 通过 Apple Music 的 Album ID 播放整张专辑
    private func playAlbum(id: String) async throws {
        let musicItemID = MusicItemID(id)
        let request = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: musicItemID)
        let response = try await request.response()
        guard let album = response.items.first else { throw PlayMusicError.unknownError }
        
        // 加载 tracks，直接用 tracks 构建播放队列
        let detailedAlbum = try await album.with([.tracks])
        let tracks = detailedAlbum.tracks ?? []
        guard !tracks.isEmpty else { throw PlayMusicError.unknownError }
        
        let player = ApplicationMusicPlayer.shared
        player.queue = ApplicationMusicPlayer.Queue(for: tracks)
        try await player.play()
    }
    
    
    // MARK: - Play Music Errors

    enum PlayMusicError: LocalizedError {
        case notAuthorized
        case invalidMusicId
        case playbackFailed(String)
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .notAuthorized:
                return "未获得 Apple Music 权限，无法播放音乐"
            case .invalidMusicId:
                return "无效的音乐资源 ID"
            case .playbackFailed(let message):
                return "播放失败：\(message)"
            case .unknownError:
                return "播放时发生未知错误"
            }
        }
    }

}
