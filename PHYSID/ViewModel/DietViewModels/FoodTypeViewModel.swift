//
//  FoodTypeViewModel.swift
//  PHYSID
//
//  Created by Apple on 30.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum FoodTypeViewModel: Int, CaseIterable {
    
    case Vegeterian
    case Vegan
    case Standard
    case Keto
    case Paleo
    
    var description: String {
        switch self {
        
        case .Vegeterian:
            return "Vegeterian"
        case .Vegan:
            return "Vegan"
        case .Standard:
            return "Standard"
        case .Keto:
            return "Keto"
        case .Paleo:
            return "Paleo"
        }
    }
    init(index: Int) {
        switch index {
        case 0: self = .Vegeterian
        case 1: self = .Vegan
        case 2: self = .Standard
        case 3: self = .Keto
        case 4: self = .Paleo
        default: self = .Standard
            
        }
    }
}
