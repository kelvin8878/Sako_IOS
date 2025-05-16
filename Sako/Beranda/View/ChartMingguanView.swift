import SwiftUI
import Charts

struct ChartMingguanView: View {
    var weeklyRevenue: [Int]
    @State private var selectedWeek: Int? = nil  // State untuk menyimpan minggu yang dipilih
    @State private var isFloatingViewVisible: Bool = false  // Untuk mengontrol visibilitas floating view
    @State private var floatingViewPosition: CGPoint = .zero  // Menyimpan posisi floating view
    
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
                AxisMarks(position: .leading, values: [0, 1000000, 2000000, 3000000, 4000000, 5000000])
            }
            .contentShape(Rectangle()) // Membuat seluruh area chart dapat ditekan

            // Menambahkan onTapGesture ke seluruh chart, tetapi menangkap bar yang dipilih
            .onTapGesture { location in
                if let selectedIndex = getTappedBarIndex(at: location) {
                    selectedWeek = selectedIndex
                    isFloatingViewVisible = true // Tampilkan floating view saat bar dipilih
                    floatingViewPosition = location // Menyimpan posisi klik untuk posisi floating view
                    
                    // Menyembunyikan floating view setelah 4 detik
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        isFloatingViewVisible = false
                    }
                }
            }
            
            // X-axis label (optional)
            Text("Minggu")
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
        }
        .padding()
        .frame(width: 305, height: 270) // Adjust frame size
        .overlay(
            // Overlay floating view when a bar is tapped
            Group {
                if isFloatingViewVisible, let selectedWeek = selectedWeek {
                    VStack(spacing: 5) { // Jarak antar teks yang lebih kecil
                        Text("Minggu Ke-\(selectedWeek + 1)")
                            .font(.headline)
                            .padding([.top, .horizontal]) // Padding hanya di sisi atas dan horizontal
                        Text("Rp \(weeklyRevenue[selectedWeek].formatted())")
                            .font(.body)
                            .padding([.bottom, .horizontal]) // Padding hanya di sisi bawah dan horizontal
                    }
                    .frame(width: 150, height: 80)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                    .position(floatingViewPosition) // Mengatur posisi floating view sesuai lokasi klik
                    .transition(.move(edge: .top))  // Animasi transisi
                    .zIndex(1) // Memastikan overlay berada di atas
                }
            }
        )
    }
    
    // Fungsi untuk mendeteksi bar yang diklik berdasarkan lokasi
    private func getTappedBarIndex(at location: CGPoint) -> Int? {
        let barWidth: CGFloat = 40  // Lebar setiap bar chart
        let spacing: CGFloat = 15   // Jarak antar bar chart
        let chartWidth: CGFloat = 305 // Lebar total chart
        
        let totalWidth = barWidth * CGFloat(weeklyRevenue.count) + spacing * CGFloat(weeklyRevenue.count - 1)
        
        // Hitung posisi index berdasarkan lokasi yang diklik
        let relativeLocation = location.x - (chartWidth - totalWidth) / 2 // Koreksi posisi awal
        
        // Temukan index berdasarkan posisi yang diklik
        let index = Int(relativeLocation / (barWidth + spacing))
        
        if index >= 0 && index < weeklyRevenue.count {
            return index
        }
        
        return nil
    }
}
