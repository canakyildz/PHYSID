//
//  MessageHeaderViewModel.swift
//  Tinder
//
//  Created by Apple on 11.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

struct MessageHeaderViewModel {
    var userImageURL: URL?
    
    let username: String
    
    let uid: String
    
    init(user: User) {
    
        uid = user.uid
        username = user.name
        
        userImageURL = URL(string: user.profileImageUrl ?? "")

    }
}
