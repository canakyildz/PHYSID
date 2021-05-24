//
//  RecipesHeader.swift
//  PHYSID
//
//  Created by Apple on 21.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol RecipesHeaderDelegate: class {
    func updateSearchResults(searchContent: String)
    func headerSorting(sorterPattern: String)
}

private let reuseIdentifier = "RecipesHeaderCell"

class RecipesHeader: UIView {
    
    
    // MARK: - Properties
    
    weak var delegate: RecipesHeaderDelegate?
    
    var didSelect: Bool = false
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 70)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(RecipesHeaderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    lazy var searchButton: UIButton = {
        let search = UIButton(type: .system)
        search.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        search.contentMode = .scaleAspectFill
        search.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        let label = UILabel()
        label.text = "Search"
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .black
        search.addSubview(label)
        label.anchor(top: search.topAnchor, right: search.leftAnchor, paddingRight: 3)
        return search
    }()
    
    
    lazy var searchGuy: CustomSearchBar = {
        let searchBar = CustomSearchBar(placeholder: "Search for foods and recipes", inView: self)
        searchBar.delegate = self
        
        return searchBar
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        searchGuy.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func showSearchBar() {
        didSelect = false
        UIView.animate(withDuration: 0.5, animations: {
            self.searchGuy.alpha = 1
            self.searchButton.alpha = 0
        }, completion: { finished in
        })
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -5, paddingLeft: 12, paddingBottom: 50)
        
        addSubview(searchGuy)
        searchGuy.anchor(top: collectionView.bottomAnchor, left: collectionView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 110)
        
        
        let favsButton = UIButton(type: .system)
        favsButton.setImage(#imageLiteral(resourceName: "icons8-star-50"), for: .normal)
        favsButton.tintColor = .black
        favsButton.contentMode = .scaleAspectFit
        favsButton.backgroundColor = .white
        favsButton.layer.cornerRadius = 5
        favsButton.imageView?.setDimensions(height: 17, width: 18)
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-sorting-24"), for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.imageView?.setDimensions(height: 20, width: 20)
        
        
        let filterStack = UIStackView(arrangedSubviews: [favsButton,button])
        filterStack.axis = .horizontal
        filterStack.spacing = -8
        filterStack.distribution = .fillEqually
        addSubview(filterStack)
        filterStack.anchor(top: searchGuy.topAnchor, bottom: searchGuy.bottomAnchor, right: rightAnchor, paddingTop: 6, paddingBottom: 6, paddingRight: 10)
        
        addSubview(searchButton)
        searchButton.anchor(top: searchGuy.searchTextField.topAnchor, right: filterStack.leftAnchor,paddingTop: 9,paddingLeft: 5, width: 20, height: 20)
        
        let underline = UnderLineView()
        addSubview(underline)
        underline.anchor(top: searchGuy.bottomAnchor, left: searchGuy.leftAnchor, right: filterStack.rightAnchor,paddingTop: 5, paddingLeft: 0, paddingRight: 5, height: 0.3)
        
        
    }
}


// MARK: - UICollectionViewDelegate

extension RecipesHeader: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension RecipesHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecipesHeaderSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipesHeaderCell
        cell.profileImageView.image = RecipesHeaderSections(rawValue: indexPath.row)?.sectionImage
        cell.titleLabel.text = "  \(RecipesHeaderSections(rawValue: indexPath.row)?.description.uppercased() ?? "")"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sorter = RecipesHeaderSections(rawValue: indexPath.row)?.description else { return }
        if indexPath.row == 0 {
            didSelect = false
        } else {
            didSelect = true
        }
        
        delegate?.headerSorting(sorterPattern: sorter)
        

        print(didSelect)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout


extension RecipesHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var customWidth: CGFloat = 0
        
        if self.frame.width < 400 {
            customWidth = self.frame.width - self.frame.width / 2.3
        } else {
            customWidth = self.frame.width - self.frame.width / 2.9
        }
        
        return CGSize(width: customWidth, height: collectionView.frame.height - collectionView.frame.height / 40)
    }
}

// MARK: - UISearchBarDelegate

extension RecipesHeader: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        delegate?.updateSearchResults(searchContent: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchGuy.alpha = 0
            self.searchButton.alpha = 1
        }, completion: nil)
    }
    
}

