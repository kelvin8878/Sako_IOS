import SwiftUI
import SwiftData

struct TambahPenjualanView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var products: [Product]

    @State private var selectedProducts: [SelectedProduct] = []
    @State private var showKonfirmasi: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button("Batal") { dismiss() }
                    .foregroundColor(.blue)

                Spacer()

                Text("Tambah Penjualan")
                    .font(.headline)

                Spacer()

                // Placeholder untuk spacing seimbang
                Text("     ")
            }
            .padding(.horizontal)

            // Daftar produk
            List {
                ForEach(products) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.name)
                            Text("Rp\(Int(product.price).formattedWithSeparator())")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        if let index = selectedProducts.firstIndex(where: { $0.product.id == product.id }) {
                            HStack(spacing: 12) {
                                Button(action: {
                                    if selectedProducts[index].quantity > 1 {
                                        selectedProducts[index].quantity -= 1
                                    } else {
                                        selectedProducts.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }

                                Text("\(selectedProducts[index].quantity)")
                                    .frame(minWidth: 20)

                                Button(action: {
                                    selectedProducts[index].quantity += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        } else {
                            Button("Tambah") {
                                selectedProducts.append(SelectedProduct(product: product, quantity: 1))
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }

            // Tombol konfirmasi
            if !selectedProducts.isEmpty {
                Button {
                    showKonfirmasi = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Konfirmasi Penjualan")
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showKonfirmasi) {
            KonfirmasiPenjualanView(selectedProducts: selectedProducts) {
                dismiss() // Tutup TambahPenjualanView setelah simpan
            }
        }
    }
}

// MARK: - SelectedProduct (Local Model)
struct SelectedProduct: Identifiable {
    var id: UUID { product.id }
    let product: Product
    var quantity: Int
}

#Preview {
    TambahPenjualanView()
}
