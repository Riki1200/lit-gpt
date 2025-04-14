//
//  ChatMessage.swift
//  TapGPT
//
//  Created by Romeo Betances on 12/4/25.
//

import SwiftData
import Foundation

@Model
class ChatMessage: Identifiable {
    var id: UUID
    var text: String
    var sender: Sender
    var timestamp: Date

    init(id: UUID = UUID(), text: String, sender: Sender, timestamp: Date = .now) {
        self.id = id
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
    }
}

enum Sender: String, Codable {
    case user
    case assistant
}
