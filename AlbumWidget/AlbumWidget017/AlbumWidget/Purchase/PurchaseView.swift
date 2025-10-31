//
//  PurchaseView.swift
//  AlbumWidget
//
//  Created by Assistant on 2025/10/30.
//

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.openURL) private var openURL
    
    private let termsURL = URL(string: "https://example.com/terms")!
    private let privacyURL = URL(string: "https://example.com/privacy")!
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            featureListSection
            Spacer(minLength: 12)
            purchaseButton
            secondaryButtons
        }
        .padding(24)
        .navigationTitle("解锁高级功能")
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AlbumWidget VIP")
                .font(.largeTitle).bold()
            Text("一次性购买，永久解锁全部功能")
                .foregroundStyle(.secondary)
        }
    }
    
    private var featureListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("创建无限数量的小部件", systemImage: "checkmark.circle.fill")
            Label("更多封面样式与布局", systemImage: "checkmark.circle.fill")
            Label("个性化配色与字体", systemImage: "checkmark.circle.fill")
            Label("后续功能持续免费更新", systemImage: "checkmark.circle.fill")
        }
        .font(.body)
        .symbolRenderingMode(.hierarchical)
    }
    
    private var purchaseButton: some View {
        Button(action: {
            Task { try? await purchaseManager.purchaseLifetime() }
        }) {
            HStack {
                if purchaseManager.isPremiumUnlocked {
                    Image(systemName: "checkmark.seal.fill")
                    Text("已解锁")
                } else {
                    Image(systemName: "star.fill")
                    Text(purchaseTitle)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(purchaseManager.isLoading || purchaseManager.isPremiumUnlocked)
    }
    
    private var secondaryButtons: some View {
        VStack(spacing: 8) {
            Button("恢复购买") {
                Task { try? await purchaseManager.restorePurchases() }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 12) {
                Button("服务条款") { openURL(termsURL) }
                Spacer()
                Button("隐私协议") { openURL(privacyURL) }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.top, 4)
        }
    }
    
    private var purchaseTitle: String {
        if let price = purchaseManager.lifetimeProduct?.displayPrice {
            return "购买永久版（\(price)）"
        } else {
            return "购买永久版"
        }
    }
}

#Preview {
    PurchaseView()
        .environmentObject(PurchaseManager.shared)
}


