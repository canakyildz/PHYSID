//
//  HeaderCell.swift
//  Tinder
//
//  Created by Apple on 10.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: MessageHeaderViewModel? {
        didSet { usernameLabel.text = viewModel?.username
            profileImageView.sd_setImage(with: viewModel?.userImageURL)
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
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
        backgroundColor = .white
        
        let vv = UIView()
        addSubview(vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 0.1)
        vv.layer.shadowOpacity = 0.5
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.setDimensions(height: 110, width: 110)
        vv.anchor(top: topAnchor,left: leftAnchor,paddingTop: 10, paddingLeft: 12)
        vv.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 10
        profileImageView.setDimensions(height: 110, width: 110)
        profileImageView.centerY(inView: vv)
        profileImageView.centerX(inView: vv)
    
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor ,left: profileImageView.leftAnchor, right: profileImageView.rightAnchor,paddingTop: 4)
        
    }
    
}
