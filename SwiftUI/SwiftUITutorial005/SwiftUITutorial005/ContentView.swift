//
//  ContentView.swift
//  SwiftUITutorial005
//
//  Created by Mason Sun on 2024/12/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // VStack: 竖向布局, Y 轴
//        VStack(alignment: .trailing, spacing: 16) {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//            Spacer()
//            Text("I‘m mason")
//            Image(systemName: "cloud.drizzle")
//        }
        // HStack: 横向布局, X 轴
//        HStack(alignment: .firstTextBaseline, spacing: 12) {
//            Text("Hello, world!")
//                .font(.largeTitle)
//            // 无限吹气的气囊
//            Spacer()
//            Text("I‘m mason")
//            Image(systemName: "chevron.right")
//        }
//        .border(.red)
        // ZStack: Z 轴
        ZStack(alignment: .bottomTrailing) {
            Color.purple.opacity(0.3)
                .frame(height: 200)
            Text("Hello, world")
                .font(.largeTitle)
        }
    }
}

#Preview {
    ContentView()
}
