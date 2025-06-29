//
//  SwiftUITutorialTodoApp008App.swift
//  SwiftUITutorialTodoApp008
//
//  Created by Mason Sun on 2024/12/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftUITutorialTodoApp008App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Todo.self)
        }
    }
}
