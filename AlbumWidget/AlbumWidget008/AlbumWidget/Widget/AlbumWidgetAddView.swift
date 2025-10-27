//
//  AlbumWidgetAddView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/25.
//

import SwiftUI
import MusicKit

struct AlbumWidgetAddView: View {
    let selectedAlbum: Album?
    let selectedSong: Song?
    
    @State private var albumImage: UIImage?
    @State private var isLoading = false
    @State private var albumSongs: [Song] = []
    @State private var isLoadingSongs = false
    @Environment(\.dismiss) private var dismiss
    
    init(selectedAlbum: Album? = nil, selectedSong: Song? = nil) {
        self.selectedAlbum = selectedAlbum
        self.selectedSong = selectedSong
    }
    
    var body: some View {
        GeometryReader { geometry in
            // 可滚动的主内容
            ScrollView {
                VStack(spacing: 0) {
                    // 顶部小组件展示区域
                    widgetPreviewSection(geometry: geometry)
                    
                    // 歌曲列表区域（如果是专辑）
                    if let album = selectedAlbum {
                        songsListSection(album: album)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationTitle("添加小组件")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadAlbumImage()
            if selectedAlbum != nil {
                loadAlbumSongs()
            }
        }
        .safeAreaInset(edge: .bottom) {
            floatingAddButton()
                .padding(.horizontal, 20)
                .padding(.top, 16)
        }
    }
    
    // MARK: - 小组件预览区域
    private func widgetPreviewSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            
            // 小组件卡片
            AlbumWidgetView(albumImage: albumImage)
                .frame(width: 200, height: 200)
            
            // 音乐信息
            if let album = selectedAlbum {
                VStack(spacing: 4) {
                    Text(album.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(album.artistName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            } else if let song = selectedSong {
                VStack(spacing: 4) {
                    Text(song.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(song.artistName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    // MARK: - 底部悬浮按钮
    private func floatingAddButton() -> some View {
        Button(action: {
            addWidget()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                Text("添加到主屏幕")
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            // 意味着让视图的宽度能有多宽就多宽
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glass)
        .disabled(isLoading)
        .opacity(isLoading ? 0.6 : 1.0)
    }
    
    // MARK: - 功能行组件
    private struct FeatureRow: View {
        let icon: String
        let title: String
        let description: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - 加载专辑图片
    private func loadAlbumImage() {
        guard albumImage == nil else { return }
        
        isLoading = true
        
        Task {
            do {
                let image: UIImage?
                
                if let album = selectedAlbum {
                    image = try await loadImage(from: album.artwork?.url(width: 300, height: 300))
                } else if let song = selectedSong {
                    image = try await loadImage(from: song.artwork?.url(width: 300, height: 300))
                } else {
                    image = nil
                }
                
                await MainActor.run {
                    self.albumImage = image
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func loadImage(from url: URL?) async throws -> UIImage? {
        guard let url = url else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    
    // MARK: - 歌曲列表区域
    private func songsListSection(album: Album) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("专辑歌曲")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isLoadingSongs {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if isLoadingSongs {
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 16)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 12)
                                    .cornerRadius(4)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
            } else if !albumSongs.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(Array(albumSongs.enumerated()), id: \.element.id) { index, song in
                        SongRowView(song: song, trackNumber: index + 1)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        
                        if index < albumSongs.count - 1 {
                            Divider()
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "music.note.house")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                    
                    Text("专辑信息")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("由于系统限制，无法直接获取专辑中的歌曲列表。您可以选择专辑封面作为小组件显示。")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - 歌曲行视图
    private struct SongRowView: View {
        let song: Song
        let trackNumber: Int
        
        var body: some View {
            HStack(spacing: 12) {
                // 歌曲封面
                AsyncImage(url: song.artwork?.url(width: 80, height: 80)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "music.note")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 40, height: 40)
                .cornerRadius(8)
                
                // 歌曲信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Text(song.artistName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // 曲目编号
                Text("\(trackNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 20, alignment: .trailing)
            }
        }
    }
    
    // MARK: - 加载专辑歌曲
    private func loadAlbumSongs() {
        guard let album = selectedAlbum else { return }
        
        isLoadingSongs = true
        
        Task {
            do {
                let songs = try await MusicKitManager.shared.getAlbumSongs(album: album)
                await MainActor.run {
                    self.albumSongs = Array(songs)
                    self.isLoadingSongs = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingSongs = false
                }
            }
        }
    }
    
    // MARK: - 添加小组件
    private func addWidget() {
        // TODO: 实现添加小组件的逻辑
        print("添加小组件: \(selectedAlbum?.title ?? selectedSong?.title ?? "未知")")
    }
}

#Preview {
    NavigationView {
        AlbumWidgetAddView()
    }
}
