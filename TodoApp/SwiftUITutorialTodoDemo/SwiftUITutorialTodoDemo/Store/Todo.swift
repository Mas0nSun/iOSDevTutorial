//
//  Todo.swift
//  SwiftUITutorialTodoDemo
//
//  Created by Mason Sun on 2024/12/19.
//

import Foundation

struct Todo: Codable, Identifiable {
    var id: UUID = UUID()
    var emoji: String
    var title: String
    var isDone: Bool
    var dueDate: Date?
}
