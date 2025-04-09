import SwiftUI
import SwiftData

struct ProductCardView: View {
    @Bindable var product: Product
    @Environment(\.modelContext) private var context

    @State private var isExpanded = false
    @State private var editedName: String = ""
    
    // State untuk harga tanpa format dan display formatted
    @State private var priceInput: String = ""
    @State private var formattedPrice: String = ""
    
    @State private var nameError: String? = nil
    @State private var priceError: String? = nil

    // Number formatter untuk harga dengan pemisah ribuan (misalnya "15.000")
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()

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

                Button {
                    withAnimation {
                        isExpanded.toggle()
                        editedName = product.name
                        // Set nilai awal priceInput dan formattedPrice
                        priceInput = String(format: "%.0f", product.price)
                        formattedPrice = numberFormatter.string(
                            from: NSNumber(value: product.price)) ?? priceInput
                        nameError = nil
                        priceError = nil
                    }
                } label: {
                    Text("Ubah")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
            .background(Color.white)

            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {

                    // Input Nama Produk
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nama Produk")
                            .font(.caption)
                            .foregroundColor(.black)

                        TextField("Masukkan nama produk", text: $editedName)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: editedName) {
                                validateName()
                            }

                        if let error = nameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Text("Maksimal 25 karakter")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Input Harga Produk
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Harga Produk")
                            .font(.caption)
                            .foregroundColor(.black)

                        TextField("Masukkan harga", text: $formattedPrice)
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: formattedPrice) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                // Simpan nilai asli tanpa format
                                priceInput = filtered
                                
                                // Format ulang untuk display jika ada angka
                                if let number = Int(filtered), !filtered.isEmpty {
                                    formattedPrice = numberFormatter.string(
                                        from: NSNumber(value: number)) ?? filtered
                                } else {
                                    formattedPrice = filtered
                                }
                                
                                _ = validatePrice()
                            }

                        if let error = priceError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Text("Hanya angka")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    HStack(spacing: 12) {
                        Button {
                            withAnimation {
                                isExpanded = false
                            }
                        } label: {
                            Text("Batal")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(.white))
                                .cornerRadius(12)
                        }

                        Button {
                            // Saat menyimpan, validasi mengizinkan field kosong.
                            // Jika validasi lulus, maka simpan perubahannya.
                            if validateName() && validatePrice() {
                                saveChanges()
                            }
                        } label: {
                            Text("Simpan")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        // Jika Anda ingin tombol save tetap aktif walaupun kosong, sesuaikan logikanya.
                        // Contoh: .disabled(false)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
    }

    // Jika ingin tombol save aktif meskipun field kosong, hapus pengecekan !editedName.isEmpty dan !priceInput.isEmpty
    private var canSave: Bool {
        nameError == nil && priceError == nil
    }

    @discardableResult
    private func validateName() -> Bool {
        let trimmed = editedName.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            nameError = "Nama tidak boleh kosong"
            return false
        }

        if editedName.first?.isWhitespace == true {
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

    private func saveChanges() {
        // Mengijinkan penyimpanan walaupun name atau harga kosong.
        // Jika harga tidak terkonversi, gunakan nilai default (misalnya 0).
        let newPrice = Double(priceInput) ?? 0
        product.name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        product.price = newPrice
        try? context.save()
        withAnimation {
            isExpanded = false
        }
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
