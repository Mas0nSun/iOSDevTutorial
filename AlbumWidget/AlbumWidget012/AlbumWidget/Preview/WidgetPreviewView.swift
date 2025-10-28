//
//  WidgetPreviewView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/23.
//

import SwiftUI

struct WidgetPreviewView: View {
    @State private var showSearchView = false
    /// 如果我们要 sheet 出一个页面, 我们有 2 种做法
    /// 1. 使用 Binding<Bool>, showUpdateView: Bool
    /// 2. 使用 Binding<Item>, selectedWidgetForUpdate: AlbumWidgetData
    @State private var selectedWidgetForUpdate: AlbumWidgetData?
    @StateObject private var dataManager = WidgetDataManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if dataManager.widgets.isEmpty {
                    emptyStateView
                } else {
                    widgetsGridView
                }
            }
            .navigationTitle("我的小组件")
            .navigationBarTitleDisplayMode(.large)
            .safeAreaInset(edge: .bottom) {
                if !dataManager.widgets.isEmpty {
                    FloatingAddButton(
                        title: "添加小组件",
                        action: {
                            showSearchView = true
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
        }
        .sheet(isPresented: $showSearchView) {
            SearchAlbumView()
        }
        .sheet(item: $selectedWidgetForUpdate) { widget in
            NavigationView {
                AlbumWidgetUpdateView(widgetData: widget)
            }
        }
    }
    
    
    // MARK: - 空状态视图
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "music.note.house")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("还没有小组件")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("点击下方按钮添加你的第一个音乐小组件")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // 添加按钮
            FloatingAddButton(
                title: "添加小组件",
                action: {
                    showSearchView = true
                }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - 小组件网格视图
    private var widgetsGridView: some View {
        GeometryReader { geometry in
            ScrollView {
                let availableWidth = geometry.size.width - 32 // 减去左右 padding (16 * 2)
                let spacing: CGFloat = 24
                let calculatedWidth = (availableWidth - spacing) / 2 // 减去中间间距后平分
                
                // 设置最小和最大尺寸限制
                let minSize: CGFloat = 100
                let maxSize: CGFloat = 200
                let itemWidth = max(minSize, min(maxSize, calculatedWidth))
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: spacing) {
                    ForEach(dataManager.widgets, id: \.id) { widget in
                        WidgetCardView(
                            widget: widget, 
                            size: itemWidth,
                            onLongPress: {
                                selectedWidgetForUpdate = widget
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
    }
    
}

// MARK: - 小组件卡片视图
struct WidgetCardView: View {
    let widget: AlbumWidgetData
    let size: CGFloat
    let onLongPress: () -> Void
    @State private var isPressed = false
    @StateObject private var dataManager = WidgetDataManager.shared
    
    var body: some View {
        AlbumWidgetView(
            isWidget: false,
            albumImage: widget.artworkImage,
            showInfo: widget.showInfo,
            title: widget.displayTitle,
            artist: widget.displayArtist
        )
        .frame(width: size, height: size)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            // TODO: 实现播放功能
            dataManager.markAsPlayed(widget)
        }
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {
            onLongPress()
        }
    }
}

#Preview {
    WidgetPreviewView()
}
