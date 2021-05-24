//
//  Message.swift
//  PHYSID
//
//  Created by Apple on 10.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    
    let text: String!
    var fromId: String?
    var toId: String?
    var creationDate: Date!
    var user: User?
    var messageId: String!
    
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String? {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(messageId: String, dictionary: [String: Any]) {
        self.messageId = messageId
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        
    }
    
}

struct Conversation {
    var user: User
    var message: Message
}
