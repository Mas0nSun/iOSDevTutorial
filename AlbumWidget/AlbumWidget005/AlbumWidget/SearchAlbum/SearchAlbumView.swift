//
//  SearchAlbumView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/23.
//

import SwiftUI
import MusicKit

struct SearchAlbumView: View {
    @StateObject private var musicKitManager = MusicKitManager.shared
    @State private var searchText = ""
    @State private var albums: [Album] = []
    @State private var songs: [Song] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    VStack {
                        ProgressView("搜索中...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else if albums.isEmpty && songs.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "music.note")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("未找到相关结果")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !albums.isEmpty || !songs.isEmpty {
                    List {
                        // 专辑 Section
                        if !albums.isEmpty {
                            Section("专辑") {
                                ForEach(albums, id: \.id) { album in
                                    AlbumResultRow(album: album)
                                }
                            }
                        }
                        
                        // 歌曲 Section
                        if !songs.isEmpty {
                            Section("歌曲") {
                                ForEach(songs, id: \.id) { song in
                                    SongResultRow(song: song)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else if albums.isEmpty && songs.isEmpty && searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "music.note.house")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("输入歌曲或专辑名称开始搜索")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 显示上次搜索的结果（即使搜索框为空）
                    List {
                        // 专辑 Section
                        if !albums.isEmpty {
                            Section("专辑") {
                                ForEach(albums, id: \.id) { album in
                                    AlbumResultRow(album: album)
                                }
                            }
                        }
                        
                        // 歌曲 Section
                        if !songs.isEmpty {
                            Section("歌曲") {
                                ForEach(songs, id: \.id) { song in
                                    SongResultRow(song: song)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("搜索音乐")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜索歌曲或专辑")
            .onSubmit(of: .search) {
                performSearch()
            }
            .onChange(of: searchText) { _, newValue in
                // 当搜索文本改变时自动搜索（可选）
                if !newValue.isEmpty {
                    performSearch()
                }
                // 注意：不在这里清空搜索结果，保持上次搜索的结果
            }
            .onAppear {
                musicKitManager.updateAuthorizationStatus()
            }
            .alert("搜索错误", isPresented: .constant(errorMessage != nil)) {
                Button("确定") {
                    errorMessage = nil
                }
            } message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard musicKitManager.isAuthorized else {
            errorMessage = "需要音乐权限才能搜索"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await musicKitManager.searchMusic(query: searchText)
                await MainActor.run {
                    albums = Array(response.albums)
                    songs = Array(response.songs)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "搜索失败: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

struct AlbumResultRow: View {
    let album: Album
    
    var body: some View {
        HStack(spacing: 12) {
            // 专辑封面
            AsyncImage(url: album.artwork?.url(width: 120, height: 120)) { image in
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
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            // 专辑信息
            VStack(alignment: .leading, spacing: 4) {
                Text(album.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(album.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if let releaseDate = album.releaseDate {
                    Text("发行日期: \(DateFormatter.yearMonthDay.string(from: releaseDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // 专辑标识
            Text("专辑")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
    }
}

struct SongResultRow: View {
    let song: Song
    
    var body: some View {
        HStack(spacing: 12) {
            // 歌曲封面
            AsyncImage(url: song.artwork?.url(width: 120, height: 120)) { image in
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
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            // 歌曲信息
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(song.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if let albumTitle = song.albumTitle {
                    Text(albumTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // 歌曲标识
            Text("歌曲")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.2))
                .foregroundColor(.green)
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    SearchAlbumView()
}
