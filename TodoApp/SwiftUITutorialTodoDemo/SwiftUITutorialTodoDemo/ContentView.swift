//
//  ContentView.swift
//  SwiftUITutorialTodoDemo
//
//  Created by Mason Sun on 2024/12/19.
//

import SwiftUI

struct ContentView: View {
    @Environment(TodoStore.self) var todoStore
    @State var isShowingAddTodo = false
    
    var body: some View {
        NavigationStack {
            TodoList(todoStore: todoStore)
                .navigationTitle("Todo List")
//                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        EditButton()
//                    }
//                }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                isShowingAddTodo.toggle()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add")
                }
                .foregroundStyle(.white)
                .font(.headline)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding()
        }
        .sheet(isPresented: $isShowingAddTodo) {
            TodoAddView { todo in
                todoStore.addTodo(todo)
            }
        }
    }
}

#Preview {
    ContentView()
}
