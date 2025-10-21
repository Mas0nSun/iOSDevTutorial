//
//  WelcomeView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/20.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 照片墙区域 - 填充上部分内容
            photoWallView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 标题和按钮区域 - 自适应高度
            contentView
                .frame(maxWidth: .infinity)
        }
    }
    
    // 照片墙视图
    private var photoWallView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(200), spacing: 20), count: 5), spacing: 20) {
            ForEach(0..<15, id: \.self) { index in
                RoundedRectangle(cornerRadius: 16)
                    .fill(colors[index % colors.count])
                    .frame(width: 200, height: 200)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
                    .rotationEffect(.degrees(15))
            }
        }
        .clipped() // 裁剪超出屏幕的部分
    }
    
    // 内容区域视图
    private var contentView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 标题
            Text("欢迎使用相册小部件")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 子标题
            Text("创建精美的相册小部件，让回忆触手可及")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // Continue按钮
            Button(action: {
                // TODO: 添加按钮点击事件
            }) {
                Text("继续")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 34) // 添加底部安全区域边距
    }
    
    // 颜色数组用于照片墙
    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple,
        .pink, .cyan, .mint, .indigo, .brown, .gray
    ]
}

#Preview {
    WelcomeView()
}
