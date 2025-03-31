//
//  ContentView.swift
//  Sako
//
//  Created by Ammar Sufyan on 26/03/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showTotal = true
    @State private var selectedProduct: (name: String, value: Int, color: Color)? = nil
    @State private var showFloatingPreview = false
    @State private var previewPosition: CGPoint = .zero
    
    let products = [
        ("Produk A", 150_000, Color.red),
        ("Produk B", 200_000, Color.blue),
        ("Produk C", 250_000, Color.orange),
        ("Produk D", 180_000, Color.green),
        ("Produk E", 220_000, Color.purple),
        ("Produk F", 190_000, Color.yellow),
        ("Produk G", 210_000, Color.pink),
        ("Produk H", 170_000, Color.indigo),
        ("Produk I", 230_000, Color.teal),
        ("Produk J", 200_000, Color.mint)
    ]
    
    var sortedProducts: [(name: String, value: Int, color: Color)] {
        products.sorted { $0.1 > $1.1 }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
    
    var totalSales: Int {
        products.reduce(0) { $0 + $1.1 }
    }
    
    var productAngles: [(name: String, value: Int, color: Color, start: Double, end: Double)] {
        var angles: [(String, Int, Color, Double, Double)] = []
        var currentAngle = -90.0
        let total = Double(totalSales)
        
        for product in products {
            let percentage = Double(product.1) / total
            let endAngle = currentAngle + (percentage * 360.0)
            angles.append((product.0, product.1, product.2, currentAngle, endAngle))
            currentAngle = endAngle
        }
        return angles
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    VStack(alignment: .leading) {
                        Text("Rekap Data Penjualan")
                            .font(.title2).bold()
                            .foregroundColor(.black)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemGray5))
                    
                    // Buttons Row
                    HStack(spacing: 16) {
                        NavigationLink(destination: DataPenjualanView()) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 30))
                                Text("Data\nPenjualan")
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: DataProdukView()) {
                            HStack {
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 30))
                                Text("Data\nProduk")
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Month Picker
                    HStack {
                        Text(dateFormatter.string(from: selectedDate))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .onTapGesture {
                        showDatePicker.toggle()
                    }
                    
                    // Sales Donut Chart with Floating Preview
                    ZStack {
                        VStack {
                            ZStack {
                                ForEach(productAngles, id: \.name) { product in
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat((product.end - product.start) / 360.0))
                                        .stroke(product.color, lineWidth: 20)
                                        .frame(width: 180, height: 180)
                                        .rotationEffect(.degrees(product.start))
                                        .onTapGesture { location in
                                            selectedProduct = (product.name, product.value, product.color)
                                            previewPosition = location
                                            showFloatingPreview = true
                                        }
                                }
                                
                                VStack {
                                    Text("Total")
                                        .font(.headline)
                                    Text(showTotal ? "Rp\(totalSales.formatted())" : "******")
                                        .font(.title2).bold()
                                    
                                    Button(action: { showTotal.toggle() }) {
                                        Image(systemName: showTotal ? "eye.slash.fill" : "eye.fill")
                                            .padding(8)
                                            .background(Color(UIColor.systemGray6))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        
                        if showFloatingPreview, let selected = selectedProduct {
                            FloatingPreviewView(
                                product: selected,
                                percentage: Double(selected.value) / Double(totalSales) * 100,
                                position: previewPosition
                            ) {
                                showFloatingPreview = false
                            }
                        }
                    }
                    .frame(height: 250)
                    
                    // Product List
                    VStack(alignment: .leading) {
                        Text("Produk (Tertinggi ke Terendah)")
                            .font(.headline)
                            .padding(.leading)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(sortedProducts, id: \.name) { product in
                                HStack {
                                    Circle()
                                        .fill(product.2)
                                        .frame(width: 12, height: 12)
                                    Text(product.0)
                                    Spacer()
                                    Text("Rp\(product.1.formatted())")
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
                }
                .background(Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all))
            }
            .sheet(isPresented: $showDatePicker) {
                MonthYearPickerWrapper(selectedDate: $selectedDate, isPresented: $showDatePicker)
            }
        }
        .navigationTitle("Rekap Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MonthYearPickerWrapper: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Pilih Bulan dan Tahun")
                .font(.headline)
                .padding(.top)
            
            MonthYearPicker(selectedDate: $selectedDate)
                .frame(height: 200)
            
            HStack {
                Button("Batal") {
                    isPresented = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray5))
                .foregroundColor(.black)
                .cornerRadius(10)
                
                Button("Selesai") {
                    isPresented = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .presentationDetents([.height(300)])
    }
}

struct MonthYearPicker: UIViewRepresentable {
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        
        // Set initial values
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        if let month = components.month, let year = components.year {
            let yearIndex = year - 2020
            picker.selectRow(month - 1, inComponent: 0, animated: false)
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: MonthYearPicker
        let months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni",
                     "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
        let years = Array(2020...2030).map { String($0) }
        
        init(_ parent: MonthYearPicker) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return months.count
            } else {
                return years.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return months[row]
            } else {
                return years[row]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let month = pickerView.selectedRow(inComponent: 0) + 1
            let year = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? 2020
            
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            
            if let date = Calendar.current.date(from: components) {
                parent.selectedDate = date
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            if component == 0 {
                return 150 // Wider for month names
            } else {
                return 80  // Narrower for years
            }
        }
    }
}

struct FloatingPreviewView: View {
    let product: (name: String, value: Int, color: Color)
    let percentage: Double
    let position: CGPoint
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let adjustedPosition = CGPoint(
                x: min(max(position.x, 120), geometry.size.width - 120),
                y: min(max(position.y, 120), geometry.size.height - 80)
            )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(product.color)
                        .frame(width: 12, height: 12)
                    Text(product.name)
                        .font(.headline)
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Nilai:")
                    Spacer()
                    Text("Rp\(product.value.formatted())")
                        .bold()
                }
                
                HStack {
                    Text("Persentase:")
                    Spacer()
                    Text(String(format: "%.1f%%", percentage))
                        .bold()
                }
            }
            .padding()
            .frame(width: 240)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .position(adjustedPosition)
            .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview {
    HomeView()
}
