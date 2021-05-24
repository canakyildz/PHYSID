//
//  DietsHeaderViewCell.swift
//  PHYSID
//
//  Created by Apple on 8.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class DietsHeaderViewCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptiveLabel: UILabel = {
        let label = UILabel()
        label.text = "You know the vibes"
        label.textColor = .white
        label.numberOfLines = 5
        label.layer.shadowOffset = CGSize(width: 0.01, height: 1)
        label.layer.shadowOpacity = 1
        label.layer.shadowColor = UIColor.black.cgColor
        label.font = UIFont.customFont(name: "Helvetica Light", size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingTop: 8, paddingLeft: 0,paddingBottom: 8, paddingRight: 0)
        
        
        imageView.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(left: imageView.leftAnchor, bottom: imageView.bottomAnchor, paddingLeft: 6, paddingBottom: 6, width: 300)
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: frame.height - 20)
        print(frame.height)
        vv.addSubview(imageView)
        imageView.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor)
        imageView.centerX(inView: vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 2)
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.shadowOpacity = 1
        
        vv.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(left: vv.leftAnchor,bottom: vv.bottomAnchor, paddingLeft: 6,paddingBottom: 2, width: 300)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
