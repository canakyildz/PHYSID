//
//  ConversationViewModel.swift
//  Tinder
//
//  Created by Apple on 12.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit


struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        guard let url = conversation.user.profileImageUrl else { return nil }
        return URL(string: url)
    }
    
    var creationDate: String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1 //this is gonna make it 1h 1w 1m 1s..
        dateFormatter.unitsStyle = .full // kısaltma
        let now = Date()
        return dateFormatter.string(from: conversation.message.creationDate, to: now) ?? "10 seconds hhehe"
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
