//
//  DataPenjualanView.swift
//  Sako
//
//  Created by Ammar Sufyan on 27/03/25.
//

import SwiftUI

struct DataPenjualanView: View {
    @State private var searchText = ""
    
    // Sample sales data (name and amount only)
    let salesData: [(name: String, amount: Int)] = [
        (name: "Produk A", amount: 1500000),
        (name: "Produk B", amount: 2500000),
        (name: "Produk C", amount: 1800000),
        (name: "Produk D", amount: 3200000),
        (name: "Produk E", amount: 2100000),
        (name: "Produk F", amount: 2900000),
        (name: "Produk G", amount: 1700000),
        (name: "Produk H", amount: 2300000)
    ]
    
    // Filtered data based on search text
    var filteredSales: [(name: String, amount: Int)] {
        if searchText.isEmpty {
            return salesData
        } else {
            return salesData.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                "\($0.amount)".contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header with title and search bar below
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Data Penjualan")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        
                        // Search bar placed below the title
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Cari penjualan...", text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(.white)
                    
                    // Sales data list with white rows
                    LazyVStack(spacing: 8) {
                        ForEach(filteredSales.indices, id: \.self) { index in
                            let sale = filteredSales[index]
                            
                            HStack {
                                Text(sale.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("Rp\(sale.amount.formatted())")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
                        }
                    }
                }
                .background(Color(.systemGray6))
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DataPenjualanView()
}
