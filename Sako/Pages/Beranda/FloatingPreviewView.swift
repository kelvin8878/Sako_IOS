import SwiftUI

struct FloatingPreviewView: View {
    let product: (name: String, revenue: Int, quantity: Int, color: Color)
    let percentage: Double
    let position: CGPoint
    let dismissAction: () -> Void
    
    @State private var opacity: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(product.color)
                    .frame(width: 12, height: 12)
                Text(product.name)
                    .font(.headline)
                Spacer()
                Button(action: dismissAction) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text("Rp\(product.revenue.formatted())")
                .bold()
            
            Text("\(product.quantity) terjual")
                .font(.subheadline)
            
            Text(String(format: "%.1f%%", percentage))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .position(position)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1
            }
            
            // Auto-dismiss after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    dismissAction()
                }
            }
        }
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


struct DonutChartView: View {
    let segments: [ChartSegment]
    let totalRevenue: Int
    @Binding var showTotal: Bool
    @Binding var selectedProduct: (name: String, revenue: Int, quantity: Int, color: Color)?
    @Binding var showFloatingPreview: Bool
    @Binding var previewPosition: CGPoint
    
    var body: some View {
        ZStack {
            // Donut Chart
            VStack {
                HStack(spacing: 4) {
                    Text("Klik donut untuk melihat detail")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Image(systemName: "arrow.down.circle")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 8)
                Spacer()
            }
            ZStack {
                ForEach(segments, id: \.name) { segment in
                    ChartSegmentView(segment: segment) { location in
                        if segments.first(where: { $0.name == segment.name }) != nil {
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
            }
            
            // Total Revenue View
            VStack(spacing: 6) {
                Text("Total Harga")
                    .font(.headline)
                Text(showTotal ? "Rp\(totalRevenue.formatted())" : "*****")
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
        .frame(height: 270)
    }
}
