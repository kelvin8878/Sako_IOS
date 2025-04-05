import Foundation
import SwiftData

// MARK: - Product Model
@Model
final class Product {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var price: Double
    var items: [ProductOnSale]?  // Relasi ke ProductOnSale
    
    init(name: String, price: Double) {
        self.name = name
        self.price = max(0, price)  // Pastikan harga tidak negatif
    }
}

// MARK: - ProductOnSale Model (Junction Table)
@Model
final class ProductOnSale {
    @Attribute(.unique) var id: UUID = UUID()
    var product: Product
    var quantity: Int
    var priceAtSale: Double  // Harga saat transaksi
    var sale: Sale?  // Relasi balik ke Sale
    
    init(product: Product, quantity: Int, priceAtSale: Double? = nil) {
        self.product = product
        self.quantity = max(1, quantity)  // Quantity minimal 1
        self.priceAtSale = priceAtSale ?? product.price  // Simpan harga saat ini jika tidak ada
    }
}

// MARK: - Sale Model
@Model
final class Sale {
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date
    var items: [ProductOnSale] = []
    
    // Computed property: Total harga transaksi
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.priceAtSale * Double($1.quantity)) }
    }
    
    // Computed property: Daftar nama produk + quantity
    var productNames: String {
        items.map { "\($0.product.name) × \($0.quantity)" }.joined(separator: ", ")
    }
    
    init(date: Date) {
        self.date = date
    }
    
    // Method untuk menambahkan produk ke sale
    func addProduct(product: Product, quantity: Int) {
        let item = ProductOnSale(product: product, quantity: quantity)
        items.append(item)
    }
}
