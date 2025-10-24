//
//  WelcomeView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/20.
//

import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 照片墙区域 - 填充上部分内容
            photoWallView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // 标题和按钮区域 - 自适应高度
            contentView
                .frame(maxWidth: .infinity)
        }
    }
    
    // 照片墙视图
    private var photoWallView: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(200), spacing: 20), count: 5), spacing: 20) {
                ForEach(0..<15, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colors[index % colors.count])
                        .frame(width: 200, height: 200)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
                        .rotationEffect(.degrees(15))
                }
            }
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
            .clipped() // 裁剪超出容器的部分
        }
    }
    
    // 内容区域视图
    private var contentView: some View {
        BottomContentView.default(
            title: "欢迎使用相册小部件",
            subtitle: "创建精美的相册小部件，让回忆触手可及",
            buttonTitle: "继续",
            buttonAction: onContinue
        )
    }
    
    // 颜色数组用于照片墙
    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple,
        .pink, .cyan, .mint, .indigo, .brown, .gray
    ]
}

#Preview {
    WelcomeView(onContinue: {})
}
