import SwiftUI

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment:.leading){
            MonthYearPicker(selectedDate: $selectedDate)
        }
        .presentationDetents([.height(100)])
    }
}

struct MonthYearPicker: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        context.coordinator.setInitialSelection(picker, for: selectedDate)
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        let parent: MonthYearPicker
        let months = Calendar.current.monthSymbols
        let startYear = 2020
        let currentYear = Calendar.current.component(.year, from: Date())
        lazy var years = (startYear...(currentYear + 100)).map(String.init)

        init(_ parent: MonthYearPicker) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? months.count : years.count
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            component == 0 ? 100 : 100
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            28
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20)

            let title = component == 0 ? months[row] : years[row]
            label.text = title
            label.textColor = isFuture(row: row, component: component, pickerView: pickerView) ? .lightGray : .label
            return label
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            pickerView.reloadAllComponents()

            let month = pickerView.selectedRow(inComponent: 0) + 1
            let year = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? currentYear

            let now = Date()
            let nowComponents = Calendar.current.dateComponents([.year, .month], from: now)

            if year > (nowComponents.year ?? currentYear) || (year == nowComponents.year && month > (nowComponents.month ?? 12)) {
                setInitialSelection(pickerView, for: now)
                parent.selectedDate = now
                return
            }

            if let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1)) {
                parent.selectedDate = date
            }
        }

        func isFuture(row: Int, component: Int, pickerView: UIPickerView) -> Bool {
            let now = Calendar.current.dateComponents([.year, .month], from: Date())
            let selectedMonth = pickerView.selectedRow(inComponent: 0) + 1
            let selectedYear = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? currentYear

            if component == 0 {
                let testMonth = row + 1
                return selectedYear > now.year! || (selectedYear == now.year! && testMonth > now.month!)
            } else {
                let testYear = Int(years[row]) ?? currentYear
                return testYear > now.year! || (testYear == now.year! && selectedMonth > now.month!)
            }
        }

        func setInitialSelection(_ picker: UIPickerView, for date: Date) {
            let components = Calendar.current.dateComponents([.month, .year], from: date)
            if let month = components.month, let year = components.year {
                picker.selectRow(month - 1, inComponent: 0, animated: false)
                picker.selectRow(year - startYear, inComponent: 1, animated: false)
            }
        }
    }
}
