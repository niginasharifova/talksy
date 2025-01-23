//
//  Contact.swift
//  Talksy
//
//  Created by Nigina Sharifova on 23/01/25.
//


import Foundation
import MessageKit

struct ContactModel: ContactItem {
    let displayName: String
    let initials: String
    let phoneNumbers: [String]
    let emails: [String]
    
    init(displayName: String, phoneNumbers: [String], emails: [String]) {
        self.displayName = displayName
        self.phoneNumbers = phoneNumbers
        self.emails = emails
        self.initials = ContactModel.createInitials(from: displayName)
    }
    
    private static func createInitials(from name: String) -> String {
        let nameParts = name.split(separator: " ")
        guard nameParts.count > 1 else {
            return name.prefix(2).uppercased()
        }
        let initials = nameParts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        return initials.uppercased()
    }
}
