//
//  Segmenteds.swift
//  PHYSID
//
//  Created by Apple on 8.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.layer.cornerRadius = 4
            barView.backgroundColor = .gray
            addArrangedSubview(barView)
        } //it's gonna add this barview as many times this for loop runs
        
        arrangedSubviews.first?.backgroundColor = .white
        
        spacing = 4
        distribution = .fillEqually
    }

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int) {
        
        arrangedSubviews.forEach({ $0.backgroundColor = .gray})
        arrangedSubviews[index].backgroundColor = .white
    }
}
