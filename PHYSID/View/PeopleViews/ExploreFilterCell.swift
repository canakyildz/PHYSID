//
//  ExploreFilterCell.swift
//  PHYSID
//
//  Created by Apple on 20.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class ExploreFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: ExploreFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.customFont(name: "Helvetica", size: 20)
        label.text = "Test Filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.customFont(name: "Helvetica Bold", size: 20)
 :
                UIFont.customFont(name: "Helvetica", size: 20)
            titleLabel.textColor = isSelected ? .black : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
