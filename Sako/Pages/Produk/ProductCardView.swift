import SwiftUI

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline).bold()
                    .lineLimit(1)
                    .foregroundColor(.black)
                
                Text(formatPrice(product.price))
                    .font(.subheadline).bold()
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            Text("Ubah")
                .font(.system(size: 18))
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
    }
    
    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: price)) ?? "Rp \(Int(price))"
    }
}
