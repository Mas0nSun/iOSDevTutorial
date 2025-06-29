//
//  TodoList.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

struct TodoList: View {
    // @Binding: 作用于一些基本数据类型: Todo, Int, Bool
    // @Bindable: 专门给 Observable 的 class 服务的
    @Bindable var todoStore: TodoStore
    
    // 正在编辑的 todo
    @State private var editingTodo: Todo? = nil
    
    var body: some View {
        List {
            ForEach($todoStore.todos) { todo in
                TodoView(todo: todo)
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button("Edit") {
                            editingTodo = todo.wrappedValue
                        }
                        // 改颜色必须要用 
                        .tint(.indigo)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", role: .destructive) {
                            todoStore.delete(
                                todo: todo.wrappedValue
                            )
                        }
                    }
            }
            .onMove { fromOffsets, toOffset in
                // 第一个参数: 用户拖拽的 todo 的 indexSet (可能包含多个 todo 的 index)
                // 第二个参数: 目标的 index
                todoStore.moveTodos(
                    fromOffsets: fromOffsets,
                    toOffset: toOffset
                )
            }
        }
        .sheet(
            // Binding<Todo?> 如果 todo 有值, 也就是 !optional 的话
            // sheet 就会弹出
            // 如果 todo 是 nil, sheet 就会消失
            item: $editingTodo,
            content: { todo in
                TodoEditView(todo: todo)
            }
        )
    }
}

#Preview {
    TodoList(todoStore: TodoStore())
}
