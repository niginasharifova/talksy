//
//  ProfileViewModel.swift
//  Talksy
//
//  Created by Nigina Sharifova on 23/01/25.
//


import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
