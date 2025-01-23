//
//  ProfileTableViewCell.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//


import UIKit
class ProfileTableViewCell: UITableViewCell {

    public func setUp(with viewModel: ProfileViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }

}
