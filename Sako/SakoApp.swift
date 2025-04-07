import SwiftUI
import SwiftData
import TipKit

@main
struct SakoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Product.self,
            ProductOnSale.self,
            Sale.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            BerandaView()
               
                //untuk munculin tips
                .task {
                    try? Tips.configure([
                      //display untuk seberapa sering tips muncul
                       // .displayFrequency(.immediate)
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
