//
//  MusicKitManager.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/21.
//

import Foundation
import MusicKit
import SwiftUI
import Combine

/// MusicKit 权限管理类
class MusicKitManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 当前授权状态
    @Published var authorizationStatus: MusicAuthorization.Status = .notDetermined
    
    /// 是否已授权
    @Published var isAuthorized: Bool = false
    
    /// 是否正在请求权限
    @Published var isRequestingPermission: Bool = false
    
    /// 错误信息
    @Published var errorMessage: String?
    
    // MARK: - Singleton
    
    static let shared = MusicKitManager()
    
    private init() {
        updateAuthorizationStatus()
    }
    
    // MARK: - Public Methods
    
    /// 更新授权状态
    @MainActor
    func updateAuthorizationStatus() {
        authorizationStatus = MusicAuthorization.currentStatus
        isAuthorized = authorizationStatus == .authorized
    }
    
    /// 请求音乐权限
    @MainActor
    func requestMusicPermission() async {
        guard !isRequestingPermission else { return }
        
        isRequestingPermission = true
        errorMessage = nil
        
        do {
            let status = try await MusicAuthorization.request()
            authorizationStatus = status
            isAuthorized = status == .authorized
            isRequestingPermission = false
            
            if status != .authorized {
                errorMessage = "音乐权限被拒绝，无法访问您的音乐库"
            }
        } catch {
            isRequestingPermission = false
            errorMessage = "请求音乐权限时出错：\(error.localizedDescription)"
        }
    }
    
    /// 获取权限状态描述
    var statusDescription: String {
        switch authorizationStatus {
        case .notDetermined:
            return "未确定"
        case .denied:
            return "已拒绝"
        case .restricted:
            return "受限制"
        case .authorized:
            return "已授权"
        @unknown default:
            return "未知状态"
        }
    }
    
    /// 检查是否可以请求权限
    var canRequestPermission: Bool {
        return authorizationStatus == .notDetermined
    }
    
    /// 检查是否需要引导用户到设置页面
    var shouldGuideToSettings: Bool {
        return authorizationStatus == .denied || authorizationStatus == .restricted
    }
    
    /// 打开应用设置页面
    @MainActor
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    /// 重置错误信息
    @MainActor
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - MusicKit Extensions

extension MusicKitManager {
    
    /// 获取用户音乐库中的专辑
    func fetchUserAlbums() async throws -> [Album] {
        guard isAuthorized else {
            throw MusicKitError.notAuthorized
        }
        
        let request = MusicLibraryRequest<Album>()
        let response = try await request.response()
        return Array(response.items)
    }
    
    /// 获取用户音乐库中的歌曲
    func fetchUserSongs() async throws -> [Song] {
        guard isAuthorized else {
            throw MusicKitError.notAuthorized
        }
        
        let request = MusicLibraryRequest<Song>()
        let response = try await request.response()
        return Array(response.items)
    }
    
    /// 搜索音乐
    func searchMusic(query: String) async throws -> MusicCatalogSearchResponse {
        guard isAuthorized else {
            throw MusicKitError.notAuthorized
        }
        
        var request = MusicCatalogSearchRequest(term: query, types: [Album.self, Song.self])
        request.limit = 25
        
        return try await request.response()
    }
    
    /// 获取专辑中的歌曲
    func getAlbumSongs(album: Album) async throws -> [Track] {
        guard isAuthorized else {
            throw MusicKitError.notAuthorized
        }
        
        // 使用 with 方法加载专辑的 tracks 关系
        let detailedAlbum = try await album.with([.tracks])
        
        // 返回专辑中的歌曲列表
        if let tracks = detailedAlbum.tracks {
            return Array(tracks)
        }
        
        return []
    }
}

// MARK: - Playback (App 内使用)

extension MusicKitManager {
    /// 播放指定的 Widget 音乐（优先歌曲，其次专辑）
    @MainActor
    func play(widget: AlbumWidgetData) async {
        await SharedPlaybackManager.shared.playWidget(widget)
    }
    
    /// 通用播放方法 - 通过音乐资源 ID 播放
    @MainActor
    func playMusic(albumId: String?, songId: String?) async {
        await SharedPlaybackManager.shared.playMusic(albumId: albumId, songId: songId)
    }
    
    /// 暂停播放
    @MainActor
    func pause() async {
        await SharedPlaybackManager.shared.pause()
    }
    
    /// 恢复播放
    @MainActor
    func resume() async {
        await SharedPlaybackManager.shared.resume()
    }
    
    /// 切换播放/暂停状态
    @MainActor
    func togglePlayPause() async {
        await SharedPlaybackManager.shared.togglePlayPause()
    }
    
    /// 通过 Apple Music 的 Song ID 播放歌曲
    func playSong(id: String) async throws {
        guard isAuthorized else { throw MusicKitError.notAuthorized }
        let musicItemID = MusicItemID(id)
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: musicItemID)
        let response = try await request.response()
        guard let song = response.items.first else { throw MusicKitError.unknownError }
        let player = ApplicationMusicPlayer.shared
        // 以该歌曲创建播放队列并播放
        player.queue = ApplicationMusicPlayer.Queue(for: [song])
        try await player.play()
    }
    
    /// 通过 Apple Music 的 Album ID 播放整张专辑
    func playAlbum(id: String) async throws {
        guard isAuthorized else { throw MusicKitError.notAuthorized }
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
    }
}

// MARK: - Custom Errors

//enum MusicKitError: LocalizedError {
//    case notAuthorized
//    case networkError
//    case unknownError
//    
//    var errorDescription: String? {
//        switch self {
//        case .notAuthorized:
//            return "未获得音乐权限，无法访问音乐库"
//        case .networkError:
//            return "网络连接错误"
//        case .unknownError:
//            return "未知错误"
//        }
//    }
//}
