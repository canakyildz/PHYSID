//
//  LunchHeaderView.swift
//  PHYSID
//
//  Created by Apple on 25.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class LunchHeaderView: UIView {

   // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let buttonImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
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
            label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        
            return label
        }()
        
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, height: 90)
        print(frame.height)
        vv.addSubview(buttonImage)
        buttonImage.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor)
        buttonImage.centerX(inView: vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 2)
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.shadowOpacity = 1
        buttonImage.layer.cornerRadius = 5
        
        vv.addSubview(titleLabel)
        titleLabel.anchor(left: vv.leftAnchor, bottom: vv.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: 300, height: 45)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configure() {

        buttonImage.image = Meals.Lunch.mealImage
        titleLabel.text = "  \(Meals.Lunch.description.uppercased())"

    }
    
}
