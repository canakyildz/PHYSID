//
//  ProfileViewModel.swift
//  PHYSID
//
//  Created by Apple on 24.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

struct ProfileViewModel {
    
    private var user: User
    
    var profileImageUrl: URL? {
        guard let profileImage = user.profileImageUrl else { return nil }
        return URL(string: profileImage)
    }
    
    var backgroundImageUrl: URL? {
        guard let backgroundImage = user.backgroundImageUrl else { return nil }
        return URL(string: backgroundImage)
    }
    
    let name: String
    let bio: String
    let location: String
    let professionType: String
    
    
    init(user: User) {
        self.user = user
        
        //        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        //
        //        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        
        name = user.name
        bio = user.bio
        location = user.location
        professionType = user.professionType ?? "Profession"
    }
}
