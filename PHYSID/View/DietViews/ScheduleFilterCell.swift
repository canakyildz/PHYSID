//
//  ScheduleFilterCell.swift
//  PHYSID
//
//  Created by Apple on 10.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class ScheduleFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: ScheduleFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica", size: 10)
        label.text = "Test Filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.customFont(name: "Helvetica Bold", size: 10) :
                UIFont.customFont(name: "Helvetica", size: 10)
            backgroundColor = isSelected ? .white : .white
            titleLabel.textColor = isSelected ? .black : .black
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 4
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
