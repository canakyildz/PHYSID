//
//  WorkoutSecondaryHeaderView.swift
//  PHYSID
//
//  Created by Apple on 7.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "WorkoutConditionBasedHeaderCell"

class WorkoutConditionBasedHeader: UIView {
    
    // MARK: - Properties
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 320)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(WorkoutConditionBasedHeaderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0)
        
        addSubview(barStackView)
        bringSubviewToFront(barStackView)
        barStackView.anchor(bottom: collectionView.bottomAnchor, right: collectionView.rightAnchor, paddingBottom: 20, paddingRight: 10, width: 32, height: 8)
        
    }
    
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

    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
    
}


// MARK: - UICollectionViewDelegate

extension WorkoutConditionBasedHeader: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension WorkoutConditionBasedHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorkoutExceptionalHeaderViewModels.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WorkoutConditionBasedHeaderCell
        cell.imageView.image = WorkoutExceptionalHeaderViewModels(rawValue: indexPath.row)?.firstImages
        cell.descriptiveLabel.text = WorkoutExceptionalHeaderViewModels(rawValue: indexPath.row)?.firstInformation
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //do segmented bar highlighting here
        barStackView.setHighlighted(index: indexPath.row)

    }
}

// MARK: - UICollectionViewDelegateFlowLayout


extension WorkoutConditionBasedHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width), height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




