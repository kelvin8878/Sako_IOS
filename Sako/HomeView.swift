//
//  ContentView.swift
//  Sako
//
//  Created by Ammar Sufyan on 26/03/25.
//

import SwiftUI
import Charts

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showTotal = true
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack {
                Text("Rekap Data Penjualan")
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.green)
            
            // Buttons Row
            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Data Penjualan")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "shippingbox.fill")
                        Text("Data Produk")
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
            
            // Total Sales Circle Chart
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: 0.8) // Example sales percentage
                        .stroke(Color.green, lineWidth: 20)
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("Total")
                            .font(.headline)
                        Text(showTotal ? "Rp5.000.000" : "******")
                            .font(.title2).bold()
                        
                        Button(action: { showTotal.toggle() }) {
                            Image(systemName: showTotal ? "eye.slash.fill" : "eye.fill")
                                .padding(8)
                                .background(Color(UIColor.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            
            // Product List
            VStack(alignment: .leading) {
                Text("Produk")
                    .font(.headline)
                    .padding(.leading)
                
                VStack {
                    ForEach(1...3, id: \..self) { _ in
                        HStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                            Text("Produk")
                            Spacer()
                            Text("100.000")
                        }
                        .padding()
                        .background(Color.white)
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Pilih Bulan & Tahun", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                Button("Done") {
                    showDatePicker = false
                }
                .padding()
            }
            .presentationDetents([.height(300)])
        }
    }
}

#Preview {
    HomeView()
}
