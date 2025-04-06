import SwiftUI
import SwiftData

struct TambahProdukView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var name: String = ""
    @State private var price: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 🔼 Header: Kembali
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Kembali")
                    }
                    .padding(.vertical, 8)
                }
                .foregroundColor(.blue)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16)

            // 🏷️ Judul
            Text("Tambah Produk")
                .font(.system(size: 28, weight: .bold))
                .padding(.horizontal)
            
            // 📄 Input Field
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Nama Produk
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nama Produk")
                            .font(.headline)
                        TextField("Contoh: Nasi Goreng", text: $name)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        
                        Text("* Maksimal 20 karakter")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Harga Produk
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Harga")
                            .font(.headline)
                        TextField("Contoh: 15000", text: $price)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        
                        Text("* Masukkan hanya angka")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }

            Spacer()

            // ✅ Tombol Simpan
            Button {
                simpanProduk()
            } label: {
                Text("Simpan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty || price.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
            .disabled(name.isEmpty || price.isEmpty)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    private func simpanProduk() {
        guard let harga = Double(price) else { return }
        
        let newProduct = Product(name: name, price: harga)
        context.insert(newProduct)
        try? context.save()
        dismiss()
    }
}
