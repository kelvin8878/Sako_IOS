import Foundation
import SwiftData

// MARK: - Product Model
@Model
final class Product {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var price: Int
    var items: [ProductOnSale]?  // Relasi ke ProductOnSale
    
    init(name: String, price: Int) {
        self.name = name
        self.price = max(0, price)
    }
}

// MARK: - ProductOnSale Model (Junction Table)
@Model
final class ProductOnSale {
    @Attribute(.unique) var id: UUID = UUID()
    var product: Product // Relasi ke Product
    var quantity: Int
    var priceAtSale: Int
    var sale: Sale? // Relasi ke Sale
    
    init(product: Product, quantity: Int, priceAtSale: Int? = nil) {
        self.product = product
        self.quantity = max(1, quantity)
        self.priceAtSale = priceAtSale ?? product.price
    }
}

// MARK: - Sale Model
@Model
final class Sale {
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date
    var items: [ProductOnSale] = []
    
    // Computed property: Total harga transaksi
    var totalPrice: Int {
        items.reduce(0) { $0 + ($1.priceAtSale * $1.quantity) }
    }
    
    // Computed property: Daftar nama produk + quantity
    var productNames: String {
        items.map { "\($0.product.name) × \($0.quantity)" }.joined(separator: ", ")
    }
    
    init(date: Date) {
        self.date = date
    }
}
