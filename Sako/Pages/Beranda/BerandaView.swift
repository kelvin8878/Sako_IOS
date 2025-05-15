import SwiftUI
import SwiftData
import TipKit

struct BerandaView: View {
    @Query private var allSales: [Sale]
    
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
            ($0.key, $0.value.revenue, $0.value.quantity)
        }

        return products.sorted { $0.revenue > $1.revenue }

        .prefix(10)
        .map { $0 }
    }

    var totalRevenue: Int {
        rankedProducts.reduce(0) { $0 + $1.revenue }
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
                            Text("Chart Mingguan") // placeholder
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
    }
}

// MARK: - Date Picker Button (Popover)
private func DatePickerButton(selectedDate: Binding<Date>, isPresented: Binding<Bool>) -> some View {
    Button(action: {
        withAnimation {
            isPresented.wrappedValue.toggle()
        }
    }) {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 17))
                .foregroundColor(.primary)
            Text(selectedDate.wrappedValue.toMonthYearString())
                .font(.system(size: 17))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.down")
                .font(.system(size: 17))
                .foregroundColor(.primary)
                .rotationEffect(.degrees(isPresented.wrappedValue ? 180 : 0))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(12)
        .frame(width: 205, height: 36)
    }
    .popover(isPresented: isPresented, arrowEdge: .top) {
        VStack {
            MonthYearPicker(selectedDate: selectedDate)
                .frame(width: 300, height: 200)
                .presentationCompactAdaptation(.popover)
        }
        .padding()
    }
}

// MARK: - Preview
#Preview {
    BerandaView()
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure()
        }
}
