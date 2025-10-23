//
//  ContentView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/8/29.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    
    var body: some View {
        if showOnboarding {
            OnboardingManager(onComplete: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOnboarding = false
                }
            })
        } else {
            // 主应用界面
            VStack {
                Text("欢迎使用相册小部件应用！")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("引导页已完成，现在进入主应用流程")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    ContentView()
}
