//
//  ContentView.swift
//  SwiftUITutorial003
//
//  Created by Mason Sun on 2024/12/10.
//

import SwiftUI

struct ContentView: View {
    @State private var animationToggle: Bool = false
    
    var body: some View {
        // 1. iOS 图标组件库
////        Image(systemName: "globe")
//        Image(systemName: "cloud.rainbow.crop.fill")
//            .resizable()
//            // 保持原始比例, 会超过容器的大小
//            // fill 比较适合渲染插图, 背景
////            .scaledToFill()
//            // 保持原始比例, 不会超过容器的大小
//            // fit 比较适合渲染一些图标
//            .scaledToFit()
////            .symbolRenderingMode(.multicolor)
//            .foregroundStyle(.blue, .white)
//            // 做动画
//            .symbolEffect(.bounce, value: animationToggle)
//            // 做一个尺寸的限制
//            .frame(width: 50, height: 100)
//            // 增加一个红色边框
//            .border(.red)
//            .background(Color.black)
//            .onTapGesture {
//                // 如果 bool 时 true, 它就会变为 false
//                // 反之变为 true
//                animationToggle.toggle()
//            }
        // 2. 加载导入到 xcode 中的图片
        Image("background")
            //
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .border(.red)
            .clipped()
        
        Image("apple-logo")
            .resizable()
            .frame(width: 24, height: 24)
        
        // 3. 加载一些网络图片/本地文件
        // Kingfisher/SDImage
        AsyncImage(url: URL("http://xxx.com/xxx.png"))
    }
}

#Preview {
    ContentView()
}
