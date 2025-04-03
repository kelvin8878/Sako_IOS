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
                VStack() {
                    // Header Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tambah Produk")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(.black))
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                        
                        // Nama Produk Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nama Produk")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 4)
                            
                            TextField("Contoh: Nasi Goreng", text: $name)
                                .font(.system(size: 18))
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.white))
                                )
                            
                            Text("*Maksimal 20 Karakter")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .italic()
                                .padding(.horizontal, 8)
                        }
                        .padding(16)
                        
                        // Harga Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Harga")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 4)
                            
                            TextField("Contoh: 15.000", text: Binding(
                                get: { price },
                                set: { price = formatPrice($0) }
                            ))
                            .font(.system(size: 18))
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.white))
                            )
                            
                            Text("*Hanya Angka")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .italic()
                                .padding(.horizontal, 8)
                        }
                        .padding(16)
                    }
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        dismiss()
                        onDismiss()
                    }
                    .font(.system(size:20,weight:.semibold))
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveProduct()
                        dismiss()
                        onDismiss()
                    }
                    .font(.system(size:20,weight:.semibold))
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
