import SwiftUI

struct DatePickerButton: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isPresented.toggle()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                Text(selectedDate.toMonthYearString())
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    .rotationEffect(.degrees(isPresented ? 180 : 0))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(12)
            .frame(width: 205, height: 36)
        }
        .popover(isPresented: $isPresented, arrowEdge: .top) {
            VStack {
                MonthYearPicker(selectedDate: $selectedDate)
                    .frame(width: 300, height: 200)
                    .presentationCompactAdaptation(.popover)
            }
            .padding()
        }
    }
}

struct DatePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerButton(selectedDate: .constant(Date()), isPresented: .constant(false))
    }
}
