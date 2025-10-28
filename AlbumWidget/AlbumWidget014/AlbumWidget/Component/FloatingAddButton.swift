//
//  FloatingAddButton.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/25.
//

import SwiftUI

struct FloatingAddButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(
        title: String = "添加到主屏幕",
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glass)
        .disabled(isLoading || isDisabled)
        .opacity((isLoading || isDisabled) ? 0.6 : 1.0)
    }
}

#Preview {
    VStack(spacing: 20) {
        // 正常状态
        FloatingAddButton(
            title: "添加到主屏幕",
            action: {}
        )
        
        // 加载状态
        FloatingAddButton(
            title: "添加中...",
            isLoading: true,
            action: {}
        )
        
        // 禁用状态
        FloatingAddButton(
            title: "已添加",
            isDisabled: true,
            action: {}
        )
    }
    .padding()
}
