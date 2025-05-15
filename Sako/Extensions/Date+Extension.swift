import Foundation

extension Date {
    func toMonthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // "LLLL" untuk nama bulan panjang sesuai locale
        formatter.locale = Locale(identifier: "id_ID") // Gunakan bahasa Indonesia
        return formatter.string(from: self).capitalized // Agar "mei" jadi "Mei"
    }
}
