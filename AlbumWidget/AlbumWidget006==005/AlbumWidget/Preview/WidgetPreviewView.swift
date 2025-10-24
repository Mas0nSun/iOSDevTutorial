//
//  WidgetPreviewView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/23.
//

import SwiftUI

struct WidgetPreviewView: View {
    @State private var showSearchView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 主标题
                VStack(spacing: 16) {
                    Text("欢迎使用相册小部件应用！")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("引导页已完成，现在进入主应用流程")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // 小部件预览区域
                VStack(spacing: 16) {
                    Text("小部件预览")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // 这里可以添加小部件的预览
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "music.note.house")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("小部件预览")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text("选择专辑后，小部件将显示在这里")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // 添加小组件按钮
                Button(action: {
                    showSearchView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("添加小组件")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationTitle("主页面")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showSearchView) {
            SearchAlbumView()
        }
    }
}

#Preview {
    WidgetPreviewView()
}
