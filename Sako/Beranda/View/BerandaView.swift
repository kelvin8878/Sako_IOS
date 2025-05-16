import SwiftUI
import SwiftData
import TipKit

struct BerandaView: View {
    @Query private var allSales: [Sale]
    @Environment(\.modelContext) private var context
    @State private var selectedDate = Date()
    @State private var isPresented = false
    @State private var showTop10 = false
    
    // Call to BerandaLogic for filtered sales, ranked products, and total revenue
    var filteredSales: [Sale] {
        BerandaLogic.filteredSales(from: allSales, by: selectedDate)
    }
    
    var weeklyRevenue: [Int] {
        filteredSales.totalRevenuePerWeek(inMonthOf: selectedDate)
    }
    
    var rankedProducts: [(name: String, revenue: Int, quantity: Int)] {
        BerandaLogic.rankedProducts(from: filteredSales)
    }

    var totalRevenue: Int {
        BerandaLogic.totalRevenue(from: filteredSales)
    }

    var previousMonthRevenue: Int {
        BerandaLogic.previousMonthRevenue(allSales: allSales, selectedDate: selectedDate)
    }

    var revenueChange: (symbol: String, value: Int, color: Color) {
        BerandaLogic.revenueChange(current: totalRevenue, previous: previousMonthRevenue)
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
                        TotalPendapatanView(totalRevenue: totalRevenue, revenueChange: revenueChange)
                        
                        // Chart mingguan - Using our updated ChartMingguanView
                        ChartMingguanView(weeklyRevenue: weeklyRevenue)

                        // Produk Terlaris
                        ProdukTerlarisView(rankedProducts: rankedProducts, showTop10: $showTop10)
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
