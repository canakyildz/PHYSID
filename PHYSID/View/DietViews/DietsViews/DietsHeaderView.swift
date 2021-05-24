//
//  DietsHeaderView.swift
//  PHYSID
//
//  Created by Apple on 8.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DietsHeaderViewCell"

protocol DietsHeaderViewDelegate: class {
    func updateSearchResults(searchContent: String)
//    func presentProfileController(root: UINavigationController)
}

class DietsHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DietsHeaderViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 230)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(DietsHeaderViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let recommendedDiets: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: "Helvetica Bold", size: 21)
        label.font = customFont
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Recommended Diets"
        label.alpha = 1
        return label
    }()
    
    
    lazy var searchButton: UIButton = {
        let search = UIButton(type: .system)
        search.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        search.contentMode = .scaleAspectFill
        search.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        let label = UILabel()
        label.text = "Search for diets"
        label.font = UIFont.customFont(name: "Helvetica Light", size: 13)
        label.textColor = .black
        search.addSubview(label)
        label.anchor(top: search.topAnchor, right: search.leftAnchor,paddingTop: 3, paddingRight: 3)
        return search
    }()
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: 3)
    
    lazy var searchGuy: CustomSearchBar = {
        let searchBar = CustomSearchBar(placeholder: "Search for a user, professional location or profession!", inView: self)
        searchBar.delegate = self
        
        return searchBar
    }()
    
    
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
    
    @objc func showSearchBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.searchGuy.alpha = 1
            self.searchButton.alpha = 0
            self.recommendedDiets.alpha = 0
        }, completion: { finished in
        })
    }
    
    @objc func scrollToNextCell(){

        //get cell size
        let cellSize = CGSize(width: self.frame.width - 24 ,height: self.frame.height);

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
        
        let vv = UIView()
        addSubview(vv)

        vv.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 60, paddingRight: 12)
        vv.layer.shadowOffset = CGSize(width: 1, height: 0.1)
        vv.layer.shadowOpacity = 0.5
        vv.layer.shadowRadius = 2.7
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.layer.cornerRadius = 10
        
        addSubview(barStackView)
        bringSubviewToFront(barStackView)
        barStackView.anchor(top: collectionView.topAnchor, right: collectionView.rightAnchor, paddingTop: 20, paddingRight: 10, width: 32, height: 8)
                
        
        addSubview(recommendedDiets)
        recommendedDiets.anchor(top: collectionView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 10, height: 50)
        
        addSubview(searchGuy)
        searchGuy.anchor(left: collectionView.leftAnchor,right: rightAnchor)
        searchGuy.centerY(inView: recommendedDiets)
        
        addSubview(searchButton)
        searchButton.anchor(right: rightAnchor, paddingRight: 6)
        searchButton.centerY(inView: recommendedDiets)
        
        
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
}


// MARK: - UICollectionViewDelegate

extension DietsHeaderView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension DietsHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorkoutExceptionalHeaderViewModels.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DietsHeaderViewCell
        cell.imageView.image = WorkoutExceptionalHeaderViewModels(rawValue: indexPath.row)?.secondaryImages
        cell.descriptiveLabel.text = WorkoutExceptionalHeaderViewModels(rawValue: indexPath.row)?.secondaryInformation
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout


extension DietsHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - 24), height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UISearchBarDelegate

extension DietsHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        delegate?.updateSearchResults(searchContent: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchGuy.alpha = 0
            self.searchButton.alpha = 1
            self.recommendedDiets.alpha = 1
        }, completion: nil)
    }
    
}



