//
//  AppIntent.swift
//  AlbumWidgetExtension
//
//  Created by Mason Sun on 2025/10/27.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "专辑小组件配置" }
    static var description: IntentDescription { "配置专辑小组件的显示选项。" }

    // 控制是否显示专辑信息
    @Parameter(title: "显示信息", default: true)
    var showInfo: Bool
}
