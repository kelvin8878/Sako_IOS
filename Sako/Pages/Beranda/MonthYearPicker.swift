import SwiftUI

struct MonthYearPicker: UIViewControllerRepresentable {
    @Binding var selectedDate: Date

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator

        vc.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])

        // Set initial selection
        context.coordinator.setInitialSelection(picker, for: selectedDate)

        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        let parent: MonthYearPicker
        let months = Calendar.current.monthSymbols
        let years = Array(2020...(Calendar.current.component(.year, from: Date()) + 5))

        init(_ parent: MonthYearPicker) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            2 // Month and Year
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? months.count : years.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            component == 0 ? months[row] : "\(years[row])"
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let monthIndex = pickerView.selectedRow(inComponent: 0) + 1
            let year = years[pickerView.selectedRow(inComponent: 1)]
            if let date = Calendar.current.date(from: DateComponents(year: year, month: monthIndex, day: 1)) {
                parent.selectedDate = date
            }
        }

        func setInitialSelection(_ picker: UIPickerView, for date: Date) {
            let components = Calendar.current.dateComponents([.month, .year], from: date)
            if let month = components.month, let year = components.year,
               let yearIndex = years.firstIndex(of: year) {
                picker.selectRow(month - 1, inComponent: 0, animated: false)
                picker.selectRow(yearIndex, inComponent: 1, animated: false)
            }
        }
    }
}
