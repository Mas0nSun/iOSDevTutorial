//
//  ContentView.swift
//  SwiftUITutorial012
//
//  Created by Mason Sun on 2024/12/19.
//

import SwiftUI

struct ContentView: View {
    // 用 navigationLink 可以不用次 bool 值
    @State var isShowingBlueView = false
    // 2, 3 跳转必须要实现的变量
    @State var isShowingYellowView = false
    @State var isShowingRedView = false
    
    var body: some View {
        // 页面1 -> 页面2
        // TodoList -> TodoEdit
        // TodoList -> TodoAdd
        // 1. 页面从右侧滑动出现 (同时左上角有一个返回按钮), 我们可以通过侧滑手势返回 (preview + 模拟器都不太好使, iPhone 没问题)
        
        // 2. 页面从底部弹出 (一般会盖住部分, 顶部会看到上层级视图), 用户可以下拉关闭
        
        // 3. 整个页面被盖住, 不支持任何手势操作返回
        NavigationStack {
            VStack(spacing: 16) {
                // List 里有一些系统自带的样式
                NavigationLink("我要跳转到蓝色页面") {
                    BluePage()
                }
                
                Button {
                    // 导航栈: Navigation
                    // 1/2/3/4/5
                    isShowingBlueView.toggle()
                } label: {
                    Text("用第一种方式跳转")
                }
                
                // Sheet
                Button {
                    isShowingYellowView.toggle()
                } label: {
                    Text("用第二种方式跳转")
                }
                
                Button {
                    isShowingRedView.toggle()
                } label: {
                    Text("用第三种方式跳转")
                }
            }
            .padding()
            .navigationTitle("Content View")
            // Navigation
            .navigationDestination(
                isPresented: $isShowingBlueView,
                destination: {
                    BluePage()
                }
            )
            // Sheet
            .sheet(
                isPresented: $isShowingYellowView,
                content: {
                    YellowPage()
                }
            )
            // fullScreenCover
            .fullScreenCover(
                isPresented: $isShowingRedView,
                content: {
                    RedPage()
                }
            )
        }
    }
}

// 1.
struct BluePage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Color.blue
            .ignoresSafeArea()
            .opacity(0.5)
            .onTapGesture {
                dismiss()
            }
    }
}

// 2.
struct YellowPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Color.yellow
            .frame(width: 24)
//            .ignoresSafeArea()
//            .onTapGesture {
//                dismiss()
//            }
    }
}

// 3.
struct RedPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Color.red
            .frame(width: 24)
    }
}


#Preview {
    ContentView()
}
