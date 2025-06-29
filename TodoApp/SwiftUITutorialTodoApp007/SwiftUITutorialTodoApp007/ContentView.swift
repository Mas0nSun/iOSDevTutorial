//
//  ContentView.swift
//  SwiftUITutorialTodoApp007
//
//  Created by Mason Sun on 2024/12/24.
//

import SwiftUI

// 1. 完善 TodoView: 优化整个 TodoView 的 UI, 并且实现点击动画, 和完成效果
// 2. 完善 Todo List
// 3. 添加编辑和创建页面

struct ContentView: View {
    @State private var todoStore = TodoStore()
    @State private var isShowingAddView = false
    
    var body: some View {
        NavigationStack {
            TodoList(todoStore: todoStore)
                .navigationTitle("Todo List")
                //
                .toolbar {
                    //
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            todoStore.clearAllData()
                        } label: {
                            Text("清空所有数据")
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Button(
                        action: {
                            // 跳转添加页面
                            isShowingAddView.toggle()
                        },
                        label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add")
                            }
                            .padding(.vertical, 12)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                .sheet(isPresented: $isShowingAddView) {
                    TodoAddView { newTodo in
//                        print(newTodo.title)
                        todoStore.add(todo: newTodo)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
