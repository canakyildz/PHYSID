//
//  WorkoutHeaderCell.swift
//  PHYSID
//
//  Created by Apple on 17.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class WorkoutHeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Standard"
        label.textColor = .white
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowOpacity = 1
        label.layer.cornerRadius = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? configureBlurity() : visualEffectView.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureBlurity() {
        profileImageView.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0.1
    }
    
    func configureUI() {
        backgroundColor = .white
        
        layer.shadowOffset = CGSize(width: 1.4, height: 1.2)
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        
        layer.cornerRadius = 10

        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 300)
        
        profileImageView.addSubview(titleLabel)
        titleLabel.anchor(left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, paddingLeft: 6, paddingBottom: 10, width: 300, height: 27)
        
    }
    
}
