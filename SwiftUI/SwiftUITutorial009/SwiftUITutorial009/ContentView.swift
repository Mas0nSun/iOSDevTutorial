//
//  ContentView.swift
//  SwiftUITutorial009
//
//  Created by Mason Sun on 2024/12/18.
//

import SwiftUI

// @Envrionment


// 从视图顶部, 向下传递一些信息 (一些字段, 一些实例等)
// App (入口: themeColor)
//   - ContentView
//       - TodoList
//           - TodoView
//               - CheckboxButton

// disabled

struct CheckboxButton: View {
//    @Environment(\.colorScheme) var colorScheme
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        Image(systemName: isEnabled ? "circle" : "circle.fill")
            .onTapGesture {
                print("Done")
            }
//            .foregroundStyle(colorScheme == .dark ? .yellow : .green)
    }
}

struct TodoView: View {
    var body: some View {
        HStack {
            Text("Todo xxx \nTodo xxx \nTodo xxx")
            CheckboxButton()
        }
        
    }
}

struct TodoList: View {
    var body: some View {
        TodoView()
        TodoView()
        TodoView()
    }
}

struct ContentView: View {
    var body: some View {
        TodoList()
    }
}

#Preview {
    ContentView()
        .background(Color.indigo)
        .foregroundStyle(.orange)
        .lineLimit(3)
        .environment(\.isEnabled, true)
        // colorScheme 改为 darkMode
//        .environment(\.colorScheme, .light)
}
