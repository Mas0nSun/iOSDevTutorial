//
//  main.swift
//  SwiftTutorialCommandLine
//
//

import Foundation
import SwiftUI

// 拓展
// extension

// 计算属性的概念

struct Todo {
    
    // 存储属性
    var name: String
    
    
    // 计算属性
    var displayName: String {
        // 这里可以写任何代码, 并且返回一个类型 (String)
        "我的名字是: \(name)"
    }
}

var todo = Todo(name: "去游泳")
todo.name = "去上课"
print(todo.name)
print(todo.displayName)

// 计算属性: 只允许读, 不允许写


// extension

extension Int {
    func squared() -> Int {
        return self * self
    }
}

let value: Int = 10

print(value.squared())

extension Color {
    static var lightRed: Color {
        red.opacity(0.3)
    }
}

let lightRed = Color.lightRed

extension View {
    func redBorder() -> some View {
        overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.lightRed, lineWidth: 1)
        }
    }
}

let text = Text("Hello")
    .redBorder()

//SwiftUI
