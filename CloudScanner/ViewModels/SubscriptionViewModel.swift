import StoreKit
import SwiftUI

@MainActor
class SubscriptionViewModel: ObservableObject {
    @Published private(set) var products: [StoreKit.Product] = []
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage: String?
    @Published var error: SubscriptionManager.SubscriptionError?
    
    private let subscriptionManager = SubscriptionManager.shared
    
    var monthlyProduct: StoreKit.Product? {
        products.first { $0.id == "com.cloudscanner.premium.monthly" }
    }
    
    var yearlyProduct: StoreKit.Product? {
        products.first { $0.id == "com.cloudscanner.premium.yearly" }
    }
    
    var yearlyDiscount: Double? {
        guard let monthly = monthlyProduct?.price,
              let yearly = yearlyProduct?.price else {
            return nil
        }
        
        let monthlyDouble = NSDecimalNumber(decimal: monthly).doubleValue
        let yearlyDouble = NSDecimalNumber(decimal: yearly).doubleValue
        let yearlyMonthly = yearlyDouble / 12.0
        
        return ((monthlyDouble - yearlyMonthly) / monthlyDouble) * 100.0
    }
    
    init() {
        Task {
            await loadProducts()
        }
    }
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await subscriptionManager.loadProducts()
            self.products = subscriptionManager.availableProducts
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingError = true
        }
    }
    
    func purchase(_ product: StoreKit.Product) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await subscriptionManager.purchase(product)
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingError = true
        }
    }
    
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await subscriptionManager.restorePurchases()
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingError = true
        }
    }
} 