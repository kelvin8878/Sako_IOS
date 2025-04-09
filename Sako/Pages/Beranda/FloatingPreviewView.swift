import SwiftUI

struct FloatingPreviewView: View {
    @State private var opacity: Double = 0

    let product: (name: String, revenue: Int, quantity: Int, color: Color)
    let percentage: Double
    let position: CGPoint
    let dismissAction: () -> Void
    
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
            
            // Auto-dismiss after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    dismissAction()
                }
            }
        }
    }
}
