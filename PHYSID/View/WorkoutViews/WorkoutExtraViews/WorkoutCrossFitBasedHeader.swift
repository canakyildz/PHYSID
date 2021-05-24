//
//  WorkoutCrossFitBasedHeader.swift
//  PHYSID
//
//  Created by Apple on 8.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "WorkoutCrossFitBasedHeaderCell"

class WorkoutCrossFitBasedHeader: UIView {
    
    // MARK: - Properties
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 330)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(WorkoutCrossFitBasedHeaderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: 3)
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func scrollToNextCell(){

        //get cell size
        let cellSize = CGSize(width: self.frame.width,height: self.frame.height);

        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset;

        if collectionView.contentSize.width <= collectionView.contentOffset.x + cellSize.width
        {
            collectionView.scrollRectToVisible(CGRect(x:0,y: contentOffset.y,width: cellSize.width,height: cellSize.height), animated: true);

        } else {
            collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width,y: contentOffset.y, width: cellSize.width,height: cellSize.height), animated: true);

        }

    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(collectionView)
         collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0)
        
        addSubview(barStackView)
        bringSubviewToFront(barStackView)
        barStackView.anchor(bottom: collectionView.bottomAnchor, right: collectionView.rightAnchor, paddingBottom: 20, paddingRight: 10, width: 32, height: 8)
        
        
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
}


// MARK: - UICollectionViewDelegate

extension WorkoutCrossFitBasedHeader: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension WorkoutCrossFitBasedHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorkoutExceptionalHeaderViewModels.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WorkoutCrossFitBasedHeaderCell
        cell.imageView.image = WorkoutExceptionalHeaderViewModels(rawValue: indexPath.row)?.secondaryImages
        cell.descriptiveLabel.text = WorkoutExceptionalHeaderViewModels(rawValue: indexPath.row)?.secondaryInformation
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout


extension WorkoutCrossFitBasedHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width), height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}



