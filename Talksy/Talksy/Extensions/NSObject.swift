//
//  NSObject.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
