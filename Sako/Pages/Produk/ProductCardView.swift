import SwiftUI

struct ProductCardView: View {
    var product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.name)
                .font(.system(size: 20, weight: .semibold))
            Text("Rp \(Int(product.price))")
                .font(.system(size: 18))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
