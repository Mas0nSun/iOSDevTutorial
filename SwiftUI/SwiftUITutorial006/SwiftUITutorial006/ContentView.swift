//
//  ContentView.swift
//  SwiftUITutorial006
//
//  Created by Mason Sun on 2024/12/16.
//

import SwiftUI

// Identifiable: 你的 Todo 是唯一的
struct Todo: Identifiable {
    
    var id: String {
        title
    }
    
    var emoji: String
    var title: String
    var isDone: Bool
}

// SwiftUI 中只要你的 struct 遵守了 View 协议, 那么它就是一个视图
// 直接将它放到其他视图的 body 里, 就能直接渲染
struct ContentView: View {
    //
    let todos: [Todo] = [
        .init(emoji: "📚", title: "去读书", isDone: true),
        .init(emoji: "🏊‍♀️", title: "去游泳", isDone: false),
        .init(emoji: "🧑‍🏫", title: "去上课", isDone: false)
    ]
    
    var body: some View {
        // 滚动视图
        // 1. List
        // 有系统提供的 UI, 支持侧滑删除, 拖拽排序, 性能也被系统优化过
        // 2. ScrollView
        // 比较纯粹, 适合自定义 UI, 更轻量, 不会有太多系统层级限制
//        ScrollView {
//            ForEach(todos) { todo in
//                TodoView(
//                    emoji: todo.emoji,
//                    title: todo.title,
//                    isDone: todo.isDone
//                )
//                // 如果这个 todo 不是最后一条, 那我们就加上分隔线
//                if todo.id != todos.last?.id {
//                    Divider()
//                }
//            }
//            .padding(.horizontal, 16)
//        }
        
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                ForEach(todos) { todo in
                    TodoView(
                        emoji: todo.emoji,
                        title: todo.title,
                        isDone: todo.isDone
                    )
                    // 如果这个 todo 不是最后一条, 那我们就加上分隔线
                    if todo.id != todos.last?.id {
                        Divider()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        
        // List 不支持横线滚动, 只有 ScrolView 可以
        ScrollView(.horizontal) {
            HStack {
                ForEach(todos) { todo in
                    TodoView(
                        emoji: todo.emoji,
                        title: todo.title,
                        isDone: todo.isDone
                    )
                    .frame(width: 200)
                    // 如果这个 todo 不是最后一条, 那我们就加上分隔线
                    if todo.id != todos.last?.id {
                        Divider()
                    }
                }
            }
            .frame(height: 60)
        }
        
//        List(todos) { todo in
//            TodoView(
//                emoji: todo.emoji,
//                title: todo.title,
//                isDone: todo.isDone
//            )
//        }
    }
}

// 如何用结构体封装一个视图

struct TodoView: View {
    let emoji: String
    let title: String
    let isDone: Bool
    
    var body: some View {
        HStack {
            Text(emoji)
            Text(title)
            Spacer()
            // 三目运算符
            // true/false ? 1 : 0
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
        }
        //
//        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
}
