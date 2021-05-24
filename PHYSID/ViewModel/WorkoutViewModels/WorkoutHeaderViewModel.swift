//
//  WorkoutFilterViewModel.swift
//  PHYSID
//
//  Created by Apple on 17.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum WorkoutSections: Int, CaseIterable {

    case Shoulders
    case Arms
    case Back
    case Abs
    case Legs
    case Chest
    case Cardio
    
    
    var description: String {
        switch self {

        case .Shoulders:
            return "Shoulders"
        case .Arms:
            return "Arms"
        case .Back:
            return "Back"
        case .Legs:
            return "Legs"
        case .Chest:
            return "Chest"
        case .Abs:
            return "Abs"
        case .Cardio:
            return "Cardio"
        }
    }
    
    var sectionImage: UIImage {
        switch self {

        case .Shoulders:
            return #imageLiteral(resourceName: "Ekran Resmi 2020-09-03 20.04.04").withRenderingMode(.alwaysOriginal)
        case .Arms:
            return #imageLiteral(resourceName: "Women's UA Wordmark Strappy Sportlette").withRenderingMode(.alwaysOriginal)
        case .Back:
            return #imageLiteral(resourceName: "181211-gym-full").withRenderingMode(.alwaysOriginal)
        case .Legs:
            return #imageLiteral(resourceName: "tumblr_2bbfa319a11e0455d545bf91cd90ecf9_b0330d4f_1280").withRenderingMode(.alwaysOriginal)
        case .Chest:
            return #imageLiteral(resourceName: "Yoga Clothes _ Cut out the distractions just train_ | lululemon").withRenderingMode(.alwaysOriginal)
        case .Abs:
            return #imageLiteral(resourceName: "Women's What's New | lululemon-2").withRenderingMode(.alwaysOriginal)
        case .Cardio:
            return #imageLiteral(resourceName: "Snorri Björnsson - SARA SIGMUNDSDOTTIR").withRenderingMode(.alwaysOriginal)
        }
    }
}

