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
    
    var body: some View {
        List {
            ForEach($todoStore.todos) { todo in
                TodoView(todo: todo)
            }
        }
    }
}

#Preview {
    TodoList(todoStore: TodoStore())
}
