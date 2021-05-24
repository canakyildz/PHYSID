//
//  Comment.swift
//  PHYSID
//
//  Created by Apple on 16.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation


struct Comment {
    
    var uid: String!
    var commentText: String!
    var creationDate: Date!
    var user: User!
    
    init(user: User,dictionary: [String: Any] ) {
        
        self.user = user
        self.uid = dictionary["uid"] as? String ?? ""
        self.commentText = dictionary["commentText"] as? String ?? ""
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
}
