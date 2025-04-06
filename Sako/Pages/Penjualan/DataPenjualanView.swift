import SwiftUI
import SwiftData

struct DataPenjualanView: View {
    @Environment(\.dismiss) var dismiss
    @Query var sales: [Sale]

    @State private var selectedDate: Date = Date()
    @State private var searchText: String = ""

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }

    private var totalPenjualan: Double {
        filteredSales.reduce(0) { $0 + $1.totalPrice }
    }

    // Filtered berdasarkan tanggal & search
    private var filteredSales: [Sale] {
        sales.filter { sale in
            let isSameDate = Calendar.current.isDate(sale.date, inSameDayAs: selectedDate)
            let matchesSearch = searchText.isEmpty || sale.productNames.localizedCaseInsensitiveContains(searchText)
            return isSameDate && matchesSearch
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 🔼 Header: Kembali + Tambah
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Kembali")
                    }
                }
                .foregroundColor(.blue)

                Spacer()

                Button {
                    // TODO: Tambah penjualan modal
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Tambah")
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)

            // 🏷️ Judul manual
            Text("Data Penjualan")
                .font(.system(size: 28, weight: .bold))
                .padding(.horizontal)

            // 📅 Compact DatePicker + 🔍 Search Bar
            HStack(spacing: 12) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(.blue)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    TextField("Cari Penjualan", text: $searchText)
                        .font(.callout)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)


            // 💰 Total Penjualan
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.white)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Penjualan")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Text("Rp\(Int(totalPenjualan).formattedWithSeparator())")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
            .background(Color.green)
            .cornerRadius(12)
            .padding(.horizontal)

            // 📋 List atau Empty State
            if filteredSales.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "cart.badge.questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)

                    Text("Belum ada penjualan untuk tanggal ini.")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(Array(filteredSales.enumerated()), id: \.element.id) { index, sale in
                        PenjualanCardView(sale: sale, index: index)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top)
    }
}

#Preview {
    DataPenjualanView()
}
