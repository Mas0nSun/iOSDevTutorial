//
//  PurchaseManager.swift
//  AlbumWidget
//
//  Created by Assistant on 2025/10/30.
//

import Foundation
import StoreKit
import Combine
import UIKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    // 配置产品 ID（非消耗型：一次性终身解锁）
    static let lifetimeProductId = "AlbumWidgetLifetimeVIP"
    
    @Published private(set) var isPremiumUnlocked: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var lifetimeProduct: Product?
    
    private let unlockedKey = "isPremiumUnlocked"
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        Task {
            await start()
        }
        observeAppLifecycle()
    }
    
    // MARK: - Public API
    func start() async {
        isLoading = true
        defer { isLoading = false }
        await observeTransactions()
        await loadProducts()
        await refreshEntitlement()
    }
    
    func purchaseLifetime() async throws {
        let product: Product
        if let cached = lifetimeProduct {
            product = cached
        } else {
            guard let loaded = await safeLoadLifetimeProduct() else { return }
            product = loaded
        }
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            // 刷新资格
            await refreshEntitlement()
        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }
    
    func restorePurchases() async throws {
        // 对于 StoreKit 2，恢复=重新遍历当前资格即可
        try await AppStore.sync()
        await refreshEntitlement()
    }
    
    // MARK: - Internal
    private func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.lifetimeProductId])
            lifetimeProduct = products.first(where: { $0.id == Self.lifetimeProductId })
        } catch {
            // 忽略加载失败，后续可重试
        }
    }
    
    private func safeLoadLifetimeProduct() async -> Product? {
        if let p = lifetimeProduct { return p }
        await loadProducts()
        return lifetimeProduct
    }
    
    private func refreshEntitlement() async {
        let unlocked = await isLifetimeActive()
        setUnlocked(unlocked)
    }
    
    private func setUnlocked(_ value: Bool) {
        isPremiumUnlocked = value
        UserDefaults.standard.set(value, forKey: unlockedKey)
    }
    
    // 当前是否拥有终身解锁资格（基于最新交易与撤销状态）
    private func isLifetimeActive() async -> Bool {
        // 使用最新交易来判断是否被撤销/退款
        if let result = try? await Transaction.latest(for: Self.lifetimeProductId) {
            switch result {
            case .verified(let transaction):
                // 撤销/退款后 revocationDate 不为空
                return transaction.revocationDate == nil
            case .unverified:
                return false
            }
        }
        // 兜底：检查当前资格（一般退款后不会在此列表中）
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == Self.lifetimeProductId {
                return true
            }
        }
        return false
    }
    
    private func observeTransactions() async {
        Task.detached(priority: .background) { [weak self] in
            guard let self else { return }
            for await update in Transaction.updates {
                switch update {
                case .verified(let transaction):
                    if transaction.productID == Self.lifetimeProductId {
                        let active = transaction.revocationDate == nil
                        await MainActor.run {
                            self.setUnlocked(active)
                        }
                    }
                    await transaction.finish()
                case .unverified:
                    // 忽略未验证的更新，不改变状态
                    break
                }
            }
        }
    }

    private func observeAppLifecycle() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task { await self.refreshEntitlement() }
            }
            .store(in: &cancellables)
    }
    
    // 验证辅助
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw NSError(domain: "IAP", code: -1, userInfo: [NSLocalizedDescriptionKey: "交易未通过验证"])
        case .verified(let safe):
            return safe
        }
    }
}



