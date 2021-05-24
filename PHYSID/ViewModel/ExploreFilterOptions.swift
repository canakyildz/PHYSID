//
//  ExploreFilterOptions.swift
//  PHYSID
//
//  Created by Apple on 20.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation

enum ExploreFilterOptions: Int, CaseIterable {
    case people
    case explore

    
    var description: String {
        switch self {
        case .people: return "People"
        case .explore: return "Posts"
            
            
        }
    }
}
