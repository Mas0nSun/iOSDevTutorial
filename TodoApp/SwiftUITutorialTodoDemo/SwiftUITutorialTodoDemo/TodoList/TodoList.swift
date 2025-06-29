//
//  TodoList.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

struct TodoList: View {
    @Bindable var todoStore: TodoStore
    @State private var editingTodo: Todo?
    
    var body: some View {
        List {
            ForEach($todoStore.todos) { todo in
                TodoView(todo: todo)
                    .swipeActions(edge: .leading) {
                        Button("Edit") {
                            editingTodo = todo.wrappedValue
                        }
                        .tint(.accent)
                    }
            }
            .onDelete { indexSet in
                todoStore.deleteTodos(indexSet: indexSet)
            }
            .onMove { from, to in
                todoStore.moveTodos(
                    fromOffsets: from,
                    toOffset: to
                )
            }
        }
        .sheet(item: $editingTodo) { todo in
            TodoEditView(todo: todo) { newTodo in
                // 更新 todo
                todoStore.updateTodo(newTodo)
            }
        }
    }
}
