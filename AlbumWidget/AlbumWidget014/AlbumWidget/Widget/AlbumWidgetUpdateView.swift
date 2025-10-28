//
//  AlbumWidgetUpdateView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/27.
//

import SwiftUI
import MusicKit

struct AlbumWidgetUpdateView: View {
    let widgetData: AlbumWidgetData
    let selectedAlbum: Album?
    let selectedSong: Song?
    
    @StateObject private var imageLoader = AlbumImageLoader()
    @StateObject private var songsLoader = AlbumSongsLoader()
    @State private var showInfo: Bool
    @State private var isUpdating = false
    @State private var showSuccessAlert = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = WidgetDataManager.shared
    
    init(widgetData: AlbumWidgetData, selectedAlbum: Album? = nil, selectedSong: Song? = nil) {
        self.widgetData = widgetData
        self.selectedAlbum = selectedAlbum
        self.selectedSong = selectedSong
        // 从现有的 widget 数据初始化 showInfo
        _showInfo = State(initialValue: widgetData.showInfo)
    }
    
    var body: some View {
        // 可滚动的主内容
        ScrollView {
            VStack(spacing: 0) {
                // 顶部小组件展示区域
                WidgetPreviewSection(
                    albumImage: imageLoader.albumImage,
                    showInfo: $showInfo,
                    title: selectedAlbum?.title ?? selectedSong?.title ?? widgetData.displayTitle,
                    artist: selectedAlbum?.artistName ?? selectedSong?.artistName ?? widgetData.displayArtist
                )
                
                // 歌曲列表区域（如果是专辑）
                if let album = selectedAlbum {
                    SongsListSection(
                        album: album,
                        albumSongs: songsLoader.albumSongs,
                        isLoadingSongs: songsLoader.isLoadingSongs
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("更新小组件")
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            // 如果有新的专辑/歌曲，加载新的图片
            if selectedAlbum != nil || selectedSong != nil {
                imageLoader.loadImage(from: selectedAlbum, from: selectedSong)
                if selectedAlbum != nil {
                    songsLoader.loadSongs(from: selectedAlbum)
                }
            } else {
                // 否则使用现有的图片
                imageLoader.setExistingImage(widgetData.artworkImage)
            }
        }
        .safeAreaInset(edge: .bottom) {
            FloatingAddButton(
                title: "更新小组件",
                isLoading: isUpdating,
                isDisabled: imageLoader.isLoading,
                action: updateWidget
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .alert("更新成功", isPresented: $showSuccessAlert) {
            Button("确定") {
                dismiss()
            }
        } message: {
            Text("小组件已成功更新！")
        }
        .alert("删除小组件", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                deleteWidget()
            }
        } message: {
            Text("确定要删除这个小组件吗？此操作无法撤销。")
        }
    }
    
    // MARK: - 更新小组件
    private func updateWidget() {
        guard !isUpdating else { return }
        
        isUpdating = true
        
        Task {
            do {
                // 更新 widget 数据
                if let album = selectedAlbum {
                    // 如果选择了新的专辑，更新专辑信息
                    widgetData.albumId = album.id.rawValue
                    widgetData.albumTitle = album.title
                    widgetData.artistName = album.artistName
                    widgetData.albumArtistName = album.artistName
                    widgetData.name = album.title
                    
                    // 清除歌曲信息
                    widgetData.songId = nil
                    widgetData.songTitle = nil
                } else if let song = selectedSong {
                    // 如果选择了新的歌曲，更新歌曲信息
                    widgetData.songId = song.id.rawValue
                    widgetData.songTitle = song.title
                    widgetData.artistName = song.artistName
                    widgetData.name = song.title
                    
                    // 清除专辑信息
                    widgetData.albumId = nil
                    widgetData.albumTitle = nil
                    widgetData.albumArtistName = nil
                }
                
                // 更新显示设置
                widgetData.showInfo = showInfo
                
                // 更新封面图片（如果有新的）
                if let newImage = imageLoader.albumImage {
                    widgetData.updateArtwork(newImage)
                }
                
                // 保存更新
                dataManager.updateWidget(widgetData)
                
                await MainActor.run {
                    self.isUpdating = false
                    self.showSuccessAlert = true
                    print("成功更新小组件: \(widgetData.displayTitle)")
                }
            } catch {
                await MainActor.run {
                    self.isUpdating = false
                    print("更新小组件失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - 删除小组件
    private func deleteWidget() {
        dataManager.deleteWidget(widgetData)
        dismiss()
    }
}

#Preview {
    NavigationView {
        AlbumWidgetUpdateView(
            widgetData: AlbumWidgetData(
                name: "示例专辑",
                albumTitle: "示例专辑",
                artistName: "示例艺术家",
                showInfo: true
            )
        )
    }
}

