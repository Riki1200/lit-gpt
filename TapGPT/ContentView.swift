//
//  ContentView.swift
//  TapGPT
//
//  Created by Romeo Betances on 12/4/25.
//

import SwiftUI
import SwiftData





struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainTabbedView(modelContext: modelContext)
    }

}





#Preview {
    ContentView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
}
