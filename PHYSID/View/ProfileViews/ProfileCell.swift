//
//  ProfileCell.swift
//  PHYSID
//
//  Created by Apple on 19.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        backgroundColor = .white
    }
}

