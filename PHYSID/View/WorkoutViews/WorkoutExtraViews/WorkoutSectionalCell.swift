//
//  WorkoutSectionalCell.swift
//  PHYSID
//
//  Created by Apple on 3.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class WorkoutSectionalCell: UICollectionViewCell {
    
    
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
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    let informativeLabel: UILabel = {
        let label = UILabel()
        label.text = "You know the vibes"
        label.textColor = .white
        label.numberOfLines = 5
        label.layer.shadowOffset = CGSize(width: 0.01, height: 1)
        label.layer.shadowOpacity = 1
        label.layer.cornerRadius = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingRight: 10, height: frame.height - 20)
        print(frame.height)
        vv.addSubview(buttonImage)
        buttonImage.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor)
        buttonImage.centerX(inView: vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 2)
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.shadowOpacity = 1
        buttonImage.layer.cornerRadius = 5
        
        let backV = UIView()
        vv.addSubview(backV)
        backV.backgroundColor = .black
        backV.alpha = 0
        backV.anchor(left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor, height: 74)
        
        
        vv.addSubview(informativeLabel)
        informativeLabel.sendSubviewToBack(backV)
        informativeLabel.anchor(left: vv.leftAnchor,bottom: vv.bottomAnchor, paddingLeft: 6,paddingBottom: 10, width: 300)
        
        vv.addSubview(titleLabel)
        titleLabel.sendSubviewToBack(backV)
        titleLabel.anchor(left: vv.leftAnchor, bottom: informativeLabel.topAnchor, paddingLeft: 0, paddingBottom: 0, width: 300, height: 27)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}
