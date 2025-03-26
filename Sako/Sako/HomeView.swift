//
//  ContentView.swift
//  Sako
//
//  Created by Ammar Sufyan on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            }
        }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
