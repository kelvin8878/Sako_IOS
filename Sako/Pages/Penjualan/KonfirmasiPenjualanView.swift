import SwiftUI
import SwiftData

struct KonfirmasiPenjualanView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    let selectedProducts: [SelectedProduct]
    var onSimpan: () -> Void

    var totalHarga: Double {
        selectedProducts.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button("Kembali") {
                    dismiss()
                }
                .foregroundColor(.blue)

                Spacer()

                Text("Konfirmasi")
                    .font(.headline)

                Spacer()
                Text("     ")
            }
            .padding(.horizontal)

            // Ringkasan produk
            List {
                ForEach(selectedProducts) { item in
                    HStack {
                        Text(item.product.name)
                        Spacer()
                        Text("\(item.quantity) × Rp\(Int(item.product.price).formattedWithSeparator())")
                    }
                }

                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Rp\(Int(totalHarga).formattedWithSeparator())")
                        .fontWeight(.bold)
                }
            }

            // Tombol simpan
            Button {
                let sale = Sale(date: Date())
                for item in selectedProducts {
                    sale.addProduct(product: item.product, quantity: item.quantity)
                }

                context.insert(sale)
                try? context.save()

                dismiss()
                onSimpan()
            } label: {
                HStack {
                    Spacer()
                    Text("Simpan Penjualan")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding()
        }
    }
}
