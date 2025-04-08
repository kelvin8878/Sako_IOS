import SwiftUI
import SwiftData

struct ProductCardView: View {
    @Bindable var product: Product
    @Environment(\.modelContext) private var context
    @State private var isExpanded = false
    @State private var editedName: String = ""
    @State private var editedPrice: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Kartu utama
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(.black)

                    Text(formatPrice(product.price))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text("Ubah")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
            .padding(16)
            .background(Color.white)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                    editedName = product.name
                    editedPrice = String(format: "%.0f", product.price)
                }
            }

            // Expandable edit form
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nama Produk")
                            .font(.caption)
                            .foregroundColor(.gray)

                        TextField("Masukkan nama produk", text: $editedName)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Harga Produk")
                            .font(.caption)
                            .foregroundColor(.gray)

                        TextField("Masukkan harga", text: $editedPrice)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Spacer()

                        Button {
                            guard let newPrice = Double(editedPrice), newPrice >= 0 else { return }
                            product.name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
                            product.price = newPrice
                            try? context.save()
                            withAnimation {
                                isExpanded = false
                            }
                        } label: {
                            Text("Simpan")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
