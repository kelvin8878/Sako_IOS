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
        var months: [String]
        let years: [Int]
        
        let currentMonth: Int
        let currentYear: Int

        init(_ parent: MonthYearPicker) {
            self.parent = parent
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "id_ID")
            self.months = dateFormatter.monthSymbols

            // Current year and month
            let currentDate = Date()
            let calendar = Calendar.current
            self.currentMonth = calendar.component(.month, from: currentDate)
            self.currentYear = calendar.component(.year, from: currentDate)

            // Allow years from current year to 5 years in the future
            self.years = Array((self.currentYear - 10)...(self.currentYear + 3))
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2 // Month and Year
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
            
            // Check if the selected month/year is in the future
            if year > currentYear || (year == currentYear && monthIndex > currentMonth) {
                // Animate to the current date if the user selects a future date
                withAnimation {
                    pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: true)
                    pickerView.selectRow(years.firstIndex(of: currentYear)!, inComponent: 1, animated: true)
                    
                    // Set the current date as selected
                    if let date = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)) {
                        parent.selectedDate = date
                    }
                }
                return // Exit the method to prevent further processing of future date
            }
            
            // Set the selected date if it's valid
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
