import SwiftUI

struct MonthYearPicker: UIViewControllerRepresentable {
    @Binding var selectedDate: Date

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let picker = UIDatePicker()

        picker.datePickerMode = UIDatePicker.Mode(rawValue: 5)! // now valid via extension
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "id_ID")
        picker.calendar = Calendar(identifier: .gregorian)
        picker.backgroundColor = .white

        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        picker.date = selectedDate

        vc.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])

        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator($selectedDate)
    }

    class Coordinator: NSObject {
        var selectedDate: Binding<Date>

        init(_ selectedDate: Binding<Date>) {
            self.selectedDate = selectedDate
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            // Tetap pakai day = 1 supaya data rapi
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: sender.date)
            if let year = components.year, let month = components.month {
                selectedDate.wrappedValue = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            }
        }
    }
}
