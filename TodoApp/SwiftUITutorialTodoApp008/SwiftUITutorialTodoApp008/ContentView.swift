//
//  ContentView.swift
//  SwiftUITutorialTodoApp008
//
//  Created by Mason Sun on 2024/12/24.
//

import SwiftUI

// 1. 完善 TodoView: 优化整个 TodoView 的 UI, 并且实现点击动画, 和完成效果
// 2. 完善 Todo List
// 3. 添加编辑和创建页面

struct ContentView: View {
    @State private var isShowingAddView = false
    
    var body: some View {
        NavigationStack {
            TodoList()
                .navigationTitle("Todo List")
                //
//                .toolbar {
//                    //
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button {
//                            todoStore.clearAllData()
//                        } label: {
//                            Text("清空所有数据")
//                        }
//                    }
//                }
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
                    TodoAddView()
                }
        }
    }
}

#Preview {
    ContentView()
}


// SwiftData 使用方式
// 1. 把 model 改成 class 同时使用 @Model 去修饰
// 2. 在 App 入口注入 .modelContainer(for: [Todo.self, XXX.self])
// 3. 查数据: @Query var todos: [Todo]
// 4. 增: @Environment(\.modelContext), modelContext.insert(todo) 手动调用 modelContext.save()
// 5. 改: 先改 todo (model) 的数据, 然后调用 try? modelContext.save()
// 6. 删: @Environment(\.modelContext), modelContext.delete(todo) 手动调用 modelContext.save()

// 高级使用方法
// migration 数据, Todo 字段改名, Todo model 改名
// 多个数据之间的关系 Todo 有个 assigner (User) model
//
