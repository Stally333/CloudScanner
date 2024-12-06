import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @StateObject private var viewModel = SubscriptionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    if !viewModel.products.isEmpty {
                        subscriptionPlans
                    }
                    featuresSection
                }
                .padding()
            }
            .navigationTitle("Premium Features")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restore") {
                        Task {
                            await viewModel.restorePurchases()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: $viewModel.showingError, presenting: viewModel.error) { _ in
                Button("OK", role: .cancel) {}
            } message: { error in
                Text(error.errorDescription ?? "Unknown error occurred")
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .background(.ultraThinMaterial)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 60))
                .foregroundStyle(CloudColors.gradientStart)
            
            Text("Upgrade to Premium")
                .font(.title2.bold())
            
            Text("Get access to advanced cloud analysis, unlimited generations, and more!")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
    
    private var subscriptionPlans: some View {
        VStack(spacing: 16) {
            if let monthly = viewModel.monthlyProduct {
                subscriptionCard(
                    title: "Monthly Premium",
                    price: monthly.displayPrice,
                    period: "month",
                    product: monthly
                )
            }
            
            if let yearly = viewModel.yearlyProduct,
               let discount = viewModel.yearlyDiscount {
                subscriptionCard(
                    title: "Yearly Premium",
                    price: yearly.displayPrice,
                    period: "year",
                    discount: "\(Int(discount))% savings",
                    product: yearly,
                    isRecommended: true
                )
            }
        }
    }
    
    private func subscriptionCard(
        title: String,
        price: String,
        period: String,
        discount: String? = nil,
        product: Product,
        isRecommended: Bool = false
    ) -> some View {
        Button {
            Task {
                await viewModel.purchase(product)
            }
        } label: {
            VStack(spacing: 8) {
                if isRecommended {
                    Text("RECOMMENDED")
                        .font(.caption.bold())
                        .foregroundStyle(CloudColors.gradientEnd)
                }
                
                Text(title)
                    .font(.headline)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(price)
                        .font(.title.bold())
                    Text("/ \(period)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let discount = discount {
                    Text(discount)
                        .font(.caption.bold())
                        .foregroundStyle(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.background)
                    .shadow(radius: 2)
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium Features")
                .font(.headline)
            
            ForEach(SubscriptionManager.SubscriptionTier.premium.features) { feature in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    
                    Text(feature.description)
                        .font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
                .shadow(radius: 2)
        }
    }
}

#Preview {
    SubscriptionView()
} 