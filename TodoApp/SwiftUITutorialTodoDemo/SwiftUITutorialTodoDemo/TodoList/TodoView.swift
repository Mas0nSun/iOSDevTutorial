//
//  TodoView.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

struct TodoView: View {
    @Binding var todo: Todo
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(todo.emoji)
                .font(.title3)
                .frame(minWidth: 40, minHeight: 40)
                .background(Color.accentColor.opacity(0.3))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 8) {
                Text(todo.title)
                    .font(.body)
                    // 完成后文本变为删除效果, 同时颜色淡化
                    .foregroundStyle(todo.isDone ? .gray.opacity(0.7) : .primary)
                    .strikethrough(todo.isDone)
                // Due date
                if let dueDate = todo.dueDate {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text(dueDate, format: Date.FormatStyle(date: .numeric))
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle.fill")
                .imageScale(.large)
                // 给完成图标添加一些颜色和动画效果
                .foregroundStyle(todo.isDone ? .accent : .gray.opacity(0.1))
                .contentTransition(.symbolEffect(.replace))
        }
//        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        // 让点击区域变为整个 Cell, 不添加这行代码 Spacer() 填充的
        // 位置无法被点击
        .contentShape(Rectangle())
        .onTapGesture {
            // 点击 Cell 后触发完成操作
            withAnimation(.easeInOut) {
                todo.isDone.toggle()
            }
        }
    }
}

#Preview {
    TodoView(
        todo: .constant(
            .init(
                emoji: "⌨️",
                title: "写代码",
                isDone: false,
                dueDate: .now
            )
        )
    )
    .padding(.horizontal)
}
