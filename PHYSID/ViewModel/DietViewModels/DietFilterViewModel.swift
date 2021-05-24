//
//  DietFilterViewModel.swift
//  PHYSID
//
//  Created by Apple on 16.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation

enum DietFilterOptions: Int, CaseIterable {
    case recipes
    case diets
    case myDiet
    
    
    var description: String {
        switch self {
        case .recipes: return "Foods"
        case .diets: return "Diets"
        case .myDiet: return "My Diet"
            
            
        }
    }
}

