//
//  PeopleHeaderView.swift
//  PHYSID
//
//  Created by Apple on 9.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol PeopleHeaderViewDelegate: class {
    func updateSearchResults(searchContent: String)
    func presentProfileController(root: UINavigationController)
}

private let reuseIdentifier = "PeopleHeaderCell"

class PeopleHeaderView: UIView {
    
    
    // MARK: - Properties
    
    
    weak var delegate: PeopleHeaderViewDelegate?
    private var users = [User]()
    private var filteredUsers = [User]()
    
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
        cv.register(PeopleHeaderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let popularProsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Popular \nProfessionals"
        label.alpha = 1
        return label
    }()
    
    private let recommendedUsersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Recommended Users"
        label.alpha = 1
        return label
    }()
    
    
    lazy var searchButton: UIButton = {
        let search = UIButton(type: .system)
        search.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        search.contentMode = .scaleAspectFill
        search.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        let label = UILabel()
        label.text = "Search for users"
        label.font = UIFont.customFont(name: "Helvetica Light", size: 13)
        label.textColor = .black
        search.addSubview(label)
        label.anchor(top: search.topAnchor, right: search.leftAnchor,paddingTop: 3, paddingRight: 3)
        return search
    }()
    
    lazy var searchGuy: CustomSearchBar = {
        let searchBar = CustomSearchBar(placeholder: "Search for a user, professional location or profession!", inView: self)
        searchBar.delegate = self
        
        return searchBar
    }()

    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchUsers()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func showSearchBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.searchGuy.alpha = 1
            self.searchButton.alpha = 0
            self.recommendedUsersLabel.alpha = 0
        }, completion: { finished in
        })
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(popularProsLabel)
        popularProsLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, height: 55)
        
        
        addSubview(collectionView)
        collectionView.anchor(top: popularProsLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: -5, paddingLeft: 10, height: 275)
        print("tll me the heightw \(frame.height)")


        
        let underline = UnderLineView()
        addSubview(underline)
        underline.anchor(top: collectionView.bottomAnchor, left: collectionView.leftAnchor, right: collectionView.rightAnchor,paddingTop: 0, paddingLeft: 10, paddingRight: 5, height: 0.3)
        
        
        addSubview(recommendedUsersLabel)
        recommendedUsersLabel.anchor(top: underline.bottomAnchor, left: underline.leftAnchor, right: underline.rightAnchor, paddingTop: 8, paddingLeft: 0, height: 50)
        
        addSubview(searchGuy)
        searchGuy.anchor(left: collectionView.leftAnchor,right: underline.rightAnchor)
        searchGuy.centerY(inView: recommendedUsersLabel)
        
        addSubview(searchButton)
        searchButton.anchor(right: underline.rightAnchor, paddingRight: 6)
        searchButton.centerY(inView: recommendedUsersLabel)
        
    }
    
    func fetchUsers() {
        Service.fetchUsers { (users) in
            self.users = users
            self.filteredUsers = users.filter({ $0.isProfessional == true })
            self.collectionView.reloadData()
            
        }
    }
    
}


// MARK: - UICollectionViewDelegate

extension PeopleHeaderView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension PeopleHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PeopleHeaderCell
        let user = filteredUsers[indexPath.row]
        cell.filteredUser = user
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        let controller = ProfileController()
        controller.user = user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        delegate?.presentProfileController(root: nav)
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout


extension PeopleHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var customWidth: CGFloat = 0
        var customHeight: CGFloat = 0
        
        if self.frame.width < 400 {
            customWidth = self.frame.width - (self.frame.width / 2)
            customHeight = (collectionView.frame.height - collectionView.frame.height / 7)
        } else {
            customWidth = self.frame.width - (self.frame.width / 1.80)
            customHeight = (collectionView.frame.height - collectionView.frame.height / 6.5)
        }
        
        return CGSize(width: customWidth, height: customHeight)
        
    }
}

// MARK: - UISearchBarDelegate

extension PeopleHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        delegate?.updateSearchResults(searchContent: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchGuy.alpha = 0
            self.searchButton.alpha = 1
            self.recommendedUsersLabel.alpha = 1
        }, completion: nil)
    }
    
}


