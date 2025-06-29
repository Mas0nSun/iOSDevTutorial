//
//  TodoList.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

struct TodoList: View {
    // 有些场景下会存在问题
//    @ObservedObject var todoStore: TodoStore
    //
    // @Envrionment
    // @EnvironmentObject: 适用于 ObservableObject 的 class
    @Environment(TodoStore.self) var todoStore
    
    var body: some View {
        VStack {
            ForEach(todoStore.todos) { todo in
                TodoView(
                    emoji: todo.emoji,
                    title: todo.title,
                    isDone: todo.isDone
                )
                .onTapGesture {
                    print("Toggle todo")
                    todoStore.toggleTodoDone(id: todo.id)
                }
            }
        }
        .padding(.horizontal)
    }
}
