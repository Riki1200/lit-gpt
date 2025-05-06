

import Foundation
import SwiftData



@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    
    let llm: Model?
    let modelContext: ModelContext
    
    init(model: Model?, context: ModelContext) {
        self.llm = model
        self.modelContext = context
        loadMessages()
    }

    func loadMessages() {
        let descriptor = FetchDescriptor<ChatMessage>(
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        do {
            messages = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }

    func clear() {
        do {
            let allMessages = try modelContext.fetch(FetchDescriptor<ChatMessage>())
            for message in allMessages {
                modelContext.delete(message)
            }
            try modelContext.save()
            messages.removeAll()
        } catch {
            print("Error deleting all messages: \(error)")
        }
    }

    func send(_ userText: String) async {
        let trimmed = userText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = ChatMessage(id: UUID(), text: trimmed, sender: .user, timestamp: .now)
        modelContext.insert(userMessage)
        do {
            try modelContext.save()
            messages.append(userMessage)
        } catch {
            print("Error saving user message: \(error)")
            return
        }

        isLoading = true

        await llm?.respond(to: trimmed)
        
        if let message = llm?.output.cleanedLLMOutput() {
            let assistantMessage = ChatMessage(id: UUID(), text: message, sender: .assistant, timestamp: .now)
            modelContext.insert(assistantMessage)
            do {
                try modelContext.save()
                messages.append(assistantMessage)
            } catch {
                print("Error saving assistant message: \(error)")
            }
        }

        isLoading = false
    }
}
