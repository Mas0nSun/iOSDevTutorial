//
//  ContentView.swift
//  SwiftUITutorial002
//
//  Created by Mason Sun on 2024/12/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            Text("Hello, world!")
//                .font(.title)
//                .font(.headline)
//                .font(.body)
//                .fontWeight(.bold)
//                .fontDesign(.monospaced)
            // 字体样式是 iOS 系统的, 字号和样式可以自己去设置
            // 24, 用户更改了系统的大字体之后, 不会去自适应
//                .font(.system(size: 24, weight: .medium))
//                .font(.custom("xiangsu", size: 18))
            
//            Text("在银色的月光下，\n远处传来一阵微妙的蝉鸣。\n老槐树静静地伫立在田野边缘，\n它苍老的枝干讲述着无数岁月的静默故事。")
//                .lineLimit(2)
//                .multilineTextAlignment(.leading)
//                .foregroundStyle(Color(red: 0.5, green: 1, blue: 0.5))
//                .background(Color.red)
            
            // 斜体
            Text("Hello! 我是小孙")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.purple)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .italic()
                .padding([.top, .leading, .bottom], 16.0)
                .frame(width: 100.0, height: 200.0)
                .background(Color.gray)
            // 删除效果
            Text("Hello, world!")
                .strikethrough()
            // 下划线
            Text("Hello, world!")
                .underline()
            
            // 支持拼接
            Text("Hello, ")
                .foregroundStyle(.green)
            +
            Text("world!")
                .foregroundStyle(.red)
            
            // 嵌套图片
            Text("Hello, world! \(Image(systemName: "globe")) I' am mason")
            
            // 支持简单的副文本
            Text("*Hello*, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
