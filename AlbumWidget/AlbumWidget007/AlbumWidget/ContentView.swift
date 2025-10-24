//
//  ContentView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/8/29.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    @State private var hasCheckedInitialAuth = false
    @StateObject private var musicKitManager = MusicKitManager.shared
    
    // 判断是否应该显示引导页面
    private var shouldShowOnboarding: Bool {
        // 如果用户手动完成了引导，不再显示
        if !showOnboarding {
            return false
        }
        
        // 如果 MusicKit 已经授权，直接进入主页面（不显示 welcome）
        if musicKitManager.isAuthorized {
            return false
        }
        
        // 其他情况显示引导页面
        return true
    }
    
    var body: some View {
        Group {
            if shouldShowOnboarding {
                OnboardingManager(onComplete: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showOnboarding = false
                    }
                })
            } else {
                // 主应用界面
                WidgetPreviewView()
            }
        }
        .onAppear {
            // 检查初始授权状态
            checkInitialAuthStatus()
        }
    }
    
    // 检查初始授权状态
    private func checkInitialAuthStatus() {
        // 如果已经授权，直接设置状态（不显示 welcome，无动画）
        if musicKitManager.isAuthorized {
            showOnboarding = false
            hasCheckedInitialAuth = true
        } else {
            hasCheckedInitialAuth = true
        }
    }
}

#Preview {
    ContentView()
}
