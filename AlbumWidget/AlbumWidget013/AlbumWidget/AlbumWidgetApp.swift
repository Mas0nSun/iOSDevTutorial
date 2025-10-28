//
//  AlbumWidgetApp.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/8/29.
//

import SwiftUI
import SwiftData

@main
struct AlbumWidgetApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([AlbumWidgetData.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("无法创建 SwiftData 容器: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
