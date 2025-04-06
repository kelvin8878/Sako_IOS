import SwiftUI

struct FloatingPreviewView: View {
    let product: (name: String, value: Int, color: Color)
    let percentage: Double
    let position: CGPoint
    let onDismiss: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let adjustedPosition = CGPoint(
                x: min(max(position.x, 120), geometry.size.width - 120),
                y: min(max(position.y, 120), geometry.size.height - 80)
            )

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Circle()
                        .fill(product.color)
                        .frame(width: 12, height: 12)

                    Text(product.name)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                    }
                }

                Divider()

                HStack {
                    Text("Nilai:")
                    Spacer()
                    Text("Rp\(product.value.formatted())")
                        .bold()
                }

                HStack {
                    Text("Persentase:")
                    Spacer()
                    Text(String(format: "%.1f%%", percentage))
                        .bold()
                }
            }
            .padding()
            .frame(width: 240)
            .background(.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .position(adjustedPosition)
            .transition(.scale.combined(with: .opacity))
        }
    }
}
