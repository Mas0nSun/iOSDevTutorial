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
                    // .constant 把 todo.isDone 丢进来, 代表这个状态永远是 todo.isDone 得值
                    // 即便内部更改了也视为无效
                    // constant 一般会用来作为测试使用, 实际开发中不经常用到
                    // TODO: 修复这里的数据流, 避免出现 Bug
                    isDone: .constant(todo.isDone)
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
