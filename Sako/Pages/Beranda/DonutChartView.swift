import SwiftUI

struct ChartSegment {
    var name: String
    var revenue: Int
    var quantity: Int
    var color: Color
    var start: Double
    var end: Double
}

struct DonutChartView: View {
    let segments: [ChartSegment]
    let totalRevenue: Int
    @Binding var showTotal: Bool
    @Binding var selectedProduct: (name: String, revenue: Int, quantity: Int, color: Color)?
    @Binding var showFloatingPreview: Bool
    @Binding var previewPosition: CGPoint
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 4) {
                    Text("Klik donut untuk melihat detail")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Image(systemName: "arrow.down.circle")
                        .font(.caption)
                        .foregroundColor    (.blue)
                }
                .padding(.bottom, 8)
                Spacer()
            }

            if segments.isEmpty {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 200, height: 200)
                    
                    Text("Belum ada penjualan")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                ZStack {
                    ForEach(segments, id: \.name) { segment in
                        ChartSegmentView(segment: segment) { location in
                            selectedProduct = (
                                name: segment.name,
                                revenue: segment.revenue,
                                quantity: segment.quantity,
                                color: segment.color
                            )
                            previewPosition = location
                            showFloatingPreview = true
                        }
                    }
                }
                
                VStack(spacing: 6) {
                    Text("Total Harga")
                        .font(.headline)
                    Text(showTotal ? "Rp\(totalRevenue.formatted())" : "***")
                        .font(.title2).bold()
                    Button(action: { showTotal.toggle() }) {
                        Image(systemName: showTotal ? "eye.slash.fill" : "eye.fill")
                            .padding(8)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(Circle())
                    }
                }
                .frame(width: 180)
            }
        }
        .frame(height: 270)
    }
}

struct ChartSegmentView: View {
    let segment: ChartSegment
    let action: (CGPoint) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .trim(from: 0.0, to: CGFloat((segment.end - segment.start) / 360.0))
                .stroke(segment.color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(segment.start))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            let localPoint = value.location
                            let globalPoint = CGPoint(
                                x: geometry.frame(in: .global).origin.x + localPoint.x,
                                y: geometry.frame(in: .global).origin.y + localPoint.y
                            )
                            action(globalPoint)
                        }
                )
        }
        .frame(width: 200, height: 200)
    }
}
