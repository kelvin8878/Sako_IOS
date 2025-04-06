import SwiftUI

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.system(size: 22, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.black)
                
                Text(formatPrice(product.price))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            Image(systemName: "pencil.line")
                .font(.system(size: 18))
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(16)
        // Shadow yang mengikuti bentuk rounded corners
        .shadow(
            color: Color.black.opacity(0.15), // Lebih natural
            radius: 6 // Radius sedang
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 1)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
    }
    
    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: price)) ?? "Rp\(Int(price))"
    }
}
