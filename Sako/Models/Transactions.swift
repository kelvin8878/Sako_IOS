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
    var product: Product
    var quantity: Int
    var priceAtSale: Int
    var sale: Sale?  // Relasi ke Sale
    
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
    
    // Total pendapatan dari transaksi ini
    var totalPrice: Int {
        items.reduce(0) { $0 + ($1.priceAtSale * $1.quantity) }
    }

    // Ringkasan nama produk dalam satu transaksi
    var productNames: String {
        items.map { "\($0.product.name) × \($0.quantity)" }
            .joined(separator: ", ")
    }
    
    init(date: Date) {
        self.date = date
    }
}

// MARK: - Helper untuk Grouping Pendapatan per Minggu (di ViewModel atau View)
extension Array where Element == Sale {
    /// Mengembalikan array [Int] berisi total pendapatan per minggu (4 minggu)
    func totalRevenuePerWeek(inMonthOf selectedDate: Date) -> [Int] {
        var weeklyTotals = [0, 0, 0, 0] // Minggu ke-1 s.d. ke-4
        let calendar = Calendar.current
        
        for sale in self {
            // Hanya transaksi yang ada di bulan yang dipilih
            guard calendar.isDate(sale.date, equalTo: selectedDate, toGranularity: .month) else { continue }
            let day = calendar.component(.day, from: sale.date)
            
            switch day {
            case 1...7:
                weeklyTotals[0] += sale.totalPrice
            case 8...14:
                weeklyTotals[1] += sale.totalPrice
            case 15...21:
                weeklyTotals[2] += sale.totalPrice
            default:
                weeklyTotals[3] += sale.totalPrice
            }
        }
        
        return weeklyTotals
    }
}
