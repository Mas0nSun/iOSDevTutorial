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
                        // 模拟权限请求成功
                        requestMusicPermission()
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
    
    // 模拟音乐权限请求
    private func requestMusicPermission() {
        // 模拟权限请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 模拟权限请求成功
            print("音乐权限请求成功")
            onComplete()
        }
    }
}

#Preview {
    OnboardingManager(onComplete: {})
}
