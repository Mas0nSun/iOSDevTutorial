//
//  ContentView.swift
//  SwiftUITutorial011
//
//  Created by Mason Sun on 2024/12/19.
//

import SwiftUI

struct ContentView: View {
    @State private var isRotated: Bool = false
    @State private var isRectangleAppeared: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.right")
                .imageScale(.large)
                .foregroundStyle(.tint)
                // rotated 变了角度会变
                .rotationEffect(.degrees(isRotated ? 90 : 0))
                // 监听 rotated 变化的时候播放动画
                .animation(
                    .interactiveSpring(duration: 0.5, extraBounce: 0.3),
                    value: isRotated
                )
            
            Button {
                // 1. 影响范围很广, 不太好做细化的控制
                // 2. 非常方便
                // 3. 用来做转场动画
//                withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.3)) {
//                    isRotated.toggle()
//                }
                withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.3)) {
                    isRectangleAppeared.toggle()
                }
            } label: {
                Text("Start Animation")
            }
            
            // 转场动画的概念: 当视图出现/消失的时候就是我们的转场动画
            if isRectangleAppeared {
                Rectangle()
                    .fill(.indigo)
                    .frame(width: 200, height: 200)
                    .transition(.scale)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
