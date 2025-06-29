//
//  TodoView.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

struct TodoView: View {
    let emoji: String
    let title: String
    @Binding var isDone: Bool
    
    var body: some View {
        HStack {
            // emoji
            Text(emoji)
                .padding(8)
                .background {
                    Color.indigo.opacity(0.3)
                }
                .clipShape(Circle())
            // title + due date
            VStack(alignment: .leading, spacing: 8) {
                // title
                Text(title)
                    // primary 就是 App 默认文本的颜色 (黑色)
                    // 在黑色模式下会变为白色
                    .foregroundStyle(isDone ? .gray.opacity(0.5) : .primary)
                    // 如果 isDone == true, 则需要激活中划线
                    .strikethrough(isDone)
                // due date
                HStack(spacing: 5) {
                    Image(systemName: "calendar.badge.clock")
                    Text("2024/12/31")
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
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
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
                isDone.toggle()
            }
        }
    }
}

#Preview {
    @Previewable
    @State var isTodo1Done = false
    @Previewable
    @State var isTodo2Done = false
    
    VStack {
        TodoView(
            emoji: "⌨️",
            title: "写代码",
            isDone: $isTodo1Done
        )
        TodoView(
            emoji: "📚",
            title: "去读书",
            isDone: $isTodo2Done
        )
    }
    .padding(.horizontal)
}
