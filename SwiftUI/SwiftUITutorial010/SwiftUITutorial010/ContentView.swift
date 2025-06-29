//
//  ContentView.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

// Todo

// todos: [1, 2, 3, 4]
// TodoList: 负责展示 todos
// TodoAddView: 需要将新的 todo 添加到 todos (去重复)
// TodoEditView: 需要编辑 todos 中的某条 (多条) 数据
// TodoSortView: 需要对 todos 进行排序

// Binding 去层层传递

// 比如增删改查 (调 API, 同步用户数据到后台), 都放到一个 class 中
// 这些业务层级的页面全都会引用这个 class

// 观察者机制
// class 有点像车子的触控屏幕

// 维护 todos 的业务操作

// SwiftUI
// 2 套方法
// iOS 17 之后一套:
//
//
//
// iOS 17 之前一套:
//
//
//
// 他们其实都可以用, 就像去上班, 坐公交, 坐地铁都没问题

struct ContentView: View {
//    @State
    // 标记一些 class, 同时需要他们遵守 ObservableObject 协议
    @State var todoStore = TodoStore()
    
    // Binding (子层级) 和 State (父层级)
//    @ObservedObject
    
    var body: some View {
        TodoList()
            .environment(todoStore)
    }
}

//

#Preview {
    ContentView()
}


// 总结一下:
// SwiftUI
// 2 套方法
// iOS 17 之后一套:
// 在 class 前面用 @Observable 修饰 (属性无需额外管理, SwiftUI 对性能做了优化)
// 使用的时候父层级用 @State 修饰, 子层级用 @Environment(XXXX.self), 需要使用 .environment(注入)
//
// iOS 17 之前一套:
// 需要让 class 遵守 ObservableObject 协议, 同时需要观察的属性用 @Published 修饰
// 使用的时候父视图用 @StateObject 修饰, 子视图用 @ObservedObject 修饰, 也可用 @EnvrionmentObject 修饰 (但要注意用 .environmentObject 传值)
//

