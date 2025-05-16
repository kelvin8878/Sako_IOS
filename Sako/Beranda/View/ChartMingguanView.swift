import SwiftUI
import Charts

struct ChartMingguanView: View {
    var weeklyRevenue: [Int]
    
    
    var body: some View {
        VStack {
            // Bar chart with gridlines and scaling
            Chart {
                // Set up the bars with dynamic weeklyRevenue data
                ForEach(0..<weeklyRevenue.count, id: \.self) { index in
                    BarMark(
                        x: .value("Minggu", "\(index + 1)"),
                        y: .value("Pendapatan", weeklyRevenue[index])
                    )
                    .foregroundStyle(Color.green) // Set the bar color to green
                }
            }
            .frame(height: 200)
            .padding(.top, 5)
            .chartYAxis {
                AxisMarks(position: .leading, values: [0, 500000,1000000,2000000,3000000,4000000])
                
                // Position Y-axis on the left
            }

            // X-axis label (optional)
            Text("Minggu")
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
        }
        .padding()
        .frame(width: 305, height: 270) // Adjust frame size
//        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}
