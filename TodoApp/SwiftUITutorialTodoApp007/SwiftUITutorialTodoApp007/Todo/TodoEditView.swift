//
//  TodoEditView.swift
//  SwiftUITutorialTodoApp004
//
//  Created by Mason Sun on 2024/12/23.
//

import SwiftUI

struct TodoEditView: View {
    @Environment(\.dismiss) private var dismiss
    // 2 种不同的交互
    @State var todo: Todo
    
    // 编辑完成后的回掉操作
    let completion: (Todo) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                // 单纯的将 View 组织到一起, 并不会添加任何效果, 方便我们给一组视图增加 UI 效果
                Group {
                    TextField("Emoji", text: $todo.emoji)
                    TextField("Title", text: $todo.title)
                    DatePicker(
                        "Due Date",
                        selection: $todo.dueDate,
                        displayedComponents: .date
                    )
                    Toggle("isDone", isOn: $todo.isDone)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Edit Todo")
            .safeAreaInset(edge: .bottom) {
                Button(
                    action: {
                        // 1. 先关闭页面
                        dismiss()
                        // 2. 将变更后的 todo 丢给外面
                        completion(todo)
                    },
                    label: {
                        Text("Done")
                            .padding(.vertical, 12)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            // 200 * 20
                            // 无限宽度 * 20
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.indigo)
//                            .cornerRadius(8)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
    }
}

#Preview {
    TodoEditView(
        todo: .init(
            emoji: "⌨️",
            title: "写代码",
            dueDate: .now,
            isDone: false
        )
    ) { todo in
        print("\(todo.title)")
    }
}
