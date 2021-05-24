//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 2/12/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case professionType
    case location
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "Name"
        case .bio: return "Bio"
        case .professionType: return "Profession"
        case .location: return "Location"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .fullname: return user.name
        case .bio: return user.bio
        case .professionType: return user.professionType
        case .location: return user.location
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != ""
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
