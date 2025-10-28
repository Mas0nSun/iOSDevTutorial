//
//  AlbumWidgetSharedComponents.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/27.
//

import SwiftUI
import MusicKit
import Combine
import WidgetKit

// MARK: - 小组件预览区域
struct WidgetPreviewSection: View {
    let albumImage: UIImage?
    @Binding var showInfo: Bool
    let title: String?
    let artist: String?
    @State private var selectedSize: WidgetSize = .medium
    
    enum WidgetSize: String, CaseIterable {
        case small = "小"
        case medium = "中"
        case large = "大"
        
        var widgetFamily: WidgetKit.WidgetFamily {
            switch self {
            case .small:
                return .systemSmall
            case .medium:
                return .systemMedium
            case .large:
                return .systemLarge
            }
        }
        
        var previewSize: CGSize {
            switch self {
            case .small:
                return CGSize(width: 180, height: 180)
            case .medium:
                return CGSize(width: 300, height: 150)
            case .large:
                return CGSize(width: 250, height: 250)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 小组件预览
            widgetPreview
            
            // 控制选项
            controlOptions

            // 尺寸选择器
            sizeSelector
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    // MARK: - 尺寸选择器
    private var sizeSelector: some View {
        HStack(spacing: 8) {
            Text("Widget 尺寸")
            Spacer()
            Picker("Widget 尺寸", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.rawValue).tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            // 强制让 picker 根据自己的文本来定宽, 而不是撑满容器
            .fixedSize(
                horizontal: true,
                vertical: false
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Widget 预览
    private var widgetPreview: some View {
        VStack(spacing: 12) {
            // Widget 预览卡片
            AlbumWidgetView(
                isWidget: false,
                albumImage: albumImage,
                showInfo: showInfo,
                title: title,
                artist: artist,
                widgetFamily: selectedSize.widgetFamily
            )
            .frame(
                width: selectedSize.previewSize.width,
                height: selectedSize.previewSize.height
            )
        }
    }
    
    // MARK: - 控制选项
    private var controlOptions: some View {
        VStack(spacing: 12) {
            // 显示信息开关
            Toggle("显示歌曲信息", isOn: $showInfo)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // 尺寸说明
            sizeDescription
        }
    }
    
    // MARK: - 尺寸说明
    private var sizeDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("尺寸说明")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(descriptionForSize(selectedSize))
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
    
    private func descriptionForSize(_ size: WidgetSize) -> String {
        switch size {
        case .small:
            return "小尺寸 Widget：只显示专辑封面，适合快速查看"
        case .medium:
            return "中等尺寸 Widget：左右布局，封面在右，信息在左"
        case .large:
            return "大尺寸 Widget：上下布局，封面在上，信息在下"
        }
    }
}

// MARK: - 歌曲列表区域
struct SongsListSection: View {
    let album: Album
    let albumSongs: [Track]
    let isLoadingSongs: Bool
    
    var body: some View {
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
                loadingPlaceholder
            } else if !albumSongs.isEmpty {
                songsList
            } else {
                emptyState
            }
        }
    }
    
    // 加载占位符
    private var loadingPlaceholder: some View {
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
    }
    
    // 歌曲列表
    private var songsList: some View {
        LazyVStack(spacing: 0) {
            ForEach(albumSongs, id: \.id) { track in
                SongRowView(track: track)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
            }
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // 空状态
    private var emptyState: some View {
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

// MARK: - 歌曲行视图
struct SongRowView: View {
    let track: Track
    
    var body: some View {
        HStack(spacing: 12) {
            // 歌曲名称
            Text(track.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Spacer()
            
            // 歌曲时长
            Text(formatDuration(track.duration))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // 格式化时长
    private func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "--:--" }
        
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - 功能行组件
struct FeatureRow: View {
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

// MARK: - 图片加载辅助类
class AlbumImageLoader: ObservableObject {
    @Published var albumImage: UIImage?
    @Published var isLoading = false
    
    func loadImage(from album: Album? = nil, from song: Song? = nil) {
        isLoading = true
        
        Task {
            do {
                let image: UIImage?
                
                if let album = album {
                    image = try await loadImage(from: album.artwork?.url(width: 300, height: 300))
                } else if let song = song {
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
    
    func setExistingImage(_ image: UIImage?) {
        albumImage = image
    }
    
    private func loadImage(from url: URL?) async throws -> UIImage? {
        guard let url = url else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}

// MARK: - 专辑歌曲加载器
class AlbumSongsLoader: ObservableObject {
    @Published var albumSongs: [Track] = []
    @Published var isLoadingSongs = false
    
    func loadSongs(from album: Album?) {
        guard let album = album else { return }
        
        isLoadingSongs = true
        
        Task {
            do {
                let tracks = try await MusicKitManager.shared.getAlbumSongs(album: album)
                await MainActor.run {
                    self.albumSongs = Array(tracks)
                    self.isLoadingSongs = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingSongs = false
                }
            }
        }
    }
}

