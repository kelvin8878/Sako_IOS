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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    Text("Rekap Penjualan")
                        .font(.system(size: 26, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HStack {
                        HStack {
                            Text(selectedDate.toMonthYearString())
                                .font(.system(size: 16))
                                .foregroundColor(.black)

                            Spacer(minLength: 8)

                            Image(systemName: "calendar")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                        }
                        .padding(.leading)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        .frame(width: 190, alignment: .leading) //  Tentukan ukuran frame
                        .onTapGesture {
                            showDatePicker.toggle()
                        }

                        Spacer() // Dorong box ke kiri
                    }
                    .padding(.horizontal)


                    ZStack(alignment: .top) {
                        VStack() {
                            
                            // TOTAL PENDAPATAN
                            HStack() {
                                VStack(alignment: .leading) {
                                    Text("Total Pendapatan")
                                        .font(.system(size:22))
                                        .background(Color("#212121"))
                                        .opacity(0.6)
                                        .bold()
                                        
                                    
                                    Text("Rp 888.888.888")
                                        .font(.title)
                                        .bold()

                                    Text("↑ Rp 10.000.000")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                        .bold()
                                }
                                
                                Spacer()
                            }
                            .padding([.leading, .trailing],10)
                            .padding(.bottom,20)
                            
                            // CHART
                            VStack(){
                                
                            }
                            .frame(width:305, height:230)
                            .background(Color.gray)
                            .padding(.bottom,20)
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Produk Terlaris")
                                        .font(.system(size:22))
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                .padding([.leading, .trailing],10)
                            }
                        }
                        .padding() // untuk margin dari tepi layar
                    }
                    .frame(width:360,height:610,alignment: .top)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        ZStack(alignment: .topLeading) {
                            if showDatePicker {
                                // 1. Lapisan transparan untuk menangkap tap di luar picker
                                Color.black.opacity(0.001)
                                    .ignoresSafeArea()
                                    .onTapGesture {
                                        withAnimation {
                                            showDatePicker = false
                                        }
                                    }

                                // 2. DatePicker tampil di atas lapisan transparan
                                VStack(){
                                    MonthYearPickerView(selectedDate: $selectedDate, isPresented: $showDatePicker)
                                        .frame(width: 280, height: 180)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 4)
                                        .padding(.top, 5) // jarak dari button
                                }
                                .padding(.horizontal)
                            }
                        }, alignment: .topLeading
                    )

                    
                    
                }
            }
            .background(Color(UIColor.systemGray6))
            

        }
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
