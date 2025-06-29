//
//  ContentView.swift
//  SwiftUITutorial004
//
//  Created by Mason Sun on 2024/12/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Shape
        // 1. 矩形
        // 不带圆角
        Rectangle()
            .fill(.red)
//            .stroke(Color.red, lineWidth: 10)
            .frame(width: 200, height: 50)
//            .foregroundStyle(.red)
        // 带圆角
        RoundedRectangle(cornerRadius: 16)
//            .fill(.green)
            .stroke(Color.green, lineWidth: 4)
            .frame(width: 200, height: 50)
        
        // 包含部分圆角的矩形
        UnevenRoundedRectangle(
            cornerRadii: .init(
                topLeading: 0,
                bottomLeading: 4,
                bottomTrailing: 8,
                topTrailing: 16
            )
        )
        .frame(width: 200, height: 50)
        
        // 2. 圆形
        //    正圆, 椭圆, 胶囊
        Circle()
            // 同时填充 + 绘制
            .fill(Color.blue)
            .stroke(Color.black, lineWidth: 4)
            .frame(width: 200, height: 50)
        
        Ellipse()
            .fill(Color.orange)
            .frame(width: 200, height: 50)
        
        // 可以让两个 View 重叠
        // Z, [1, 2 ,3]
        ZStack {
            RoundedRectangle(cornerRadius: 50 / 2)
                .fill(.red)
                .frame(width: 200, height: 50)
            Capsule()
                .fill(.purple)
                .frame(width: 200, height: 50)
        }
        
        // 实际开发中的使用方法
        
        // 1. 切割图形
        Image("background")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
            //  切割成圆形, e.g. 头像
            .clipShape(Circle())
        
        // 2. 增加 border
        Button {
            //
        } label: {
            Text("Hello, world")
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                //
//                .border(.red)
            // 浮层, 给 View 的上面盖住一层视图
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                }
        }
        
        // 3. 组装一些 UI 组件
        // e.g.
        // 进度条
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray)
            Rectangle()
                .fill(Color.black)
                .frame(width: 80)
        }
        .frame(width: 200, height: 20)
        .clipShape(Capsule())
        
        // 分页指示器
        HStack(spacing: 4) {
            Circle()
                .fill(.gray)
                .frame(width: 5, height: 5)
            Circle()
                .frame(width: 5, height: 5)
            Circle()
                .frame(width: 5, height: 5)
        }
        
        // SwiftUI 支持自己绘制图形
        //
    }
    
}

#Preview {
    ContentView()
}
