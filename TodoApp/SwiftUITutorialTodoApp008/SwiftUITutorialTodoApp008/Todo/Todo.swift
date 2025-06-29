//
//  Todo.swift
//  SwiftUITutorialTodoApp008
//
//  Created by Mason Sun on 2024/12/24.
//

import SwiftData
import Foundation

@Model
class Todo: Identifiable {
    // UUID 就是系统会帮我们生成一个不会重复的 String
    var id: UUID = UUID()
    var emoji: String
    var title: String
    var dueDate: Date
    var isDone: Bool
    
    init(id: UUID = UUID(), emoji: String, title: String, dueDate: Date, isDone: Bool) {
        self.id = id
        self.emoji = emoji
        self.title = title
        self.dueDate = dueDate
        self.isDone = isDone
    }
}
