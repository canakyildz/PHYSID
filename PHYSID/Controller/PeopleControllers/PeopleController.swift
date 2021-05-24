//
//  PeopleController.swift
//  PHYSID
//
//  Created by Apple on 9.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let secondIdentifier = "PeopleCell"
private let secondaryHeaderIdentifier = "RecipesHeader"

class PeopleController: UIViewController {
    
    // MARK: - Properties
    
    private var users = [User]()
    
    
    var secondaryView: UITableView!
    private lazy var headerView = PeopleHeaderView()
    private var filteredUsers = [User]() {
        didSet { secondaryView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return !headerView.searchGuy.text!.isEmpty
    }
    
    private let exploreController = ExploreController()
    
    private let filterBar = ExploreFilterView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureFilterBar()
        configureUI()
        fetchUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.secondaryView.reloadData()
        print("ne oluyor?")
    }
    
    
    // MARK: - Selectors
    
    // MARK: - API
    
    func fetchUsers() {
        Service.fetchUsers { (users) in
            self.users = users.sorted(by: { (user1, user) -> Bool in
                return user1.profileImageUrl ?? "" > user.profileImageUrl ?? ""
            })
            self.secondaryView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(headerView)
        
        var headerHeight: CGFloat = 0
        
        if view.frame.height < 800 {
            headerHeight = 380
        } else {
            headerHeight = 400
        }
        
        headerView.anchor(top: filterBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 15, height: headerHeight)
        print("tll me the height now \(self.view.frame.width)")
        headerView.delegate = self
        
        secondaryView = UITableView()
        secondaryView.delegate = self
        secondaryView.dataSource = self
        secondaryView.translatesAutoresizingMaskIntoConstraints = false
        secondaryView.separatorStyle = .none
        secondaryView.backgroundColor = .white
        secondaryView.register(PeopleCell.self, forCellReuseIdentifier: secondIdentifier)
        view.addSubview(secondaryView)
        secondaryView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
    }
    
    func configureNav() {
        
        
        navigationController?.isNavigationBarHidden = true
        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor: .clear, titleColor: nil, prefersLargeTitles: false)
    }
    
    func configureFilterBar() {
        filterBar.delegate = self
        view.addSubview(filterBar)
        filterBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingLeft: 20,paddingRight: 20, height: 40)
    }
    
    
    func doSelectionThroughDrops(filter: ExploreFilterOptions) {
        switch filter {
        
        case .people:
            guard let exploreView = exploreController.view else { return }
            exploreView.removeFromSuperview()
            configureUI()
            configureFilterBar()
            fetchUsers()
            
        case .explore:
            headerView.removeFromSuperview()
            secondaryView.removeFromSuperview()
            view.addSubview(exploreController.view)
            exploreController.delegate = self
            exploreController.view.anchor(top: filterBar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 15)
            configureFilterBar()
        }
    }
    
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension PeopleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("filteredfood amount \(users.count)")
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: secondIdentifier, for: indexPath) as! PeopleCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let foodProfile = ProfileController()
        foodProfile.user = user
        let nav = UINavigationController(rootViewController: foodProfile)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
}


// MARK: - PeopleHeaderViewDelegate

extension PeopleController: PeopleHeaderViewDelegate {
    func presentProfileController(root: UINavigationController) {
        present(root, animated: true, completion: nil)
    }
    
    func updateSearchResults(searchContent: String) {
        
        filteredUsers = users.filter({ $0.name.localizedCaseInsensitiveContains(searchContent) ||  (($0.professionType!.localizedCaseInsensitiveContains(searchContent))) })
        secondaryView.reloadData()
    }
}

// MARK: - ExploreFilterViewDelegate


extension PeopleController: ExploreFilterViewDelegate {
    func filterView(_ view: ExploreFilterView, didSelect index: Int) {
        guard let filter = ExploreFilterOptions(rawValue: index) else { return }
        doSelectionThroughDrops(filter: filter)
    }
    
    
}

extension PeopleController: reloadAfterDismissingContent {
    func reloadAfterDismissingContent() {
        guard let filter = ExploreFilterOptions(rawValue: 1) else { return }
        doSelectionThroughDrops(filter: filter)
    }
}
