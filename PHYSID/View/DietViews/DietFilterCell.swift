//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 2/2/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

class DietFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: DietFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Test Filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 19) :
                UIFont.systemFont(ofSize: 19)
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
