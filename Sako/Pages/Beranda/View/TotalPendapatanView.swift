import SwiftUI

struct TotalPendapatanView: View {
    var totalRevenue: Int
    var revenueChange: (symbol: String, value: Int, color: Color)

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Pendapatan")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text("Rp \(totalRevenue.formattedWithSeparator())")
                    .font(.title)
                    .bold()
                
                Text("\(revenueChange.symbol) Rp \(revenueChange.value.formattedWithSeparator())")
                    .font(.subheadline)
                    .foregroundColor(revenueChange.color)
                    .bold()
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
