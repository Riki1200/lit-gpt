//
//  TapGPTApp.swift
//  TapGPT
//
//  Created by Romeo Betances on 12/4/25.
//

import SwiftUI
import SwiftData
import CoreData

@main
struct TapGPTApp: App {
    var sharedModelContainer: ModelContainer = {
           let schema = Schema([
               ChatMessage.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}



#Preview {
    ContentView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
}
