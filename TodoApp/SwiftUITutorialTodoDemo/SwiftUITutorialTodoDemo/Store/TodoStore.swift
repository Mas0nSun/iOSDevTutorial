//
//  TodoStore.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import Foundation
import SwiftData

@Observable
class TodoStore {
    var todos: [Todo] = [] {
        didSet {
            saveTodos()
        }
    }

    init() {
        loadTodos()
    }
    
    func saveTodos() {
        guard let data = try? JSONEncoder().encode(todos) else {
            return
        }
        let url = URL.documentsDirectory.appending(path: "Todos")
//        FileManager.default.createFile(atPath: <#T##String#>, contents: <#T##Data?#>)
        try? data.write(to: url)
        print("Save Done")
    }
    
    func loadTodos() {
        let url = URL.documentsDirectory.appending(path: "Todos")
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        self.todos = try! JSONDecoder().decode([Todo].self, from: data)
        print("\(todos)")
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        // 调用 API 更新用户的数据
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(where: {
            $0.id == todo.id
        }) else {
            return
        }
        todos[index] = todo
        // 调用 API 更新用户的数据
    }
    
    func deleteTodos(indexSet: IndexSet) {
        todos.remove(atOffsets: indexSet)
        // 调用 API 更新用户的数据
    }
    
    func moveTodos(fromOffsets: IndexSet, toOffset: Int) {
        todos.move(fromOffsets: fromOffsets, toOffset: toOffset)
        // 调用 API 更新用户的数据
    }
}
