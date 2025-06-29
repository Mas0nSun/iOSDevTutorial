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
        HStack {
            // emoji
            Text(todo.emoji)
                .padding(8)
                .background {
                    Color.indigo.opacity(0.3)
                }
                .clipShape(Circle())
            // title + due date
            VStack(alignment: .leading, spacing: 8) {
                // title
                Text(todo.title)
                    // primary 就是 App 默认文本的颜色 (黑色)
                    // 在黑色模式下会变为白色
                    .foregroundStyle(todo.isDone ? .gray.opacity(0.5) : .primary)
                    // 如果 isDone == true, 则需要激活中划线
                    .strikethrough(todo.isDone)
                // due date
                HStack(spacing: 5) {
                    Image(systemName: "calendar.badge.clock")
                    // 这个需要大家取记下, 或者你需要用到展示 Date 的时候
                    // 去网上搜索, 或者去问 AI: GPT, Claude, Kimi
                    Text(
                        todo.dueDate,
                        // 用系统的 FormatStyle 有什么好处
                        //
                        // String: "年/月/日"
                        //
                        format: Date.FormatStyle(date: .numeric)
                    )
                }
                .font(.footnote)
                .foregroundStyle(.gray)
            }
            //
            // 填充物
            Spacer()
            // isDone 的 image
            // 三目运算符
            // true/false ? 1 : 0
            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
                .foregroundStyle(.indigo)
                // 也属于一个转场动画, 最好也是用 withAnimation
                .contentTransition(.symbolEffect(.replace))
        }
        //
//        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            // 带弹簧效果的动画 (带惯性的动画)
            // Nice to have, 给用户提供情绪价值
            withAnimation(.easeInOut) {
                todo.isDone.toggle()
            }
        }
    }
}

#Preview {
    @Previewable
    @State var todo1: Todo = .init(
        emoji: "⌨️",
        title: "写代码",
        dueDate: .now,
        isDone: false
    )
    
    @Previewable
    @State var todo2: Todo = .init(
        emoji: "📚",
        title: "去读书",
        dueDate: .now,
        isDone: false
    )
    
    VStack {
        TodoView(todo: $todo1)
        TodoView(todo: $todo2)
    }
    .padding(.horizontal)
}
