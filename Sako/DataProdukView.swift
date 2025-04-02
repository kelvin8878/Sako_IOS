import SwiftUI

struct DataProdukView: View {
    @State private var searchText = ""
    @State private var showAddProduct = false
    
    @State private var products = [
        Product(name: "Nasi", price: "4.000"),
        Product(name: "Nasi 1/2", price: "4.000"),
        Product(name: "Ayam A", price: "10.000"),
        Product(name: "Sayur A", price: "5.000")
    ]
    
    @State private var editingProduct: Product?
    
    @Environment(\.dismiss) var dismiss
    
    struct Product: Identifiable, Equatable {
        let id = UUID()
        var name: String
        var price: String
    }
    
    var filteredProducts: [Product] {
        searchText.isEmpty ? products : products.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 2)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        TextField("Cari produk...", text: $searchText)
                            .textFieldStyle(.plain)
                            .padding(.vertical, 10)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)
                
                // Product List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredProducts) { product in
                            ProductCard(
                                product: product,
                                isEditing: editingProduct?.id == product.id,
                                onEdit: { editingProduct = product },
                                onSave: { updatedProduct in
                                    if let index = products.firstIndex(where: { $0.id == product.id }) {
                                        products[index] = updatedProduct
                                    }
                                    editingProduct = nil
                                },
                                onDelete: {
                                    if let index = products.firstIndex(where: { $0.id == product.id }) {
                                        products.remove(at: index)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Data Produk")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Back Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Kembali")
                            .foregroundColor(.blue)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                
                // Add Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tambah") {
                        showAddProduct = true
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .disabled(editingProduct != nil)
                }
            }
            .sheet(isPresented: $showAddProduct) {
                TambahProdukView(
                    products: $products,
                    mode: .add,
                    onDismiss: { showAddProduct = false }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ProductCard: View {
    let product: DataProdukView.Product
    let isEditing: Bool
    let onEdit: () -> Void
    let onSave: (DataProdukView.Product) -> Void
    let onDelete: () -> Void
    
    @State private var editedProduct: DataProdukView.Product
    
    init(product: DataProdukView.Product, isEditing: Bool, onEdit: @escaping () -> Void, onSave: @escaping (DataProdukView.Product) -> Void, onDelete: @escaping () -> Void) {
        self.product = product
        self.isEditing = isEditing
        self.onEdit = onEdit
        self.onSave = onSave
        self.onDelete = onDelete
        self._editedProduct = State(initialValue: product)
    }
    
    var body: some View {
        HStack {
            if isEditing {
                // Edit Mode
                VStack(alignment: .leading, spacing: 16) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nama Produk")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Masukkan nama", text: $editedProduct.name)
                            .font(.system(size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                    }
                    
                    // Price Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Harga")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Masukkan harga", text: Binding(
                            get: { editedProduct.price },
                            set: { editedProduct.price = formatPrice($0) }
                        ))
                        .font(.system(size: 18))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.vertical, 8)
                    }
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(action: onDelete) {
                            Text("Hapus")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        Button(action: { onSave(editedProduct) }) {
                            Text("Simpan")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            } else {
                // Display Mode
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("Rp \(product.price)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.trailing, 16)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isEditing ? Color.blue : Color.gray.opacity(0.3), lineWidth: isEditing ? 2 : 1)
        )
        .animation(.easeInOut, value: isEditing)
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

#Preview {
    DataProdukView()
}
