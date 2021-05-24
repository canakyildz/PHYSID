//
//  CustomSearchBar.swift
//  PHYSID
//
//  Created by Apple on 17.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    init(placeholder: String, inView view: UIView) {
        super.init(frame: .zero)
        
        weak var delegate: UISearchBarDelegate?

        alpha = 0
        layoutIfNeeded()
        isTranslucent = false
        barTintColor = .white
        tintColor = .black
        layoutIfNeeded()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        let textField = self.value(forKey: "searchBarTextField") as! UITextField
        textField.font = UIFont.customFont(name: "Helvetica Bold", size: 15)
        textField.placeholder = placeholder
        textField.textColor = .black
        textField.tintColor = .black
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.backgroundColor = .white
        textField.clearButtonMode = .never
        textField.leftViewMode = .never
        textField.leftView = .none
        textField.rightViewMode = .always
        showsCancelButton = true
        delegate?.searchBarCancelButtonClicked?(self)

        
        
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors

}


