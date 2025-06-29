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
    let isDone: Bool
    
    var body: some View {
        HStack {
            Text(emoji)
            Text(title)
            Spacer()
            // 三目运算符
            // true/false ? 1 : 0
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
        }
        //
//        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
