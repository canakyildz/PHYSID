//
//  FoodAdderCell.swift
//  PHYSID
//
//  Created by Apple on 30.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol FoodAdderCellDelegate: class {
    func updateFoodInfo(_ cell: FoodAdderCell)
}

class FoodAdderCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    weak var delegate: FoodAdderCellDelegate?
    

    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleUpdateFoodInfo() {
        delegate?.updateFoodInfo(self)
    }
    
    // MARK: - Helpers

    
}
