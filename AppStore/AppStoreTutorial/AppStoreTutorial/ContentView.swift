//
//  ContentView.swift
//  AppStoreTutorial
//
//  Created by Mason Sun on 2025/6/29.
//

import SwiftUI

struct ContentView: View {
    //
    var appName: String = String(localized: "My World")
    var appName2: String = String(localized: "Small Hero")
    
    var body: some View {
        NavigationStack {
            VStack {
                //
                Text(appName)
                Text(appName2)
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button("Add App") {
                    //
                    print("添加应用~~~")
                }
                Button("Delete All Apps") {
                    //
                    print("删除所有应用~~~")
                }
                //
                Text(Date(), format: .dateTime.year().month().day())
            }
            .padding()
            //
            .navigationTitle("My Apps")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.locale, .init(identifier: "zh"))
}
