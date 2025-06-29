//
//  SwiftUITutorialTodoDemoApp.swift
//  SwiftUITutorialTodoDemo
//
//  Created by Mason Sun on 2024/12/19.
//

import SwiftUI

@main
struct SwiftUITutorialTodoDemoApp: App {
    @State var todoStore = TodoStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(todoStore)
        }
    }
}
