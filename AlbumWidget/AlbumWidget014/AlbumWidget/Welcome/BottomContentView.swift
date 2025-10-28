//
//  BottomContentView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/21.
//

import SwiftUI

struct BottomContentView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let buttonAction: () -> Void
    let buttonBackground: AnyView
    
    init(
        title: String,
        subtitle: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void,
        buttonBackground: AnyView = AnyView(Color.black)
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.buttonBackground = buttonBackground
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // 标题
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 子标题
            Text(subtitle)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 按钮
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(buttonBackground)
                    .clipShape(Capsule())
            }
        }
        .padding(24)
    }
}

// MARK: - 便捷初始化方法
extension BottomContentView {
    /// 创建默认样式的底部内容视图
    static func `default`(
        title: String,
        subtitle: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void
    ) -> BottomContentView {
        BottomContentView(
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            buttonAction: buttonAction
        )
    }
    
    /// 创建 Apple Music 样式的底部内容视图
    static func appleMusic(
        title: String,
        subtitle: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void
    ) -> BottomContentView {
        let gradientBackground = AnyView(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.red,
                    Color.pink
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        
        return BottomContentView(
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            buttonAction: buttonAction,
            buttonBackground: gradientBackground
        )
    }
}

#Preview {
    VStack {
        BottomContentView.default(
            title: "欢迎使用相册小部件",
            subtitle: "创建精美的相册小部件，让回忆触手可及",
            buttonTitle: "继续",
            buttonAction: {}
        )
        
        Divider()
        
        BottomContentView.appleMusic(
            title: "音乐权限",
            subtitle: "允许访问您的音乐库，为您创建个性化的相册小部件",
            buttonTitle: "Apple Music",
            buttonAction: {}
        )
    }
}
