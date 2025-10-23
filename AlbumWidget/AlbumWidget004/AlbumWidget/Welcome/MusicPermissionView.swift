//
//  MusicPermissionView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/21.
//

import SwiftUI

struct MusicPermissionView: View {
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 渐变背景区域 - 填充上部分内容
            gradientBackgroundView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .overlay(
                    // 返回按钮
                    VStack {
                        HStack {
                            Button(action: onBack) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Text("返回")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Capsule())
                            }
                            .padding(.top, 50)
                            .padding(.leading, 20)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                )
            
            // 标题和按钮区域 - 自适应高度
            contentView
                .frame(maxWidth: .infinity)
        }
    }
    
    // 渐变背景视图
    private var gradientBackgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.3),
                Color(red: 0.2, green: 0.1, blue: 0.4),
                Color(red: 0.3, green: 0.2, blue: 0.5),
                Color(red: 0.4, green: 0.3, blue: 0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            // 添加一些光效
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 300
            )
        )
    }
    
    // 内容区域视图
    private var contentView: some View {
        BottomContentView.appleMusic(
            title: "音乐权限",
            subtitle: "允许访问您的音乐库，为您创建个性化的相册小部件",
            buttonTitle: "Apple Music",
            buttonAction: onContinue
        )
    }
}

#Preview {
    MusicPermissionView(onContinue: {}, onBack: {})
}
