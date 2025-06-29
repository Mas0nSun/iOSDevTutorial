//
//  TodoStore.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import Foundation

struct Todo: Identifiable {
    var id: String {
        title
    }
    
    var emoji: String
    var title: String
    var isDone: Bool
}

// iOS 17 之前的方法
// 一旦遵守了 ObservableObject 协议, 它就有了被观察的能力
//class TodoStore: ObservableObject {
//    // 标记为变化后, View 需要刷新的
//    @Published var todos: [Todo] = []
//    
//    //
//    //
//    //
//    
//    init() {
//        todos = [
//            .init(emoji: "⌨️", title: "写代码", isDone: false),
//            .init(emoji: "📚", title: "读书", isDone: false),
//        ]
//    }
//    
//    func addTodo(_ name: String) {
//        
//    }
//    
//    func updateTodo(_ name: String, changedName: String) {
//        
//    }
//    
//    func deleteTodo(_ name: String) {
//        
//    }
//    
//    func sort() {
//        
//    }
//    
//    // 找到 store 中的某条 todo, 然后把 isDone 设置成 true
//    // 如果是 true 的话就改为 false
//    func toggleTodoDone(id: String) {
//        let index = todos.firstIndex(where: {
//            // 通过某个值去找到 todos 中的这条数据的 index
//            $0.id == id
//        })
//        // 如果找到 todo 的话
//        if let index {
//            var todo = todos[index]
//            // 切换 isDone: 如果是 ture 改为 false, 否则改为 ture
//            todo.isDone.toggle()
//            todos[index] = todo
//        }
//    }
//}

// iOS 17 之后的方法
@Observable // swift macro
class TodoStore {
    // 标记为变化后, View 需要刷新的
    var todos: [Todo] = []
    
    //
    //
    //
    
    init() {
        todos = [
            .init(emoji: "⌨️", title: "写代码", isDone: false),
            .init(emoji: "📚", title: "读书", isDone: false),
        ]
    }
    
    // 找到 store 中的某条 todo, 然后把 isDone 设置成 true
    // 如果是 true 的话就改为 false
    func toggleTodoDone(id: String) {
        let index = todos.firstIndex(where: {
            // 通过某个值去找到 todos 中的这条数据的 index
            $0.id == id
        })
        // 如果找到 todo 的话
        if let index {
            var todo = todos[index]
            // 切换 isDone: 如果是 ture 改为 false, 否则改为 ture
            todo.isDone.toggle()
            todos[index] = todo
        }
    }
}
