//
//  ProfileFilterView.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 2/2/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ScheduleFilterCell"

protocol ScheduleFilterViewDelegate: class {
    func filterView(_ view: ScheduleFilterView, didSelect index: Int)
}

class ScheduleFilterView: UIView {
    
    
    // MARK: - Properties
    
    weak var delegate: ScheduleFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 1.5
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ScheduleFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,paddingLeft: -5,paddingBottom: 5,
                             width: frame.width / CGFloat(ScheduleFilterOptions.allCases.count) + 10, height: 3.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UICollectionViewDataSource

extension ScheduleFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ScheduleFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ScheduleFilterCell
        
        let filter = ScheduleFilterOptions(rawValue: indexPath.row)
        cell.option = filter
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ScheduleFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = (cell?.frame.origin.x ?? 0) - 5
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScheduleFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ScheduleFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


