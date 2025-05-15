import SwiftUI
import SwiftData
import TipKit

struct BerandaView: View {
    @Query private var allSales: [Sale]
    @Environment(\.modelContext) private var context
    @State private var selectedDate = Date()
    @State private var isPresented = false

    // MARK: - Data Filter & Agregasi
    var filteredSales: [Sale] {
        let calendar = Calendar.current
        return allSales.filter {
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .month)
        }
    }

    var rankedProducts: [(name: String, revenue: Int, quantity: Int)] {
        var productStats: [String: (revenue: Int, quantity: Int)] = [:]
        
        for sale in filteredSales {
            for item in sale.items {
                let revenue = Int(item.priceAtSale) * item.quantity
                productStats[item.product.name, default: (0, 0)].revenue += revenue
                productStats[item.product.name]?.quantity += item.quantity
            }
        }

        let products: [(name: String, revenue: Int, quantity: Int)] = productStats.map {
            (key, value) in (key, value.revenue, value.quantity)
        }

        return products
            .sorted(by: { (a, b) in a.revenue > b.revenue })
            .prefix(10)
            .map { $0 }
    }

    var totalRevenue: Int {
        filteredSales.reduce(0) { $0 + $1.totalPrice }
    }

    var previousMonthRevenue: Int {
        let calendar = Calendar.current
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) else {
            return 0
        }
        return allSales.filter {
            calendar.isDate($0.date, equalTo: previousMonth, toGranularity: .month)
        }
        .reduce(0) { $0 + $1.totalPrice }
    }

    var revenueChange: (symbol: String, value: Int, color: Color) {
        let selisih = totalRevenue - previousMonthRevenue
        if selisih > 0 {
            return ("↑", selisih, .green)
        } else if selisih < 0 {
            return ("↓", abs(selisih), .red)
        } else {
            return ("", 0, .gray)
        }
    }

    // MARK: - View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    Text("Rekap Penjualan")
                        .font(.system(size: 26, weight: .bold))
                        .padding(.horizontal)
                    
                    // Date Picker
                    DatePickerButton(selectedDate: $selectedDate, isPresented: $isPresented)
                        .padding(.horizontal)
                    
                    // Card Box
                    VStack(spacing: 20) {
                        // Total Pendapatan
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Pendapatan")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                Text("Rp \(totalRevenue.formattedWithSeparator())")
                                    .font(.title)
                                    .bold()
                                
                                Text("\(revenueChange.symbol) Rp \(revenueChange.value.formattedWithSeparator())")
                                    .font(.subheadline)
                                    .foregroundColor(revenueChange.color)
                                    .bold()
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        
                        // Chart Placeholder
                        VStack {
                            Text("Chart Mingguan") // Placeholder grafik
                                .foregroundColor(.white)
                        }
                        .frame(width: 305, height: 230)
                        .background(Color.gray)
                        .cornerRadius(12)
                        
                        // Produk Terlaris
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Produk Terlaris")
                                .font(.system(size: 22, weight: .semibold))
                                .padding(.horizontal, 10)
                            
                            if rankedProducts.isEmpty {
                                Text("Belum ada data penjualan bulan ini.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 10)
                            } else {
                                ForEach(Array(rankedProducts.prefix(3).enumerated()), id: \.offset) { index, product in
                                    HStack {
                                        Text("\(index + 1). \(product.name)")
                                            .font(.system(size: 16))
                                            .lineLimit(1)

                                        Spacer()

                                        VStack(alignment: .trailing) {
                                            Text("Rp \(product.revenue.formattedWithSeparator())")
                                                .font(.system(size: 16))
                                            Text("\(product.quantity) Terjual")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    
                                    if index < rankedProducts.prefix(3).count - 1 {
                                                Divider()
                                                    .background(Color.gray)
                                            }
                                }
                            }

                            HStack {
                                Spacer()
                                Text("Lihat lebih banyak")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemGray6))
        }
        .task {
            Seeder.seedInitialData(context: context)
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Product.self, ProductOnSale.self, Sale.self)
        let context = container.mainContext

        // RESET DATA SEBELUM SEEDING
        try? context.delete(model: Sale.self)
        try? context.delete(model: ProductOnSale.self)
        try? context.delete(model: Product.self)

        // Jalankan ulang Seeder
        Seeder.seedInitialData(context: context)

        return BerandaView()
            .modelContainer(container)
    } catch {
        return Text("Failed to load preview: \(error.localizedDescription)")
    }
}
