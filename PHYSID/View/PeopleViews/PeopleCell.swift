//
//  PeopleCell.swift
//  PHYSID
//
//  Created by Apple on 9.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure() }
    }
        
    let userProfileImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let defImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lastoneiguess").withTintColor(.lightGray))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full name"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 15)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "United States of America"
        label.numberOfLines = 2
        label.font = UIFont.customFont(name: "Helvetica Light", size: 14)
        return label
    }()
    
    let nutritionalValues: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica Light", size: 14)
        return label
    }()
    

    private let line = UnderLineView()
    

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        selectionStyle = .none
        let vv = UIView()
        addSubview(vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 1)
        vv.layer.shadowOpacity = 0.7
        vv.layer.shadowRadius = 2
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.setDimensions(height: 100, width: 100)
        vv.anchor(left: leftAnchor, paddingLeft: 12)
        vv.centerY(inView: self)
        vv.addSubview(userProfileImage)
        userProfileImage.addSubview(defImage)
        defImage.fillSuperview()
        userProfileImage.layer.cornerRadius = 8
        userProfileImage.setDimensions(height: 80, width: 80)
        userProfileImage.centerY(inView: vv)
        userProfileImage.centerX(inView: vv)
        
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, locationLabel, nutritionalValues])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(left: vv.rightAnchor, right: rightAnchor ,paddingLeft: 5, paddingRight: 6)
        stack.centerY(inView: userProfileImage)

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let user = user else { return }
       
        userNameLabel.text = user.name
        locationLabel.text = user.location
        
        
        guard let profileImageUrl = user.profileImageUrl else { return }
        if profileImageUrl == "" {
            defImage.isHidden = false
            
        } else {
            defImage.isHidden = true
            let unnecessaryUrling = URL(string: profileImageUrl)
            userProfileImage.sd_setImage(with: unnecessaryUrling)
        }
        
        
        Service.fetchUserStats(uid: user.uid) { (stats) in
            let attributedText = NSAttributedString(string: "Followers: \(stats.followers)",
                attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Light", size: 14)
])
            
            self.nutritionalValues.attributedText = attributedText
        }
        
        
    }
    
}
