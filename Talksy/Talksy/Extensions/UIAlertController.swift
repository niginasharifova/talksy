//
//  UIAlertController.swift
//  Talksy
//
//  Created by Nigina Sharifova on 23/01/25.
//

import UIKit

extension UIAlertController {
    
    typealias Block = () -> Void
    
    static func showAlert(title: String? = nil, message: String? = nil, vc: UIViewController, buttonTitle: String = "OK", completion: Block? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { (_) in
            completion?()
        })
        alert.view.tintColor = .green500
        vc.present(alert, animated: true, completion: nil)
    }
}

