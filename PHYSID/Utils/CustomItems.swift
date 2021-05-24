//
//  CustomItems.swift
//  PHYSID
//
//  Created by Apple on 19.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class UnderLineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .gray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
