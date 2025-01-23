//
//  MessageContent.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//

import Foundation

struct MessageContent {
    var senderName: String
    var content: String
    var time: Date
    let unreadMessagesCount: Int
    var image: String?
}
