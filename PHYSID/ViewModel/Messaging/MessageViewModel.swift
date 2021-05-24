//
//  MessageViewModel.swift
//  Tinder
//
//  Created by Apple on 11.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    //computed properties
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9991626143, green: 0.1742511094, blue: 0.3347000182, alpha: 1) // ? means yes : means no
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .white : .white
        
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageUrl ?? "")
    }
        
    init(message: Message) {
        self.message = message
    }
}
