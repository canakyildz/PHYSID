//
//  NewPostCell.swift
//  PHYSID
//
//  Created by Apple on 27.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class NewPostCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .systemPink
    }

}

