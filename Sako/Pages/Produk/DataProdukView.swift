import SwiftUI
import SwiftData

struct DataProdukView: View {
    @Environment(\.dismiss) var dismiss
    @Query var products: [Product]
    @State private var showTambahProduk = false
    @State private var searchText = ""

    var filteredProducts: [Product] {
        searchText.isEmpty ? products : products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 🔼 Header: Kembali + Tambah
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Kembali")
                    }
                }
                .foregroundColor(.blue)

                Spacer()

                Button {
                    showTambahProduk = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Tambah")
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // �️ White background for title and search
            VStack(alignment: .leading, spacing: 12) {
                // 🏷️ Judul
                Text("Data Produk")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                
                // 🔍 Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Cari produk...", text: $searchText)
                        .autocorrectionDisabled()
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .background(Color.white)
            
            // 📦 List Produk with gray background
            if filteredProducts.isEmpty {
                // Empty State View
                VStack(spacing: 12) {
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    
                    Text("Belum ada produk")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredProducts) { product in
                            ProductCardView(product: product)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                .background(Color(.white))
            }
        }
        .sheet(isPresented: $showTambahProduk) {
            TambahProdukView()
                .presentationDetents([.large])
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DataProdukView()
}
