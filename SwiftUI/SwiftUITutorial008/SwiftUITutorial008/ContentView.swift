//
//  ContentView.swift
//  SwiftUITutorial008
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

struct ContentView: View {
    // property wrapper: 属性包装器
    // 实现了封装常用功能的作用
    
    // 比如你想要更改某个字段的时候, 就需要用 State 修饰这个属性
    // 会维护当前 View 中字段的状态, 它是独立于父视图的
    // 子视图内部用 Binding, 父视图/最外层用 State
    @State var isDone: Bool = false
    
    @State var isDisabled: Bool = true
    
    // 让子视图和父视图实现了双向绑定, 两边的数据源都是同步的, 同时子视图可以更改这个属性
    // Binding 常用于封装一些可以自己控制状态的组件, 比如: Toggle, TodoView
//    @Binding var
    
    var body: some View {
        VStack {
            TodoView(
                emoji: "⌨️",
                title: "写代码",
                isDone: $isDone
            )
            Toggle(
                "Toggle",
                isOn: $isDone
            )
        }
        .padding(.horizontal)
        Button {
            print("Content View 中 isDone: \(isDone)")
        } label: {
            Text("打印 isDone")
        }
    }
}

struct TodoView: View {
    let emoji: String
    let title: String
    // 子视图不维护这个状态, 同时我能更改他, 但需要上层去维护
    @Binding var isDone: Bool
    
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
        // 标记整个 Todo 都是可点击的
        .contentShape(Rectangle())
        .onTapGesture {
            // 可以将 bool 值变成反的 (反转一个 bool)
            // true -> false, false -> true
            isDone.toggle()
        }
    }
}

#Preview {
    ContentView()
        .disabled(true)
}
