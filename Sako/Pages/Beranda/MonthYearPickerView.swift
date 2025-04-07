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
        
        // Set initial values
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        if let month = components.month, let year = components.year {
            let yearIndex = year - 2020
            picker.selectRow(month - 1, inComponent: 0, animated: false)
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: MonthYearPicker
        let months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni",
                     "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
        let years = Array(2020...2030).map { String($0) }
        
        init(_ parent: MonthYearPicker) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return months.count
            } else {
                return years.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return months[row]
            } else {
                return years[row]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let month = pickerView.selectedRow(inComponent: 0) + 1
            let year = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? 2020
            
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            
            if let date = Calendar.current.date(from: components) {
                parent.selectedDate = date
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            if component == 0 {
                return 150 // Wider for month names
            } else {
                return 80  // Narrower for years
            }
        }
    }
}
