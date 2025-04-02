import SwiftUI

struct TambahProdukView: View {
    enum Mode {
        case add
        case edit(product: DataProdukView.Product)
    }
    
    @Binding var products: [DataProdukView.Product]
    let mode: Mode
    let onDismiss: () -> Void
    
    @State private var name: String = ""
    @State private var price: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("INFORMASI PRODUK")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.black))
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        // Nama Produk Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nama Produk")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("Contoh: Nasi Goreng", text: $name)
                                .font(.system(size: 16))
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                        )
                        
                        // Harga Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Harga")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("Contoh: 15.000", text: Binding(
                                get: { price },
                                set: { price = formatPrice($0) }
                            ))
                            .font(.system(size: 16))
                            .keyboardType(.numberPad)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                        )
                    }
                    
                    if case .edit = mode {
                        Button(role: .destructive) {
                            deleteProduct()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Hapus Produk")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.red)
                                    .shadow(color: .red.opacity(0.2), radius: 8, x: 0, y: 3)
                            )
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        dismiss()
                        onDismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveProduct()
                        dismiss()
                        onDismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.isEmpty || price.isEmpty)
                }
            }
            .onAppear {
                setupInitialValues()
            }
        }
    }
    
    private func setupInitialValues() {
        if case let .edit(product) = mode {
            name = product.name
            price = product.price
        }
    }
    
    private func saveProduct() {
        let newProduct = DataProdukView.Product(
            name: name,
            price: price
        )
        
        switch mode {
        case .add:
            products.append(newProduct)
        case .edit(let product):
            if let index = products.firstIndex(where: { $0.id == product.id }) {
                products[index] = newProduct
            }
        }
    }
    
    private func deleteProduct() {
        if let index = products.firstIndex(where: { $0.id == (mode.product?.id ?? UUID()) }) {
            products.remove(at: index)
        }
        dismiss()
        onDismiss()
    }
    
    private func formatPrice(_ price: String) -> String {
        let cleanPrice = price.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if let number = Int(cleanPrice) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: number)) ?? price
        }
        return price
    }
}

extension TambahProdukView.Mode {
    var title: String {
        switch self {
        case .add: return "Tambah Produk"
        case .edit: return "Edit Produk"
        }
    }
    
    var product: DataProdukView.Product? {
        switch self {
        case .add: return nil
        case .edit(let product): return product
        }
    }
}

struct TambahProdukView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TambahProdukView(
                products: .constant([]),
                mode: .add,
                onDismiss: {}
            )
            
            TambahProdukView(
                products: .constant([]),
                mode: .edit(product: DataProdukView.Product(name: "Nasi Goreng", price: "15.000")),
                onDismiss: {}
            )
            .previewDisplayName("Edit Mode")
        }
    } 
}
