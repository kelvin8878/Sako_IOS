import SwiftUI

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            MonthYearPicker(selectedDate: $selectedDate)
        }
        .presentationDetents([.height(200)])
    }
}

struct MonthYearPicker: UIViewRepresentable {
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        if let month = components.month, let year = components.year {
            let yearIndex = year - context.coordinator.startYear
            picker.selectRow(month - 1, inComponent: 0, animated: false)
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: MonthYearPicker
        
        let months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni",
                      "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
        
        let startYear = 2020
        let endYear = Calendar.current.component(.year, from: Date()) + 100
        lazy var years = Array(startYear...endYear).map { String($0) }
        
        init(_ parent: MonthYearPicker) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? months.count : years.count
        }
        
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let calendar = Calendar.current
            let now = Date()
            let currentComponents = calendar.dateComponents([.year, .month], from: now)
            let currentYear = currentComponents.year ?? startYear
            let currentMonth = currentComponents.month ?? 1
            
            let selectedYearRow = pickerView.selectedRow(inComponent: 1)
            let selectedYear = Int(years[selectedYearRow]) ?? currentYear
            
            let isFuture: Bool
            if component == 0 {
                let thisMonth = row + 1
                isFuture = selectedYear > currentYear || (selectedYear == currentYear && thisMonth > currentMonth)
            } else {
                let thisYear = Int(years[row]) ?? currentYear
                let selectedMonthRow = pickerView.selectedRow(inComponent: 0) + 1
                isFuture = thisYear > currentYear || (thisYear == currentYear && selectedMonthRow > currentMonth)
            }
            
            let title = component == 0 ? months[row] : years[row]
            let color: UIColor = isFuture ? .lightGray : .label
            return NSAttributedString(string: title, attributes: [.foregroundColor: color])
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            pickerView.reloadAllComponents() // Refresh warna teks
            
            let selectedMonth = pickerView.selectedRow(inComponent: 0) + 1
            let selectedYear = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? startYear

            let calendar = Calendar.current
            let now = Date()
            let currentComponents = calendar.dateComponents([.year, .month], from: now)
            let currentYear = currentComponents.year ?? startYear
            let currentMonth = currentComponents.month ?? 1
            
            // Prevent future date
            if selectedYear > currentYear || (selectedYear == currentYear && selectedMonth > currentMonth) {
                pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: true)
                pickerView.selectRow(currentYear - startYear, inComponent: 1, animated: true)
                pickerView.reloadAllComponents()
                
                var components = DateComponents()
                components.year = currentYear
                components.month = currentMonth
                components.day = 1
                if let safeDate = calendar.date(from: components) {
                    parent.selectedDate = safeDate
                }
                return
            }
            
            var components = DateComponents()
            components.year = selectedYear
            components.month = selectedMonth
            components.day = 1
            if let date = calendar.date(from: components) {
                parent.selectedDate = date
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return component == 0 ? 150 : 80
        }
    }
}
