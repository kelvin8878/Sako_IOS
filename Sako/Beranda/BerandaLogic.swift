// MARK: - File: BerandaLogic.swift
import SwiftUI
import SwiftData

struct BerandaLogic {
    static func filteredSales(from sales: [Sale], by date: Date) -> [Sale] {
        let calendar = Calendar.current
        return sales.filter {
            calendar.isDate($0.date, equalTo: date, toGranularity: .month)
        }
    }

    static func rankedProducts(from sales: [Sale]) -> [(name: String, revenue: Int, quantity: Int)] {
        var productStats: [String: (revenue: Int, quantity: Int)] = [:]
        
        for sale in sales {
            for item in sale.items {
                let revenue = Int(item.priceAtSale) * item.quantity
                productStats[item.product.name, default: (0, 0)].revenue += revenue
                productStats[item.product.name]?.quantity += item.quantity
            }
        }
        
        let products: [(name: String, revenue: Int, quantity: Int)] = productStats.map { (key, value) in
            return (key, value.revenue, value.quantity)
        }

        // Tulis tipe parameter closure yang jelas
        return products
            .sorted { (a: (name: String, revenue: Int, quantity: Int), b: (name: String, revenue: Int, quantity: Int)) -> Bool in
                return a.revenue > b.revenue
            }
            .prefix(10)
            .map { $0 }
    }


    static func totalRevenue(from sales: [Sale]) -> Int {
        sales.reduce(0) { $0 + $1.totalPrice }
    }

    static func previousMonthRevenue(allSales: [Sale], selectedDate: Date) -> Int {
        let calendar = Calendar.current
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) else {
            return 0
        }
        return allSales.filter {
            calendar.isDate($0.date, equalTo: previousMonth, toGranularity: .month)
        }
        .reduce(0) { $0 + $1.totalPrice }
    }

    static func revenueChange(current: Int, previous: Int) -> (symbol: String, value: Int, color: Color) {
        let difference = current - previous
        if difference > 0 {
            return ("↑", difference, .green)
        } else if difference < 0 {
            return ("↓", abs(difference), .red)
        } else {
            return ("", 0, .gray)
        }
    }
}
