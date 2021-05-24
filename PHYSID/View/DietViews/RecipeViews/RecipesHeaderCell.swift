//
//  RecipesHeaderCell.swift
//  PHYSID
//
//  Created by Apple on 21.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class RecipesHeaderCell: UICollectionViewCell {
    
    
    // MARK: - Properties

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Standard"
        label.textColor = .white
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowOpacity = 1
        label.layer.cornerRadius = 2
        label.layer.shadowColor = UIColor.black.cgColor
//        label.backgroundColor = #colorLiteral(red: 0.2434168782, green: 0.2434168782, blue: 0.2434168782, alpha: 1).withAlphaComponent(0.15)
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
    
        return label
    }()
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
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
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor, left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        vv.layer.shadowOffset = CGSize(width: 1.4, height: 1.2)
        vv.layer.shadowOpacity = 1
        vv.layer.shadowRadius = 2
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.cornerRadius = 16
        
        vv.addSubview(profileImageView)
        profileImageView.anchor(top: vv.topAnchor, left: vv.leftAnchor,bottom: vv.bottomAnchor, right: vv.rightAnchor)
        profileImageView.layer.cornerRadius = 13
        profileImageView.addSubview(titleLabel)
        titleLabel.anchor(left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: 300, height: 45)

        
    }
    
}
