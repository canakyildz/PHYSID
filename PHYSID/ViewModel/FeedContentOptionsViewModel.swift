//
//  FeedContentOptionsViewModel.swift
//  PHYSID
//
//  Created by Apple on 18.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation

struct FeedContentOptionsViewModel {
    
    private let user: User
    
    var options: [FeedContentOptions] {
        var results = [FeedContentOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: FeedContentOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        results.append(.cancel)
        
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

enum FeedContentOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    case cancel
    
    var description: String {
        switch self {
        case .follow(let user): return "Follow @\(user.name ?? "")"
        case .unfollow(let user): return "Unfollow @\(user.name ?? "")"
        case .report: return "Report Post"
        case .delete: return "Delete Post"
        case .cancel: return "Cancel"
        }
    }
}
