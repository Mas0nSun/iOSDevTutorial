//
//  ContentView.swift
//  SwiftUITutorial007
//
//  Created by Mason Sun on 2024/12/17.
//

import SwiftUI

struct ContentView: View {
    //
    @State private var size: CGFloat = 200
    @State private var offset: CGSize = .zero
    // 一个图片默认是不是不缩放, 200 * 1 = 200
    // 200 * 1.2
    // 200 * 0.5
    @State private var scaled: CGFloat = 1
    // 0 度, 视图不变
    // 90 度, 视图朝下旋转 90 度 (顺时针)
    // -90 度, 视图朝上旋转 90 度 (逆时针)
    @State private var rotation: CGFloat = 0
    
    var body: some View {
        // Gesture
//        Image("image")
//            .resizable()
//            .scaledToFill()
//            .frame(width: 200, height: 200)
//            .cornerRadius(24)
            //
        // 1. 用按钮的方式 Button
//        Button(
//            action: {
//                //
//                if size == 200 {
//                    size = 400
//                } else {
//                    size = 200
//                }
//            },
//            label: {
//                Image("image")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: size, height: size)
//                    .cornerRadius(24)
//            }
//        )
        //
//        Button {
//            //
//            // 实现点击事件
//        } label: {
//            // 随便丢进来一个 View
//            Image("image")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 200, height: 200)
//                .cornerRadius(24)
//        }
        // 2. .onTapGesture
//        Image("image")
//            .resizable()
//            .scaledToFill()
//            .frame(width: size, height: size)
//            .cornerRadius(24)
//            .onTapGesture {
//                if size == 200 {
//                    size = 400
//                } else {
//                    size = 200
//                }
//            }
        // 3. .gesture(TapGesture)
//        Image("image")
//            .resizable()
//            .scaledToFill()
//            .frame(width: size, height: size)
//            .cornerRadius(24)
//            .gesture(
//                TapGesture(count: 2)
//                    // 点击的事件完成后, 我们要做的事
//                    .onEnded {
//                        if size == 200 {
//                            size = 400
//                        } else {
//                            size = 200
//                        }
//                    }
//            )
//            .onTapGesture {
//                if size == 200 {
//                    size = 400
//                } else {
//                    size = 200
//                }
//            }
        // 4. 一些常见的手势
        Image("image")
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .cornerRadius(24)
            // 0, x 负数, 往左偏, x 正数, 往右偏
            // y 正数, 往下偏移, y 负数, 往上偏
            .offset(offset)
            
            .scaleEffect(scaled)
            
            .rotationEffect(.degrees(rotation))
            .gesture(
                TapGesture(count: 2)
                    // 点击的事件完成后, 我们要做的事
                    .onEnded {
                        if size == 200 {
                            size = 400
                        } else {
                            size = 200
                        }
                    }
            )
            // DragGesture, 拖拽排序, 拖拽图片 (小红书里)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        //
//                        print(value.translation)
                        offset = value.translation
                    })
                    .onEnded({ _ in
                        // 拖拽结束的时候
                        // 恢复原位的代码
                        offset = .zero
                    })
            )
            //
            // MagnifyGesture: 捏合
            // 2 个手指的事件被拦截了, 导致旋转手势没办法触发
            .gesture(
                MagnifyGesture()
                    .onChanged({ value in
                        // 用户捏合的程度, 0 ~ 1 ~ x
                        scaled = value.magnification
                    })
                    .onEnded({ _ in
                        // 让图片回复原大小
                        scaled = 1
                    })
            )
            // RotationGesture: 旋转
//            .gesture
            // 可以同时响应同类别的手势
            .simultaneousGesture(
                RotationGesture()
                    .onChanged({ value in
                        // 用户手指旋转的角度
                        rotation = value.degrees
                    })
                    .onEnded({ _ in
                        //
                        rotation = 0
                    })
            )
    }
}

#Preview {
    ContentView()
}
