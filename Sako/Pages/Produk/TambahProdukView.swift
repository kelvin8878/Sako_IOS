import SwiftUI
import SwiftData

struct TambahProdukView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Query private var products: [Product]
    
    @State private var name: String = ""
    @State private var priceInput: String = "" // Untuk input user
    @State private var formattedPrice: String = "" // Untuk display dengan separator
    @State private var priceError: String? = nil
    @State private var nameError: String? = nil
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 🔼 Header: Kembali
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Text("Batal")
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
                VStack(alignment: .leading, spacing: 24) {
                    // Nama Produk
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nama Produk")
                            .font(.headline)
                            .padding(.horizontal, 5)
                        TextField("Contoh: Nasi Goreng", text: $name)
                            .autocorrectionDisabled()
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
                                .padding(.horizontal, 5)
                        }
                        Text("Maksimal 25 karakter")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 5)
                    }
                    
                    // Harga Produk
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Harga")
                            .font(.headline)
                            .padding(.horizontal, 5)
                        TextField("Contoh: 15.000", text: $formattedPrice)
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            .onChange(of: formattedPrice) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                
                                // Simpan nilai asli tanpa format
                                priceInput = filtered
                                
                                // Format ulang untuk display
                                if let number = Int(filtered) {
                                    formattedPrice = numberFormatter.string(from: NSNumber(value: number)) ?? filtered
                                } else {
                                    formattedPrice = filtered
                                }
                                
                                validatePrice()
                            }
                        
                        if let error = priceError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 5)
                        }
                        Text("Hanya angka")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 5)
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
        !name.isEmpty && !priceInput.isEmpty && nameError == nil && priceError == nil
    }
    
    @discardableResult
    private func validateName() -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isDuplicate = products.contains { $0.name.lowercased() == name.lowercased() }
        
        if trimmed.isEmpty {
            nameError = "Nama tidak boleh kosong"
            return false
        }
        
        if isDuplicate {
            nameError = "Nama produk sudah ada"
            return false
        }

        if name.first?.isWhitespace == true {
            nameError = "Nama tidak boleh diawali spasi"
            return false
        }

        if trimmed.count > 25 {
            nameError = "Nama melebihi 25 karakter"
            return false
        }

        if trimmed.rangeOfCharacter(from: .letters) == nil {
            nameError = "Nama tidak valid"
            return false
        }

        nameError = nil
        return true
    }
        
    @discardableResult
    private func validatePrice() -> Bool {
        if priceInput.isEmpty {
            priceError = "Harga tidak boleh kosong"
            return false
        }

        if priceInput.hasPrefix("0") && priceInput.count > 1 {
            priceError = "Harga tidak boleh dimulai dengan 0"
            return false
        }

        guard let value = Int(priceInput) else {
            priceError = "Format harga tidak valid"
            return false
        }

        if value <= 0 {
            priceError = "Harga harus lebih dari 0"
            return false
        }
        
        priceError = nil
        return true
    }
    
    private func simpanProduk() {
        guard validateName() else { return }
        
        guard let harga = Int(priceInput) else { return }
        
        let newProduct = Product(name: name, price: Double(harga))
        context.insert(newProduct)
        try? context.save()
        dismiss()
    }
}
