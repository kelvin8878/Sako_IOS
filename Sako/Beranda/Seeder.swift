import Foundation
import SwiftData

struct Seeder {
    static func seedInitialData(context: ModelContext) {
        // Cegah duplikasi seeding
        let existingSales = try? context.fetch(FetchDescriptor<Sale>())
        guard existingSales?.isEmpty ?? true else { return }

        // Create products
        let products = createProducts()
        
        // Insert products into the context
        let allProducts = [
            products.bebek, products.minyak, products.nasi, products.kwetiau, products.pete,
            products.kangkung, products.ikan, products.sate, products.kerupuk, products.risol
        ]
        
        for product in allProducts {
            context.insert(product)
        }
        
        // Create and insert sales for different dates
        createAndInsertSales(with: products, context: context)

        try? context.save()
    }
    
    // Helper function to create and insert sales data
    private static func createAndInsertSales(with products: ProductCollection, context: ModelContext) {
        // May 1st sale
        let may1Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1))!
        let may1Items = [
            (product: products.bebek, quantity: 2),
            (product: products.minyak, quantity: 3),
            (product: products.nasi, quantity: 3),
            (product: products.kwetiau, quantity: 10),
            (product: products.pete, quantity: 10),
            (product: products.kangkung, quantity: 20),
            (product: products.ikan, quantity: 5),
            (product: products.sate, quantity: 7),
            (product: products.kerupuk, quantity: 10),
            (product: products.risol, quantity: 15)
        ]
        let may1Sale = createSale(date: may1Date, items: may1Items, context: context)
        context.insert(may1Sale)
        
        // May 14th sale
        let may14Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 14))!
        let may14Items = [
            (product: products.bebek, quantity: 5),
            (product: products.minyak, quantity: 7),
            (product: products.nasi, quantity: 10),
            (product: products.kwetiau, quantity: 7),
            (product: products.pete, quantity: 8),
            (product: products.kangkung, quantity: 10),
            (product: products.ikan, quantity: 20),
            (product: products.sate, quantity: 10),
            (product: products.kerupuk, quantity: 3),
            (product: products.risol, quantity: 5)
        ]
        let may14Sale = createSale(date: may14Date, items: may14Items, context: context)
        context.insert(may14Sale)
        
        // May 21st sale
        let may21Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 21))!
        let may21Items = [
            (product: products.bebek, quantity: 8),
            (product: products.minyak, quantity: 10),
            (product: products.nasi, quantity: 20),
            (product: products.kwetiau, quantity: 30),
            (product: products.pete, quantity: 40),
            (product: products.kangkung, quantity: 20),
            (product: products.ikan, quantity: 15),
            (product: products.sate, quantity: 20),
            (product: products.kerupuk, quantity: 5),
            (product: products.risol, quantity: 8)
        ]
        let may21Sale = createSale(date: may21Date, items: may21Items, context: context)
        context.insert(may21Sale)
        
        // May 25th sale
        let may25Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 25))!
        let may25Items = [
            (product: products.bebek, quantity: 10),
            (product: products.minyak, quantity: 10),
            (product: products.nasi, quantity: 10),
            (product: products.kwetiau, quantity: 10),
            (product: products.pete, quantity: 10),
            (product: products.kangkung, quantity: 10),
            (product: products.ikan, quantity: 10),
            (product: products.sate, quantity: 10),
            (product: products.kerupuk, quantity: 10),
            (product: products.risol, quantity: 10)
        ]
        let may25Sale = createSale(date: may25Date, items: may25Items, context: context)
        context.insert(may25Sale)
        
        // APRIL
        let april1Date = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 1))!
        let april1Items = [
            (product: products.bebek, quantity: 30),
            (product: products.minyak, quantity: 20),
            (product: products.nasi, quantity: 7),
            (product: products.kwetiau, quantity: 25),
            (product: products.pete, quantity: 30),
            (product: products.kangkung, quantity: 20),
            (product: products.ikan, quantity: 10),
            (product: products.sate, quantity: 10),
            (product: products.kerupuk, quantity: 30),
            (product: products.risol, quantity: 10)
        ]
        let april1Sale = createSale(date: april1Date, items: april1Items, context: context)
        context.insert(april1Sale)
        
        let april14Date = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 14))!
        let april14Items = [
            (product: products.bebek, quantity: 5),
            (product: products.minyak, quantity: 7),
            (product: products.nasi, quantity: 10),
            (product: products.kwetiau, quantity: 50),
            (product: products.pete, quantity: 23),
            (product: products.kangkung, quantity: 5),
            (product: products.ikan, quantity: 5),
            (product: products.sate, quantity: 5),
            (product: products.kerupuk, quantity: 5),
            (product: products.risol, quantity: 15)
        ]
        let april14Sale = createSale(date: april14Date, items: april14Items, context: context)
        context.insert(april14Sale)
        
        let april21Date = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 21))!
        let april21Items = [
            (product: products.bebek, quantity: 30),
            (product: products.minyak, quantity: 10),
            (product: products.nasi, quantity: 30),
            (product: products.kwetiau, quantity: 20),
            (product: products.pete, quantity: 50),
            (product: products.kangkung, quantity: 5),
            (product: products.ikan, quantity: 1),
            (product: products.sate, quantity: 3),
            (product: products.kerupuk, quantity: 5),
            (product: products.risol, quantity: 1)
        ]
        let april21Sale = createSale(date: april21Date, items: april21Items, context: context)
        context.insert(april21Sale)
        
        let april28Date = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 28))!
        let april28Items = [
            (product: products.bebek, quantity: 100),
            (product: products.minyak, quantity: 20),
            (product: products.nasi, quantity: 30),
            (product: products.kwetiau, quantity: 20),
            (product: products.pete, quantity: 50),
            (product: products.kangkung, quantity: 10),
            (product: products.ikan, quantity: 10),
            (product: products.sate, quantity: 7),
            (product: products.kerupuk, quantity: 10),
            (product: products.risol, quantity: 10)
        ]
        let april28Sale = createSale(date: april28Date, items: april28Items, context: context)
        context.insert(april28Sale)
        
        let maret1Date = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 1))!
        let maret1Items = [
            (product: products.bebek, quantity: 5),
            (product: products.minyak, quantity: 5),
            (product: products.nasi, quantity: 5),
            (product: products.kwetiau, quantity: 5),
            (product: products.pete, quantity: 5),
            (product: products.kangkung, quantity: 5),
            (product: products.ikan, quantity: 5),
            (product: products.sate, quantity: 5),
            (product: products.kerupuk, quantity: 5),
            (product: products.risol, quantity: 5)
        ]
        let maret1Sale = createSale(date: maret1Date, items: maret1Items, context: context)
        context.insert(maret1Sale)
        
        let maret14Date = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 14))!
        let maret14Items = [
            (product: products.bebek, quantity: 20),
            (product: products.minyak, quantity: 20),
            (product: products.nasi, quantity: 20),
            (product: products.kwetiau, quantity: 20),
            (product: products.pete, quantity: 20),
            (product: products.kangkung, quantity: 20),
            (product: products.ikan, quantity: 20),
            (product: products.sate, quantity: 20),
            (product: products.kerupuk, quantity: 20),
            (product: products.risol, quantity: 20)
        ]
        let maret14Sale = createSale(date: maret14Date, items: maret14Items, context: context)
        context.insert(maret14Sale)
        
        let maret21Date = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 21))!
        let maret21Items = [
            (product: products.bebek, quantity: 5),
            (product: products.minyak, quantity: 5),
            (product: products.nasi, quantity: 5),
            (product: products.kwetiau, quantity: 5),
            (product: products.pete, quantity: 5),
            (product: products.kangkung, quantity: 6),
            (product: products.ikan, quantity: 0),
            (product: products.sate, quantity: 1),
            (product: products.kerupuk, quantity: 2),
            (product: products.risol, quantity: 3)
        ]
        let maret21Sale = createSale(date: maret21Date, items: maret21Items, context: context)
        context.insert(maret21Sale)
        
        let maret28Date = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 28))!
        let maret28Items = [
            (product: products.bebek, quantity: 1),
            (product: products.minyak, quantity: 2),
            (product: products.nasi, quantity: 3),
            (product: products.kwetiau, quantity: 4),
            (product: products.pete, quantity: 5),
            (product: products.kangkung, quantity: 6),
            (product: products.ikan, quantity: 7),
            (product: products.sate, quantity: 8),
            (product: products.kerupuk, quantity: 9),
            (product: products.risol, quantity: 10)
        ]
        let maret28Sale = createSale(date: maret28Date, items: maret28Items, context: context)
        context.insert(maret28Sale)
    }

    // Define a type alias or struct to store the product collection
    typealias ProductCollection = (bebek: Product, minyak: Product, nasi: Product, kwetiau: Product, pete: Product,
                                  kangkung: Product, ikan: Product, sate: Product, kerupuk: Product, risol: Product)
    
    // Helper function to create and return all products
    private static func createProducts() -> ProductCollection {
        let bebek = createProduct(name: "Bebek Goreng", price: 10000)
        let minyak = createProduct(name: "Minyak Goreng", price: 5000)
        let nasi = createProduct(name: "Nasi Goreng", price: 5000)
        let kwetiau = createProduct(name: "Kwetiau Goreng", price: 30000)
        let pete = createProduct(name: "Pete", price: 15000)
        let kangkung = createProduct(name: "Kangkung", price: 5000)
        let ikan = createProduct(name: "Ikan", price: 25000)
        let sate = createProduct(name: "Sate", price: 50000)
        let kerupuk = createProduct(name: "Kerupuk", price: 3000)
        let risol = createProduct(name: "Risol", price: 4000)

        return (bebek, minyak, nasi, kwetiau, pete, kangkung, ikan, sate, kerupuk, risol)
    }

    // Helper function to create a Product
    private static func createProduct(name: String, price: Int) -> Product {
        return Product(name: name, price: price)
    }

    // Helper function to create a ProductOnSale
    private static func createProductOnSale(product: Product, quantity: Int) -> ProductOnSale {
        return ProductOnSale(product: product, quantity: quantity)
    }

    // Helper function to create and return a Sale
    private static func createSale(date: Date, items: [(product: Product, quantity: Int)], context: ModelContext) -> Sale {
        let sale = Sale(date: date)
        for item in items {
            let productOnSale = createProductOnSale(product: item.product, quantity: item.quantity)
            sale.items.append(productOnSale)
        }
        return sale
    }
}
