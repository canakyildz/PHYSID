//
//  DropDownViewModel.swift
//  PHYSID
//
//  Created by Apple on 15.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum Buttons: Int, CaseIterable {
    
    case FourthButton
    
    var description: String {
        switch self {
            
        case .FourthButton:
            return "Trainers"
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .FourthButton:
            return #imageLiteral(resourceName: "professional").withTintColor(.black)
            
        }
    }
    
}

enum FeedFilters: Int, CaseIterable {
    case SecondButton

    
    var description: String {
        switch self {
            
        case .SecondButton:
            return "Explore Page"

            
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .SecondButton:
            return #imageLiteral(resourceName: "search").withTintColor(.black)

            
        }
    }
}
