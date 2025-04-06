import SwiftUI
import SwiftData

struct TambahProdukView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Query private var products: [Product]
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var nameError: String? = nil
    
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
                            .onChange(of: name) {
                                validateName()
                            }
                        
                        if let error = nameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Text("* Maksimal 25 karakter")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
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
                if validateName() {
                    simpanProduk()
                }
            } label: {
                Text("Simpan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSave ? Color.green : Color.gray)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
            .disabled(!canSave)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
    
    private var canSave: Bool {
        !name.isEmpty && !price.isEmpty && nameError == nil
    }
    
    @discardableResult
    private func validateName() -> Bool {
        if name.isEmpty {
            nameError = nil
            return false
        }
        
        let isDuplicate = products.contains { $0.name.lowercased() == name.lowercased() }
        
        if isDuplicate {
            nameError = "Nama produk sudah ada"
            return false
        } else if name.count > 25 {
            nameError = "Nama melebihi 25 karakter"
            return false
        } else {
            nameError = nil
            return true
        }
    }

    private func simpanProduk() {
        guard let harga = Double(price) else { return }
        
        let newProduct = Product(name: name, price: harga)
        context.insert(newProduct)
        try? context.save()
        dismiss()
    }
}
