import SwiftUI
import SwiftData
import TipKit

struct BerandaView: View {
    @Query private var allSales: [Sale]
    
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showTotal = true
    @State private var selectedProduct: (name: String, revenue: Int, quantity: Int, color: Color)? = nil
    @State private var showFloatingPreview = false
    @State private var previewPosition: CGPoint = .zero

    let colors: [Color] = [.red, .blue, .orange, .green, .purple, .yellow, .pink, .indigo, .teal, .mint]

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
        
        return Array(
            productStats.map { ($0.key, $0.value.revenue, $0.value.quantity) }
                .sorted { $0.revenue > $1.revenue }
                .prefix(10)
        )
    }
    
    var totalRevenue: Int {
        rankedProducts.reduce(0) { $0 + $1.revenue }
    }
    
    var chartSegments: [ChartSegment] {
        let total = Double(totalRevenue)
        var segments: [ChartSegment] = []
        var currentAngle = -90.0
        
        for (index, product) in rankedProducts.enumerated() {
            let percent = Double(product.revenue) / total
            let end = currentAngle + (percent * 360)
            segments.append(
                ChartSegment(
                    name: product.name,
                    revenue: product.revenue,
                    quantity: product.quantity,
                    color: colors[index % colors.count],
                    start: currentAngle,
                    end: end
                )
            )
            currentAngle = end
        }
        return segments
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Rekap Penjualan")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        ZStack {
                            NavigationLink(destination: DataPenjualanView()) {
                                shortcutCard(icon: "dollarsign.circle.fill", title: "Kelola\nPenjualan")
                            }
                        }
                        .popoverTip(DataPenjualanTip())
                        
                        ZStack {
                            NavigationLink(destination: DataProdukView()) {
                                shortcutCard(icon: "shippingbox.fill", title: "Kelola\nProduk")
                            }
                        }
                        .popoverTip(DataProdukTip())
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text(selectedDate.toMonthYearString())
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .onTapGesture {
                        showDatePicker.toggle()
                    }

                    DonutChartView(
                        segments: chartSegments,
                        totalRevenue: totalRevenue,
                        showTotal: $showTotal,
                        selectedProduct: $selectedProduct,
                        showFloatingPreview: $showFloatingPreview,
                        previewPosition: $previewPosition
                    )

                    VStack(alignment: .leading) {
                        if(!rankedProducts.isEmpty) {
                            Text("Penjualan (Tertinggi ke Terendah)")
                                .font(.headline)
                                .padding(.leading)
                        }
                        
                        LazyVStack(spacing: 8) {
                            ForEach(Array(rankedProducts.enumerated()), id: \.1.name) { index, product in
                                HStack {
                                    Circle()
                                        .fill(colors[index % colors.count])
                                        .frame(width: 12, height: 12)
                                    Text(product.name)
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("Rp\(product.revenue.formatted())")
                                            .bold()
                                        Text("\(product.quantity) terjual")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .background(Color(UIColor.systemGray6))
            .sheet(isPresented: $showDatePicker) {
                MonthYearPickerView(selectedDate: $selectedDate, isPresented: $showDatePicker)
            }
            .overlay(
                Group {
                    if showFloatingPreview, let product = selectedProduct {
                        let percentage = Double(product.revenue) / Double(totalRevenue) * 100
                        FloatingPreviewView(
                            product: product,
                            percentage: percentage,
                            position: previewPosition,
                            dismissAction: { showFloatingPreview = false }
                        )
                    }
                }
            )
        }
        .navigationTitle("")
    }

    private func shortcutCard(icon: String, title: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 40))
            Text(title)
                .multilineTextAlignment(.center)
                .font(.system(size: 20))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
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
