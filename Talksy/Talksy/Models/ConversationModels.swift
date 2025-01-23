//
//  ConversationModels.swift
//  Talksy
//
//  Created by Nigina Sharifova on 23/01/25.
//


import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
