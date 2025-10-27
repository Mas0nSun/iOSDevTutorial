//
//  AlbumWidgetView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/24.
//

import SwiftUI

struct AlbumWidgetView: View {
    // 可配置参数
    let albumImage: UIImage?
    let showInfo: Bool
    let title: String?
    let artist: String?
    
    init(albumImage: UIImage? = nil, showInfo: Bool = false, title: String? = nil, artist: String? = nil) {
        self.albumImage = albumImage
        self.showInfo = showInfo
        self.title = title
        self.artist = artist
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            // 毛玻璃背景
            backgroundLayer(size: size)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .overlay(alignment: .bottom) {
                    // 前景视图
                    foregroundView(size: size)
                }
                .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - 毛玻璃背景层
    private func backgroundLayer(size: CGFloat) -> some View {
        ZStack {
            // 背景图片
            if let albumImage = albumImage {
                Image(uiImage: albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
            } else {
                // 默认渐变背景
                LinearGradient(
                    colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            // 使用 SwiftUI Material 实现毛玻璃效果
            Rectangle()
                .fill(.regularMaterial)
                // .opacity(0.9)
        }
    }
    
    private func foregroundView(size: CGFloat) -> some View {
        // 唱片 + 作者 + title
        VStack(spacing: 0) {
            // 唱片区域 - 保持原始大小
            ZStack {
                // 唱片效果层
                vinylRecordLayer(size: size)
                
                // 中心封面图片
                centerAlbumCover(size: size)
            }
            .frame(width: size, height: size)
            
            // 信息显示区域
            if showInfo {
                infoSection(size: size)
                    .padding(.bottom, 8) // 距离底部 8 的 padding
            }
        }
    }
    
    // MARK: - 唱片效果层
    private func vinylRecordLayer(size: CGFloat) -> some View {
        ZStack {
            // 黑色唱片背景 - 使用比例 0.85
            Circle()
                .fill(Color.black)
                .frame(width: size * 0.85, height: size * 0.85)
            
            // 唱片圆环纹理 - 动态计算圆环数量和间距
            let ringCount = max(15, Int(size / 10)) // 根据尺寸动态调整圆环数量
            let ringSpacing = size * 0.85 / CGFloat(ringCount) // 动态计算间距
            
            ForEach(0..<ringCount, id: \.self) { index in
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    .frame(
                        width: size * 0.85 - CGFloat(index) * ringSpacing,
                        height: size * 0.85 - CGFloat(index) * ringSpacing
                    )
            }
            
            // 左右两侧光晕效果
            HStack {
                // 左侧光晕
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.white.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.4, height: size * 0.4)
                    .offset(x: -size * 0.15)
                
                Spacer()
                
                // 右侧光晕
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.white.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.4, height: size * 0.4)
                    .offset(x: size * 0.15)
            }
            .frame(width: size * 0.85, height: size * 0.85)
        }
    }
    
    // MARK: - 中心封面图片
    private func centerAlbumCover(size: CGFloat) -> some View {
        Group {
            if let albumImage = albumImage {
                Image(uiImage: albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size * 0.3, height: size * 0.3)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: max(1, size * 0.01))
                    )
            } else {
                // 默认封面
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.red, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.3, height: size * 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: max(1, size * 0.01))
                    )
            }
        }
    }
    
    // MARK: - 信息显示区域
    private func infoSection(size: CGFloat) -> some View {
        VStack(spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            if let artist = artist {
                Text(artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: size * 0.8)
        .padding(.horizontal, 8)
    }
}

#Preview {
    VStack(spacing: 24) {
        // 不显示信息的版本
        AlbumWidgetView(albumImage: UIImage(named: "widget-cover-preview"))
            .frame(width: 50, height: 50)
        
        // 显示信息的版本
        AlbumWidgetView(
            albumImage: UIImage(named: "widget-cover-preview"),
            showInfo: true,
            title: "专辑名称",
            artist: "艺术家名称"
        )
        .frame(width: 150, height: 150)
        
        AlbumWidgetView(
            albumImage: UIImage(named: "widget-cover-preview"),
            showInfo: false,
            title: "专辑名称",
            artist: "艺术家名称"
        )
        .frame(width: 150, height: 150)
        
        // 大尺寸显示信息版本
        AlbumWidgetView(
            albumImage: UIImage(named: "widget-cover-preview"),
            showInfo: true,
            title: "很长的专辑名称测试",
            artist: "很长的艺术家名称测试"
        )
        .frame(width: 200, height: 200)
    }
}
