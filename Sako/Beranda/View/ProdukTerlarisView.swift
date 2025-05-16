import SwiftUI

struct ProdukTerlarisView: View {
    var rankedProducts: [(name: String, revenue: Int, quantity: Int)]
    @Binding var showTop10: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Produk Terlaris")
                .font(.system(size: 22, weight: .semibold))
                .padding(.horizontal, 10)
            
            if rankedProducts.isEmpty {
                Text("Belum ada data penjualan bulan ini.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
            } else {
                ForEach(Array(rankedProducts.prefix(showTop10 ? 10 : 3).enumerated()), id: \.offset) { index, product in
                    VStack {
                        // Baris pertama: Product Name dan Product Revenue
                        HStack {
                            Text("\(index + 1). \(product.name)")
                                .font(.system(size: 16))
                                .lineLimit(1)
                               
                            Spacer()
                               
                            Text("Rp \(product.revenue.formattedWithSeparator())")
                                .font(.system(size: 16))
                        }

                        // Baris kedua: Product Quantity ("Terjual")
                        HStack {
                            Spacer()
                            Text("\(product.quantity) Terjual")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 10)

                    if index < rankedProducts.prefix(showTop10 ? 10 : 3).count - 1 {
                        Divider()
                            .background(Color.gray)
                    }
                }
            }

            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showTop10.toggle()  // Toggle antara Top 3 dan Top 10
                    }
                }) {
                    Text(showTop10 ? "Lihat Sedikit" : "Lihat Lebih Banyak")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
