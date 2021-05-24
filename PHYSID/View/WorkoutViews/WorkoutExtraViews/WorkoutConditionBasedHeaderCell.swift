//
//  WorkoutSecondaryHeaderCell.swift
//  PHYSID
//
//  Created by Apple on 7.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class WorkoutConditionBasedHeaderCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 0
        return iv
    }()
    let descriptiveLabel: UILabel = {
        let label = UILabel()
        label.text = "You know the vibes"
        label.textColor = .white
        label.numberOfLines = 5
        label.layer.shadowOffset = CGSize(width: 0.01, height: 1)
        label.layer.shadowOpacity = 1
        label.layer.cornerRadius = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor,paddingTop: 8, paddingLeft: 0,paddingBottom: 8, paddingRight: 0)
        
        
        imageView.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(left: imageView.leftAnchor, bottom: imageView.bottomAnchor, paddingLeft: 6, paddingBottom: 6, width: 300)
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor,left: safeAreaLayoutGuide.leftAnchor,right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: frame.height - 20)
        print(frame.height)
        vv.addSubview(imageView)
        imageView.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor)
        imageView.centerX(inView: vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 2)
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.shadowOpacity = 1
        imageView.layer.cornerRadius = 0
//        
//        let backV = UIView()
////        vv.addSubview(backV)
//        backV.backgroundColor = .black
//        backV.alpha = 0.14
//        backV.anchor(left: vv.leftAnchor, bottom: imageView.bottomAnchor,right: vv.rightAnchor, height: 64)
//        
        
        vv.addSubview(descriptiveLabel)
//        descriptiveLabel.sendSubviewToBack(backV)
        descriptiveLabel.anchor(left: vv.leftAnchor,bottom: imageView.bottomAnchor, paddingLeft: 6,paddingBottom: 4, width: 300)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

