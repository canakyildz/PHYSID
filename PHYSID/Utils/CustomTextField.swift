//
//  CustomTextField.swift
//  Tinder
//
//  Created by Apple on 23.07.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    init(titleholder: String, isSecureField: Bool? = false) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        keyboardAppearance = .dark
        
        let line = UIView()
        line.backgroundColor = .white
        addSubview(line)
        line.alpha = 0
        line.anchor(top: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: -4, paddingLeft: 6, paddingRight: 6, height: 0.5)
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
            line.frame.origin.x = +400
            line.alpha = 1
            
        }) { (_) in
            
        }
        
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.customFont(name: "Helvetica", size: 16)
        title.text = titleholder
        addSubview(title)
        title.anchor(left: leftAnchor, bottom: topAnchor , paddingLeft: 6, paddingBottom: -10)
        borderStyle = .none
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        isSecureTextEntry = isSecureField!
        textColor = .white
        
    }
    
    class CustomSettingField: UITextField {
        init(placeholder: String) {
            super.init(frame: .zero)
            
            borderStyle = .none
            font = UIFont.customFont(name: "Helvetica", size: 16)
            textColor = .white
            keyboardAppearance = .dark
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.white])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
