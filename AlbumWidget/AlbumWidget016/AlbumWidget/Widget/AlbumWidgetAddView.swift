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
    
    @StateObject private var imageLoader = AlbumImageLoader()
    @StateObject private var songsLoader = AlbumSongsLoader()
    @State private var showInfo = false
    @State private var isAdding = false
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = WidgetDataManager.shared
    
    init(selectedAlbum: Album? = nil, selectedSong: Song? = nil) {
        self.selectedAlbum = selectedAlbum
        self.selectedSong = selectedSong
    }
    
    var body: some View {
        // 可滚动的主内容
        ScrollView {
            VStack(spacing: 0) {
                // 顶部小组件展示区域
                WidgetPreviewSection(
                    albumImage: imageLoader.albumImage,
                    showInfo: $showInfo,
                    title: selectedAlbum?.title ?? selectedSong?.title,
                    artist: selectedAlbum?.artistName ?? selectedSong?.artistName
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
        .navigationTitle("添加小组件")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            imageLoader.loadImage(from: selectedAlbum, from: selectedSong)
            if selectedAlbum != nil {
                songsLoader.loadSongs(from: selectedAlbum)
            }
        }
        .safeAreaInset(edge: .bottom) {
            FloatingAddButton(
                title: "添加到主屏幕",
                isLoading: isAdding,
                isDisabled: imageLoader.isLoading,
                action: addWidget
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .alert("添加成功", isPresented: $showSuccessAlert) {
            Button("确定") {
                dismiss()
            }
        } message: {
            Text("小组件已成功添加到主屏幕！")
        }
    }
    
    // MARK: - 添加小组件
    private func addWidget() {
        guard !isAdding else { return }
        
        isAdding = true
        
        Task {
            do {
                let widgetData = try await dataManager.addWidget(
                    from: selectedAlbum,
                    from: selectedSong,
                    showInfo: showInfo,
                    artworkImage: imageLoader.albumImage
                )
                
                await MainActor.run {
                    self.isAdding = false
                    self.showSuccessAlert = true
                    print("成功添加小组件: \(widgetData.displayTitle)")
                }
            } catch {
                await MainActor.run {
                    self.isAdding = false
                    print("添加小组件失败: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        AlbumWidgetAddView()
    }
}
