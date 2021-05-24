//
//  PeopleHeaderCell.swift
//  PHYSID
//
//  Created by Apple on 9.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class PeopleHeaderCell: UICollectionViewCell {
    
    
    // MARK: - Properties

    var filteredUser: User! {
        didSet { configure() }
    }
    
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
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 13.5)
        return label
    }()
    
    let profession: UILabel = {
        let label = UILabel()
        label.text = "What do I do?"
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica Light", size: 13)
        return label
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.text = "United States of America"
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica Light", size: 13)

        return label
    }()
    
    let titleBackView: UIView = {
        let downBelowView = UIView()
        downBelowView.backgroundColor = .white
        return downBelowView
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
        vv.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: self.frame.height)
    
        vv.addSubview(profileImageView)
        profileImageView.anchor(top: vv.topAnchor, left: vv.leftAnchor,bottom: vv.bottomAnchor, right: vv.rightAnchor, paddingLeft: 6)
        vv.layer.shadowOffset = CGSize(width: 1.0, height: 0.7)
        vv.layer.shadowOpacity = 1
        vv.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = 12
        vv.layer.shadowRadius = 2
        profileImageView.addSubview(titleBackView)
        titleBackView.layer.masksToBounds = true
        profileImageView.bringSubviewToFront(titleBackView)
        titleBackView.anchor(left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, height: self.frame.height / 3 - 5)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, profession, location])
        stack.axis = .vertical
        stack.spacing = 4
        vv.addSubview(stack)
        vv.bringSubviewToFront(stack)
        stack.anchor(top: titleBackView.topAnchor, left: titleBackView.leftAnchor, right: titleBackView.rightAnchor, paddingTop: 6, paddingLeft: 6)
        
    }
    
    func configure() {
        guard let user = filteredUser else { return }
        guard let url = user.profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: url))
        titleLabel.text = user.name
        profession.text = user.professionType
        location.text = user.location
    }
}
