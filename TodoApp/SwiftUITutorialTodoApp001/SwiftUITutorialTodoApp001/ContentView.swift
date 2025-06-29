//
//  ContentView.swift
//  SwiftUITutorialTodoApp001
//
//  Created by Mason Sun on 2024/12/23.
//

import SwiftUI

// 1. 完善 TodoView: 优化整个 TodoView 的 UI, 并且实现点击动画, 和完成效果
// 2. 完善 Todo List
// 3. 添加编辑和创建页面

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
