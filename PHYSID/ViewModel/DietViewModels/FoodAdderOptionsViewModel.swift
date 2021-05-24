
//
//  FoodAdderOptions.swift
//  PHYSID
//
//  Created by Apple on 30.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum FoodAdderOptions: Int, CaseIterable {
    
    case foodName
    case foodTypeViewModel
    case calories
    case proteins
    case fats
    case carbs
    case foodDescriptiveBio
    
    
    var description: String {
        switch self {
        
        case .foodName:
            return "Food name"
        case .foodTypeViewModel:
            return "Food type"
        case .calories:
            return "Calories"
        case .proteins:
            return "Proteins"
        case .fats:
            return "Fats"
        case .carbs:
            return "Carbs"
        case .foodDescriptiveBio:
            return "Descriptive Bio"
        }
    }
}
