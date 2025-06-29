//
//  TodoEditView.swift
//  SwiftUITutorialTodoDemo
//
//  Created by Mason Sun on 2024/12/19.
//

import SwiftUI

struct TodoEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var todo: Todo
    let onComplete: (Todo) -> Void

    var body: some View {
        NavigationStack {
            List {
                Group {
                    TextField("Emoji", text: $todo.emoji)
                    TextField("Title", text: $todo.title)
                    DatePicker(
                        "Due Date",
                        selection: Binding(
                            get: {
                                todo.dueDate ?? Date()
                            },
                            set: {
                                todo.dueDate = $0
                            }
                        ),
                        displayedComponents: .date
                    )
                    Toggle("Done" ,isOn: $todo.isDone)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Edit Todo")
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
                onComplete(todo)
            } label: {
                Text("Done")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

#Preview {
    TodoEditView(
        todo: Todo(emoji: "⌨️", title: "写代码", isDone: false)
    ) { _ in
        //
    }
}
