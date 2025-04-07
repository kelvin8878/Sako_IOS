import SwiftUI
import SwiftData

struct TambahProdukView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Query private var products: [Product]
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var priceError: String? = nil
    @State private var nameError: String? = nil
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
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
                        TextField("Contoh: 15.000", text: $price)
                            .autocorrectionDisabled()
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            .onChange(of: price) { _, newValue in
                                let formatted = formatCurrencyInput(newValue)
                                if formatted != newValue {
                                    price = formatted
                                }
                                validatePrice()
                            }
                        
                        if let error = priceError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 5)
                        }
                        Text("Hanya input angka")
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
        !name.isEmpty && !price.isEmpty && nameError == nil && priceError == nil
    }
    
    private func formatCurrencyInput(_ input: String) -> String {
        // Biarkan input "0" tetap bisa dihapus
        if input == "0" {
            return "0"
        }
        
        // Bersihkan input dari karakter non-digit dan simpan koma jika ada
        let cleaned = input.filter { $0.isNumber || $0 == "," }
        
        // Jika setelah dibersihkan kosong, return string kosong
        if cleaned.isEmpty {
            return ""
        }
        
        // Pisahkan bagian integer dan decimal
        let components = cleaned.components(separatedBy: ",")
        var integerPart = components[0]
        let decimalPart = components.count > 1 ? "," + components[1] : ""
        
        // Hapus leading zeros hanya jika angka lebih dari 1 digit
        if integerPart.count > 1 {
            integerPart = integerPart.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
            if integerPart.isEmpty { integerPart = "0" }
        }
        
        // Format bagian integer dengan separator ribuan
        if let number = Int(integerPart) {
            let formatted = currencyFormatter.string(from: NSNumber(value: number)) ?? integerPart
            // Jika hasil formatting "0" dan input asli "0", biarkan
            return formatted == "0" && input == "0" ? "0" : formatted + decimalPart
        }
        
        return integerPart + decimalPart
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
        
    private func validatePrice() {
        let cleanedPrice = price.replacingOccurrences(of: ".", with: "")
                              .replacingOccurrences(of: ",", with: ".")
        
        if cleanedPrice.isEmpty {
            priceError = nil
            return
        }
        
        guard let priceValue = Double(cleanedPrice) else {
            priceError = "Format harga tidak valid"
            return
        }
        
        if cleanedPrice.hasPrefix("0") && cleanedPrice.count > 1 && !cleanedPrice.hasPrefix("0.") {
            priceError = "Harga tidak boleh dimulai dengan 0"
        }
        else if priceValue <= 0 {
            priceError = "Harga harus lebih dari 0"
        }
        else {
            priceError = nil
        }
    }
    
    private func simpanProduk() {
        guard validateName() else { return }
        
        let cleanedPrice = price.replacingOccurrences(of: ".", with: "")
                              .replacingOccurrences(of: ",", with: ".")
        
        guard let harga = Double(cleanedPrice) else { return }
        
        let newProduct = Product(name: name, price: harga)
        context.insert(newProduct)
        try? context.save()
        dismiss()
    }
}
