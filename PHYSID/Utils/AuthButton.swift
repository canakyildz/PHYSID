//
//  AuthButton.swift
//  Tinder
//
//  Created by Apple on 24.07.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown

class AuthButton: UIButton {

    init(title: String, type: ButtonType, color: UIColor, backGroundColor: UIColor) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        backgroundColor = backGroundColor
        setTitleColor(color, for: .normal)
        titleLabel?.font = UIFont.customFont(name: "Helvetica Bold", size: 14)
        layer.cornerRadius = 20
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class goToButton: UIButton {
    
    init(title: String, sTitle: String, type: ButtonType) {
        super.init(frame: .zero)
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.white, .font: UIFont.customFont(name: "Helvetica", size: 16)])
        
        attributedTitle.append(NSAttributedString(string: sTitle, attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        setAttributedTitle(attributedTitle, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SecondaryAuthButtons: UIButton {
    
    init(titleOne: String, framerTitle: String,type : ButtonType, titleOneSize: CGFloat, framerTitleSize: CGFloat, overallColor: UIColor) {
        super.init(frame: .zero)
        
        tintColor = overallColor
        setTitle(framerTitle, for: .normal)
        setTitleColor(overallColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: framerTitleSize)
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 2
        title.textColor = overallColor
        title.font = UIFont.systemFont(ofSize: titleOneSize)
        title.text = titleOne
        addSubview(title)
        title.anchor(left: leftAnchor, bottom: topAnchor , paddingLeft: 6, paddingBottom: -20)
        titleLabel?.centerX(inView: title)
        titleLabel?.anchor(top: title.bottomAnchor, paddingTop: 8)
        
        let line = UIView()
        line.backgroundColor = overallColor
        addSubview(line)
        line.alpha = 0
        line.anchor(top: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: -15, paddingLeft: 6, paddingRight: -6, height: 0.4)
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "icson").withRenderingMode(.alwaysTemplate))
        iv.setDimensions(height: 15, width: 15)
        line.addSubview(iv)
        iv.anchor(bottom: line.topAnchor, right: line.rightAnchor, paddingBottom: 20, paddingRight: 5)
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
            line.frame.origin.x = +400
            line.alpha = 1
            
        }) { (_) in
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
