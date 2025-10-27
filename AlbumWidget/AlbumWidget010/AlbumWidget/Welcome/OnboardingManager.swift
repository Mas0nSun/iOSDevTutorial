//
//  OnboardingManager.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/21.
//

import SwiftUI

struct OnboardingManager: View {
    @State private var currentPage: OnboardingPage = .welcome
    @State private var offset: CGFloat = 0
    @StateObject private var musicKitManager = MusicKitManager.shared
    let onComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // 欢迎页面
                WelcomeView(onContinue: nextPage)
                    .frame(width: geometry.size.width)
                    .offset(x: offset)
                
                // 音乐权限页面
                MusicPermissionView(
                    onContinue: {
                        // 处理权限请求
                        handleMusicPermissionRequest()
                    },
                    onBack: previousPage
                )
                    .frame(width: geometry.size.width)
                    .offset(x: offset)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        // 裁剪超出容器的内容
        // .clipped()
        .onAppear {
            // 初始化时确保第二个页面在右侧
            offset = 0
        }
    }
    
    // 页面枚举
    enum OnboardingPage {
        case welcome
        case musicPermission
    }
    
    // 跳转到下一个页面
    private func nextPage() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
            offset = -UIScreen.main.bounds.width
            currentPage = .musicPermission
        }
    }
    
    // 返回上一个页面
    private func previousPage() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
            offset = 0
            currentPage = .welcome
        }
    }
    
    // 处理音乐权限请求
    private func handleMusicPermissionRequest() {
        // 如果已经授权，直接完成引导
        if musicKitManager.isAuthorized {
            onComplete()
            return
        }
        
        // 如果权限被拒绝，显示设置引导
        if musicKitManager.shouldGuideToSettings {
            // 保持当前页面，让用户看到设置引导
            return
        }
        
        // 请求权限
        Task {
            await musicKitManager.requestMusicPermission()
            
            // 检查授权结果
            if musicKitManager.isAuthorized {
                // 授权成功，直接跳转到主页面
                onComplete()
            }
            // 如果授权失败，保持在当前页面显示错误信息
        }
    }
}

#Preview {
    OnboardingManager(onComplete: {})
}
