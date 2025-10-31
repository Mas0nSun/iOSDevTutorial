//
//  AlbumWidgetView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/24.
//

import SwiftUI
import WidgetKit

struct AlbumWidgetView: View {
    // 是否在 widget extension 中展示
    // false: 是在 app 内
    // true: 是在 widget extension 中
    let isWidget: Bool
    // 可配置参数
    let albumImage: UIImage?
    let showInfo: Bool
    let title: String?
    let artist: String?
    // Widget 尺寸信息（可选，仅在 Widget 中使用）
    let widgetFamily: WidgetFamily?
    
    init(
        isWidget: Bool,
        albumImage: UIImage? = nil,
        showInfo: Bool = false,
        title: String? = nil,
        artist: String? = nil,
        widgetFamily: WidgetFamily? = nil
    ) {
        self.isWidget = isWidget
        self.albumImage = albumImage
        self.showInfo = showInfo
        self.title = title
        self.artist = artist
        self.widgetFamily = widgetFamily
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            // 毛玻璃背景
            if isWidget {
                // 小组件分支
                Color.clear
                    .overlay(alignment: .bottom) {
                        // 前景视图
                        foregroundView(size: size)
                    }
                    .containerBackground(for: .widget) {
                        backgroundLayer(width: geometry.size.width, height: geometry.size.height)
                    }
            } else {
                // app 分支
                backgroundLayer(width: geometry.size.width, height: geometry.size.height)
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
    }
    
    // MARK: - 毛玻璃背景层
    private func backgroundLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            // 背景图片
            if let albumImage = albumImage {
                Image(uiImage: albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
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
    
    @ViewBuilder
    private func foregroundView(size: CGFloat) -> some View {
        // 根据 Widget 尺寸调整布局
        if widgetFamily == .systemMedium {
            // Medium 尺寸：左右布局（文本在左，唱片在右）
            mediumLayout(size: size)
        } else {
            // 其他尺寸：上下布局（唱片在上，文本在下）
            verticalLayout(size: size)
        }
    }
    
    // MARK: - 垂直布局（小尺寸和大尺寸）
    private func verticalLayout(size: CGFloat) -> some View {
        VStack(spacing: 4) {
            // 唱片区域 - 保持原始大小
            ZStack {
                // 唱片效果层
                vinylRecordLayer(size: size, isWidget: isWidget)
                
                // 中心封面图片
                centerAlbumCover(size: size, isWidget: isWidget)
            }
            .frame(width: size, height: size)
            
            // 信息显示区域
            if showInfo {
                infoSection(size: size)
                    .padding(.bottom, 8) // 距离底部 8 的 padding
            }
        }
    }
    
    // MARK: - 水平布局（中等尺寸）
    private func mediumLayout(size: CGFloat) -> some View {
        HStack(spacing: 12) {
            // 左侧：文本信息
            if showInfo {
                infoSection(size: size)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // 右侧：唱片
            ZStack {
                // 唱片效果层
                vinylRecordLayer(size: size, isWidget: isWidget)
                
                // 中心封面图片
                centerAlbumCover(size: size, isWidget: isWidget)
            }
            .frame(width: size, height: size)
        }
        .padding(.horizontal, 8)
    }
    
    // MARK: - 唱片效果层
    private func vinylRecordLayer(size: CGFloat, isWidget: Bool) -> some View {
        let recordSize = isWidget ? size : size * 0.85
        return ZStack {
            // 黑色唱片背景
            Circle()
                .fill(Color.black)
                .frame(width: recordSize, height: recordSize)
            
            // 唱片圆环纹理 - 动态计算圆环数量和间距
            let ringCount = max(15, Int(size / 10)) // 根据尺寸动态调整圆环数量
            let ringSpacing = recordSize / CGFloat(ringCount) // 动态计算间距
            
            ForEach(0..<ringCount, id: \.self) { index in
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    .frame(
                        width: recordSize - CGFloat(index) * ringSpacing,
                        height: recordSize - CGFloat(index) * ringSpacing
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
            .frame(width: recordSize, height: recordSize)
        }
    }
    
    // MARK: - 中心封面图片
    private func centerAlbumCover(size: CGFloat, isWidget: Bool) -> some View {
        let coverSize = size * 0.3
        return Group {
            if let albumImage = albumImage {
                Image(uiImage: albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: coverSize, height: coverSize)
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
                    .frame(width: coverSize, height: coverSize)
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
        .padding(.leading, isWidget ? 0 : 4)
    }
}

#Preview {
    VStack(spacing: 24) {
        // 不显示信息的版本
        AlbumWidgetView(
            isWidget: false,
            albumImage: UIImage(named: "widget-cover-preview")
        )
            .frame(width: 50, height: 50)
        
        // 显示信息的版本
        AlbumWidgetView(
            isWidget: false,
            albumImage: UIImage(named: "widget-cover-preview"),
            showInfo: true,
            title: "专辑名称",
            artist: "艺术家名称"
        )
        .frame(width: 150, height: 150)
        
        AlbumWidgetView(
            isWidget: false,
            albumImage: UIImage(named: "widget-cover-preview"),
            showInfo: false,
            title: "专辑名称",
            artist: "艺术家名称"
        )
        .frame(width: 150, height: 150)
        
        // 大尺寸显示信息版本
        AlbumWidgetView(
            isWidget: true,
            albumImage: UIImage(named: "widget-cover-preview"),
            showInfo: true,
            title: "很长的专辑名称测试",
            artist: "很长的艺术家名称测试"
        )
        .frame(width: 200, height: 200)
        .border(.red)
    }
}
