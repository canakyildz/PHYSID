//
//  WorkoutContent.swift
//  PHYSID
//
//  Created by Apple on 2.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

struct WorkoutContent {
    
    var title: String
    var workoutContenttype: String
    var assignedPurposalType: [String]
    var equipments: String
    var description: String
    var imageUrl: String?
    var instructionVideoUrl: String?
    var instructionDuration: String?
    var contentId: String
    // equipment is required? bool and gym is required bool to be added
    
    
    init(contentId: String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.workoutContenttype = dictionary["workoutContentType"] as? String ?? ""
        self.assignedPurposalType = dictionary["assignedPurposalType"] as? [String] ?? [String]()
        self.equipments = dictionary["equipments"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.instructionVideoUrl = dictionary["instructionVideoUrl"] as? String ?? ""
        self.instructionDuration = dictionary["instructionDuration"] as? String ?? ""
        self.contentId = contentId
    }
    
}


// addingworkoutContent.assignedPurposalTypes.append(newString)
// removing from array of assigned purposes --> if let indexOfNewString = workoutContent.assignedPurposalTypes.firstIndex(of = newString) { workoutContent.assignedPurposalTypes.remove(at: indexOfNewString)
