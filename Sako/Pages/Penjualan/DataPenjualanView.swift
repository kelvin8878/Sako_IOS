import SwiftUI

// MARK: - Data Models
struct Order: Identifiable {
    let id = UUID()
    let number: Int  // Order number
    let items: [OrderItem]
    let date: Date
}

struct OrderItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let quantity: Int
}

// MARK: - Main View
struct DataPenjualanView: View {
    @State private var searchText = ""
    @State private var orders: [Order] = [
        Order(number: 1, items: [
            OrderItem(name: "Nasi Goreng", price: 25000, quantity: 2),
            OrderItem(name: "Es Teh", price: 5000, quantity: 1),
            OrderItem(name: "Ayam Goreng", price: 15000, quantity: 1),
            OrderItem(name: "Sate Ayam", price: 20000, quantity: 2)
        ], date: Date()),
        Order(number: 2, items: [
            OrderItem(name: "Mie Ayam", price: 20000, quantity: 1),
            OrderItem(name: "Ayam Bakar", price: 35000, quantity: 3),
            OrderItem(name: "Pecel Lele", price: 100000, quantity: 10)
        ], date: Date())
    ]
    
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    @State private var expandedOrders: Set<UUID> = []
    @Environment(\.dismiss) var dismiss
    
    private var filteredOrders: [Order] {
        if searchText.isEmpty {
            return orders
        } else {
            return orders.filter { order in
                order.items.contains { item in
                    item.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    private var totalSales: Int {
        orders.flatMap { $0.items }.reduce(0) { $0 + ($1.price * $1.quantity) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Simplified Header
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Kembali")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("Data Penjualan")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    NavigationLink(destination: TambahPenjualanView()) {
                        Text("Tambah")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color(.blue)) // atau .blue
                    }
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "F2F2F7"))
                
                // Search and Date Picker
                HStack(spacing: 12) {
                    Button(action: { showingDatePicker = true }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color("CustomPrimaryColor"))
                            
                            Text(selectedDate.formatted(date: .numeric, time: .omitted))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    
                    // Search Field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("CustomPrimaryColor"))
                        
                        TextField("", text: $searchText)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Mau cari apa?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Total Sales Card
                HStack(spacing: 12) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Penjualan")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                        
                        Text("Rp\(totalSales.formattedWithSeparator)")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color("CustomPrimaryColor"))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                
                // Orders List
                LazyVStack(spacing: 12) {
                    ForEach(filteredOrders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Order \(order.number)")
                                    .font(.system(size: 16, weight: .bold))
                                Spacer()
                                Text("Rp\(order.items.reduce(0) { $0 + ($1.price * $1.quantity) }.formattedWithSeparator)")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(.bottom, 8)
                            
                            Divider()
                                .background(Color(.systemGray4))
                            
                            ForEach(expandedOrders.contains(order.id) ? order.items : Array(order.items.prefix(3))) { item in
                                HStack {
                                    Text(item.name)
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                    Text("\(item.quantity)x")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                            }
                            
                            if order.items.count > 3 {
                                Button(action: {
                                    withAnimation {
                                        if expandedOrders.contains(order.id) {
                                            expandedOrders.remove(order.id)
                                        } else {
                                            expandedOrders.insert(order.id)
                                        }
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        Text(expandedOrders.contains(order.id) ? "Lihat lebih sedikit" : "Lihat lebih banyak")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color("CustomPrimaryColor"))
                                        Image(systemName: expandedOrders.contains(order.id) ? "chevron.up" : "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("CustomPrimaryColor"))
                                    }
                                    .padding(.top, 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        .contentShape(Rectangle())
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingDatePicker) {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()
                
                Button("Selesai") {
                    showingDatePicker = false
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("CustomPrimaryColor"))
                .padding(.bottom, 16)
            }
            .presentationDetents([.height(400)])
        }
    }
}

// MARK: - Extensions
extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Previews
#Preview {
    DataPenjualanView()
}
