import SwiftUI

struct DataProdukView: View {
    @State private var searchText = ""
    @State private var showAddProduct = false
    @State private var products = [
        Product(name: "Nasi", price: "4.000", category: "Nasi"),
        Product(name: "Nasi 1/2", price: "4.000", category: "Nasi"),
        Product(name: "Ayam A", price: "10.000", category: "Ayam"),
        Product(name: "Sayur A", price: "5.000", category: "Sayur")
    ]
    @State private var editingProduct: Product?
    @State private var categories = ["Nasi", "Ayam", "Sayur", "Minuman", "Dessert"]
    
    struct Product: Identifiable, Equatable {
        let id = UUID()
        var name: String
        var price: String
        var category: String
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
                                categories: categories,
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
                    Button("Kembali") {
                        NavigationUtil.popToRootView()
                    }
                }
                
                // Add Button - Changed from "+" to "Tambah"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tambah") {
                        showAddProduct = true
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .disabled(editingProduct != nil)
                }
            }
            .sheet(isPresented: $showAddProduct) {
                AddEditProductView(
                    products: $products,
                    categories: $categories,
                    mode: .add,
                    onDismiss: { showAddProduct = false }
                )
            }
        }
    }
}

struct ProductCard: View {
    let product: DataProdukView.Product
    let isEditing: Bool
    let categories: [String]
    let onEdit: () -> Void
    let onSave: (DataProdukView.Product) -> Void
    let onDelete: () -> Void
    
    @State private var editedProduct: DataProdukView.Product
    @State private var showingCategoryPicker = false
    
    init(product: DataProdukView.Product, isEditing: Bool, categories: [String], onEdit: @escaping () -> Void, onSave: @escaping (DataProdukView.Product) -> Void, onDelete: @escaping () -> Void) {
        self.product = product
        self.isEditing = isEditing
        self.categories = categories
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
                    
                    // Price Field with automatic formatting
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
                    
                    // Category Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Kategori")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        HStack {
                            Text(editedProduct.category)
                                .font(.system(size: 18))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            Button(action: { showingCategoryPicker.toggle() }) {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $showingCategoryPicker) {
                            CategoryPickerView(
                                categories: categories,
                                selectedCategory: $editedProduct.category
                            )
                        }
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
                        
                        Text(product.category)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.black)
                            .cornerRadius(20)
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
    
    // Automatic price formatting function
    private func formatPrice(_ price: String) -> String {
        // Remove all non-digit characters
        let cleanPrice = price.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Format with thousand separators
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

struct CategoryPickerView: View {
    let categories: [String]
    @Binding var selectedCategory: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                    dismiss()
                }) {
                    HStack {
                        Text(category)
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if category == selectedCategory {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Pilih Kategori")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Selesai") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddEditProductView: View {
    enum Mode {
        case add
        case edit(product: DataProdukView.Product)
    }
    
    @Binding var products: [DataProdukView.Product]
    @Binding var categories: [String]
    let mode: Mode
    let onDismiss: () -> Void
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var category: String = ""
    @State private var newCategory: String = ""
    @State private var showingCategoryPicker = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header: Text("INFORMASI PRODUK")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 16)
                ) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Nama Produk")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Contoh: Nasi Goreng", text: $name)
                            .font(.system(size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                    }
                    .padding(.vertical, 8)
                    
                    // Price Field with automatic formatting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Harga")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Contoh: 15.000", text: Binding(
                            get: { price },
                            set: { price = formatPrice($0) }
                        ))
                        .font(.system(size: 18))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.vertical, 8)
                    }
                    .padding(.vertical, 8)
                    
                    // Category Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Kategori")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        // Existing Categories
                        HStack {
                            Text(category.isEmpty ? "Pilih Kategori" : category)
                                .font(.system(size: 18))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            Button(action: { showingCategoryPicker.toggle() }) {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $showingCategoryPicker) {
                            CategoryPickerView(
                                categories: categories,
                                selectedCategory: $category
                            )
                        }
                        
                        // Add New Category
                        HStack {
                            TextField("Kategori Baru", text: $newCategory)
                                .font(.system(size: 18))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                if !newCategory.isEmpty && !categories.contains(newCategory) {
                                    categories.append(newCategory)
                                    category = newCategory
                                    newCategory = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                if case .edit = mode {
                    Section {
                        Button(role: .destructive) {
                            if let index = products.firstIndex(where: { $0.id == (mode.product?.id ?? UUID()) }) {
                                products.remove(at: index)
                            }
                            dismiss()
                            onDismiss()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Hapus Produk")
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        dismiss()
                        onDismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveProduct()
                        dismiss()
                        onDismiss()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .disabled(name.isEmpty || price.isEmpty || category.isEmpty)
                }
            }
            .onAppear {
                if case let .edit(product) = mode {
                    name = product.name
                    price = product.price
                    category = product.category
                } else if !categories.isEmpty {
                    category = categories[0]
                }
            }
        }
    }
    
    private func saveProduct() {
        let newProduct = DataProdukView.Product(
            name: name,
            price: price,
            category: category
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
    
    // Automatic price formatting function
    private func formatPrice(_ price: String) -> String {
        // Remove all non-digit characters
        let cleanPrice = price.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Format with thousand separators
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

extension AddEditProductView.Mode {
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

class NavigationUtil {
    static func popToRootView() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        if let window = keyWindow {
            findNavigationController(viewController: window.rootViewController)?
                .popToRootViewController(animated: true)
        }
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else { return nil }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}

#Preview {
    DataProdukView()
}

#Preview("Dark Mode") {
    DataProdukView()
        .preferredColorScheme(.dark)
}
