//
//  Transaksi+CoreDataProperties.swift
//  Sako
//
//  Created by Kelvin Bong on 04/04/25.
//
//

import Foundation
import CoreData


extension Transaksi {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaksi> {
        return NSFetchRequest<Transaksi>(entityName: "Transaksi")
    }

    @NSManaged public var transactionID: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var totalTransaction: Double
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Transaksi {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemTransaksi)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemTransaksi)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Transaksi : Identifiable {

}
