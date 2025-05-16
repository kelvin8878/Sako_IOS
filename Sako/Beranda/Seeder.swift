import Foundation
import SwiftData

struct Seeder {
    static func seedInitialData(context: ModelContext) {
        // Cegah duplikasi seeding
        let existingSales = try? context.fetch(FetchDescriptor<Sale>())
        guard existingSales?.isEmpty ?? true else { return }

        let sale = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1))!)

        let bebek = Product(name: "Bebek Goreng", price: 10000)
        let minyak = Product(name: "Minyak Goreng", price: 15000)
        let nasi = Product(name: "Nasi Goreng", price: 15000)
        let kwetiau = Product(name: "Kwetiau Goreng", price: 15000)
        let Pete = Product(name: "Pete", price: 15000)

        let bebekItem = ProductOnSale(product: bebek, quantity: 2)
        let minyakItem = ProductOnSale(product: minyak, quantity: 3)
        let nasiItem = ProductOnSale(product: nasi, quantity: 3)
        let kwetiauItem = ProductOnSale(product: kwetiau, quantity: 10)
        let PeteItem = ProductOnSale(product: Pete, quantity: 10)

        sale.items.append(contentsOf: [bebekItem, minyakItem, nasiItem, kwetiauItem,PeteItem])

        // Insert
        context.insert(bebek)
        context.insert(minyak)
        context.insert(nasi)
        context.insert(kwetiau)
        context.insert(Pete)

        context.insert(bebekItem)
        context.insert(minyakItem)
        context.insert(nasiItem)
        context.insert(kwetiauItem)
        context.insert(PeteItem)

        context.insert(sale)

        let sales = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 14))!)

        let bebeks = Product(name: "Bebek Goreng", price: 10000)
        let minyaks = Product(name: "Minyak Goreng", price: 15000)
        let nasis = Product(name: "Nasi Goreng", price: 15000)
        let kwetiaus = Product(name: "Kwetiau Goreng", price: 15000)

        let bebekItems = ProductOnSale(product: bebeks, quantity: 100)
        let minyakItems = ProductOnSale(product: minyaks, quantity: 10)
        let nasiItems = ProductOnSale(product: nasis, quantity: 10)
        let kwetiauItems = ProductOnSale(product: kwetiaus, quantity: 10)

        sales.items.append(contentsOf: [bebekItems, minyakItems, nasiItems,kwetiauItems])

        // Insert
        context.insert(bebeks)
        context.insert(minyaks)
        context.insert(nasis)
        context.insert(kwetiaus)

        context.insert(bebekItems)
        context.insert(minyakItems)
        context.insert(nasiItems)
        context.insert(kwetiauItems)

        context.insert(sales)
        
        let saless = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 21))!)

        let bebekss = Product(name: "Bebek Goreng", price: 20000)
        let minyakss = Product(name: "Minyak Goreng", price: 25000)
        let nasiss = Product(name: "Nasi Goreng", price: 25000)
        let kwetiauss = Product(name: "Kwetiau Goreng", price: 25000)

        let bebekItemss = ProductOnSale(product: bebeks, quantity: 100)
        let minyakItemss = ProductOnSale(product: minyaks, quantity: 10)
        let nasiItemss = ProductOnSale(product: nasis, quantity: 20)
        let kwetiauItemss = ProductOnSale(product: kwetiaus, quantity: 10)

        saless.items.append(contentsOf: [bebekItemss, minyakItemss, nasiItemss,kwetiauItemss])

        // Insert
        context.insert(bebekss)
        context.insert(minyakss)
        context.insert(nasiss)
        context.insert(kwetiauss)

        context.insert(bebekItemss)
        context.insert(minyakItemss)
        context.insert(nasiItemss)
        context.insert(kwetiauItemss)

        context.insert(saless)
        
//        // MARK: Contoh 1
//        let Bebek = Product(name: "Bebek Goreng", price: 10000)
//        let BebekItem = ProductOnSale(product: Bebek, quantity: 2)
//        let BebekSale = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1))!)
//        BebekSale.items.append(BebekItem)
//
//        // MARK: Contoh 2
//        let minyak = Product(name: "Minyak Goreng", price: 15000)
//        let minyakItem = ProductOnSale(product: minyak, quantity: 3)
//        let minyakSale = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1))!)
//        minyakSale.items.append(minyakItem)
//        
//        let Nasi = Product(name: "Nasi Goreng", price: 15000)
//        let NasiItem = ProductOnSale(product: Nasi, quantity: 3)
//        let NasiSale = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1))!)
//        NasiSale.items.append(NasiItem)
//        
//        let Kwetiau = Product(name: "Kwetiau Goreng", price: 15000)
//        let KwetiauItem = ProductOnSale(product: Kwetiau, quantity: 10)
//        let KwetiauSale = Sale(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1))!)
//        KwetiauSale.items.append(KwetiauItem)
//
//        // Tambahkan ke context
//        context.insert(Bebek)
//        context.insert(BebekItem)
//        context.insert(BebekSale)
//
//        context.insert(minyak)
//        context.insert(minyakItem)
//        context.insert(minyakSale)
//        
//        context.insert(Nasi)
//        context.insert(NasiItem)
//        context.insert(NasiSale)
//        
//        context.insert(Kwetiau)
//        context.insert(KwetiauItem)
//        context.insert(KwetiauSale)

        try? context.save()
    }
}
