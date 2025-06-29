//
//  TodoStore.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import Foundation

// Model: Struct 可以统称为 model
struct Todo: Identifiable {
    // UUID 就是系统会帮我们生成一个不会重复的 String
    var id: UUID = UUID()
    
    var emoji: String
    var title: String
    var dueDate: Date
    var isDone: Bool
}

@Observable // swift macro
class TodoStore {
    // 变更这个数组的时候, 并没有做持久化的操作
    var todos: [Todo] = []
    
    init() {
        // 每次打开 App 的时候, 都会是这 3 条
        //
        todos = [
            .init(emoji: "⌨️", title: "写代码", dueDate: .now, isDone: false),
            .init(emoji: "📚", title: "读书", dueDate: .now, isDone: false),
            .init(emoji: "🏊‍♀️", title: "去游泳", dueDate: .now, isDone: false),
        ]
    }
    
    func add(todo: Todo) {
        todos.append(todo)
    }
    
    func update(todo: Todo) {
        // 找到已存在的 todo 的 index
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            return
        }
        todos[index] = todo
    }
    
    func delete(todo: Todo) {
        // 找到已存在的 todo 的 index
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            return
        }
        todos.remove(at: index)
    }
    
    func moveTodos(fromOffsets: IndexSet, toOffset: Int) {
        todos.move(
            fromOffsets: fromOffsets,
            toOffset: toOffset
        )
    }
    
    // 找到 store 中的某条 todo, 然后把 isDone 设置成 true
    // 如果是 true 的话就改为 false
    func toggleTodoDone(id: UUID) {
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
