import SwiftUI
import Foundation

struct PenjualanCardView: View {
    let sale: Sale
    let index: Int
    @State private var showAllItems = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("Pesanan \(index + 1)")
                    .font(.headline)

                Spacer()

                Text("Rp\(Int(sale.totalPrice).formattedWithSeparator())")
                    .font(.headline)
            }

            // Items
            ForEach(showAllItems ? sale.items : Array(sale.items.prefix(3)), id: \.id) { item in
                HStack {
                    Text(item.product.name)
                    Spacer()
                    Text("\(item.quantity)x")
                        .foregroundColor(.gray)
                }
            }

            // Toggle show more
            if sale.items.count > 3 {
                Button(action: {
                    withAnimation {
                        showAllItems.toggle()
                    }
                }) {
                    Text(showAllItems ? "Lihat lebih sedikit" : "Lihat lebih banyak")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
