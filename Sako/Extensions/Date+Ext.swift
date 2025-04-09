// File: Utilities/Date+Extensions.swift
import Foundation

extension Date {
    func isFutureDate() -> Bool {
        return self > Date()
    }
    
    func isPastDate() -> Bool {
        return self < Date()
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}
