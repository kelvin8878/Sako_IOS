import SwiftUI
import SwiftData
import TipKit

struct ChartSegment {
    var name: String
    var revenue: Int
    var quantity: Int
    var color: Color
    var start: Double
    var end: Double
}

struct BerandaView: View {
    @Query private var allSales: [Sale]
    
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showTotal = true
    @State private var selectedProduct: (name: String, revenue: Int, quantity: Int, color: Color)? = nil
    @State private var showFloatingPreview = false
    @State private var previewPosition: CGPoint = .zero
    
    let dataProdukTip = DataProdukTip()
    let dataPenjualanTip = DataPenjualanTip()

    let colors: [Color] = [.red, .blue, .orange, .green, .purple, .yellow, .pink, .indigo, .teal, .mint]
    
    // MARK: - Computed Properties
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
    
    // MARK: - Date Formatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    shortcutButtons
                    datePickerSection
                    Text("Rekap Data Penjualan")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(UIColor.systemGray6))

                    // Shortcut Buttons
                    HStack(spacing: 16) {
                        NavigationLink(destination: DataPenjualanView()) {
                            shortcutCard(icon: "dollarsign.circle.fill", title: "Kelola\nPenjualan")
                        }
                        //Tip data penjualan
                        .popoverTip(dataPenjualanTip)
                        
                        
                        
                        NavigationLink(destination: DataProdukView()) {
                            shortcutCard(icon: "shippingbox.fill", title: "Kelola\nProduk")
                        }
                        //Tip data produk
                        .popoverTip(dataProdukTip)
                    }
                    .padding(.horizontal)

                    // Date Picker
                    HStack {
                        Text(dateFormatter.string(from: selectedDate))
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

                    // Donut Chart
                    ZStack {
                        ZStack {
                            ForEach(productAngles, id: \.name) { segment in
                                Circle()
                                    .trim(from: 0.0, to: CGFloat((segment.end - segment.start) / 360.0))
                                    .stroke(segment.color, lineWidth: 20)
                                    .frame(width: 180, height: 180)
                                    .rotationEffect(.degrees(segment.start))
                                    .onTapGesture { location in
                                        if let matching = rankedProductsByRevenue.first(where: { $0.name == segment.name }) {
                                            selectedProduct = (segment.name, matching.total, segment.color)
                                            previewPosition = location
                                            showFloatingPreview = true
                                        }
                                    }
                            }

                            VStack(spacing: 6) {
                                Text("Total Harga")
                                    .font(.headline)
                                Text(showTotal ? "Rp\(totalRevenue.formatted())" : "*****")
                                    .font(.title2).bold()
                                Button(action: { showTotal.toggle() }) {
                                    Image(systemName: showTotal ? "eye.slash.fill" : "eye.fill")
                                        .padding(8)
                                        .background(Color(UIColor.systemGray6))
                                        .clipShape(Circle())
                                }
                            }
                            .frame(width: 140)
                        }
                        .padding(.vertical)

                        if showFloatingPreview, let selected = selectedProduct {
                            FloatingPreviewView(
                                product: selected,
                                percentage: totalRevenue > 0 ? Double(selected.value) / Double(totalRevenue) * 100 : 0,
                                position: previewPosition
                            ) {
                                showFloatingPreview = false
                            }
                        }
                    }
                    .frame(height: 250)

                    // Ranking List
                    VStack(alignment: .leading) {
                        Text("Produk (Tertinggi ke Terendah)")
                            .font(.headline)
                            .padding(.leading)

                        LazyVStack(spacing: 8) {
                            ForEach(Array(rankedProductsByRevenue.enumerated()), id: \.1.name) { index, product in
                                HStack {
                                    Circle()
                                        .fill(colors[index % colors.count])
                                        .frame(width: 12, height: 12)
                                    Text(product.name)
                                    Spacer()
                                    Text("Rp\(product.total.formatted())")
                                        .bold()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                    
                    
                    DonutChartView(
                        segments: chartSegments,
                        totalRevenue: totalRevenue,
                        showTotal: $showTotal,
                        selectedProduct: $selectedProduct,
                        showFloatingPreview: $showFloatingPreview,
                        previewPosition: $previewPosition
                    )
                    
                    
                    productRankingSection
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
        .navigationTitle("Rekap Data")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    private var headerSection: some View {
        Text("Rekap Data Penjualan")
            .font(.system(size: 28, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(UIColor.systemGray6))
    }
    
    private var shortcutButtons: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: DataPenjualanView()) {
                shortcutCard(icon: "dollarsign.circle.fill", title: "Kelola\nPenjualan")
            }
            NavigationLink(destination: DataProdukView()) {
                shortcutCard(icon: "shippingbox.fill", title: "Kelola\nProduk")
            }
        }
        .padding(.horizontal)
    }
    
    private var datePickerSection: some View {
        HStack {
            Text(dateFormatter.string(from: selectedDate))
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
    }
    
    private var productRankingSection: some View {
        VStack(alignment: .leading) {
            Text("Penjualan (Tertinggi ke Terendah)")
                .font(.headline)
                .padding(.leading)
            
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
    
    // MARK: - Helper Views
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


//buat view canvas
#Preview {
    BerandaView()
       
        //untuk munculin tips
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
              //display untuk seberapa sering tips muncul
               // .displayFrequency(.immediate)
                .datastoreLocation(.applicationDefault)
            ])
        }
}
