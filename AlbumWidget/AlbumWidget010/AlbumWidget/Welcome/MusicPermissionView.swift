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
    
    @StateObject private var musicKitManager = MusicKitManager.shared
    
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
            buttonTitle: buttonTitle,
            buttonAction: handleButtonAction
        )
        .overlay(
            // 错误信息提示
            errorOverlay
        )
    }
    
    // 按钮标题
    private var buttonTitle: String {
        if musicKitManager.isRequestingPermission {
            return "请求权限中..."
        } else if musicKitManager.isAuthorized {
            return "继续"
        } else if musicKitManager.shouldGuideToSettings {
            return "前往设置"
        } else {
            return "Apple Music"
        }
    }
    
    // 处理按钮点击
    private func handleButtonAction() {
        if musicKitManager.isAuthorized {
            onContinue()
        } else if musicKitManager.shouldGuideToSettings {
            musicKitManager.openAppSettings()
        } else {
            // 只请求权限，不自动跳转
            // 跳转逻辑由 OnboardingManager 处理
            Task {
                await musicKitManager.requestMusicPermission()
            }
        }
    }
    
    // 错误信息覆盖层
    @ViewBuilder
    private var errorOverlay: some View {
        if let errorMessage = musicKitManager.errorMessage {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                    Button("关闭") {
                        musicKitManager.clearError()
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MusicPermissionView(onContinue: {}, onBack: {})
}
