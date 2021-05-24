//
//  LunchView.swift
//  PHYSID
//
//  Created by Apple on 25.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol LunchViewDelegate: class {
    func presentFoodThroughLunchView(_ nav: UINavigationController)
}

private let reuseIdentifier = "RecipesCell"

class LunchView: UIView {
    
    // MARK: - Properties
    var tableView: UITableView!
    var user: User?
    var foods = [Food]()
    weak var delegate: LunchViewDelegate?
    private let headerView = LunchHeaderView()
    private lazy var addFoodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post-something"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 16.5
        button.isHidden = false
        //play with it
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleAddFood), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: - Selectors
    
    @objc func handleAddFood() {
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(RecipesCell.self, forCellReuseIdentifier: reuseIdentifier)
        addSubview(tableView)
        
        
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 5, width: frame.width, height: 100)
        
        addSubview(addFoodButton)
        addFoodButton.anchor(bottom: tableView.bottomAnchor,paddingBottom: 10)
        addFoodButton.centerX(inView: tableView)
        
    }    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension LunchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipesCell
        cell.food = foods[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = foods[indexPath.row]
        let foodProfile = FoodProfileController(food: food)
        let nav = UINavigationController(rootViewController: foodProfile)
        nav.modalPresentationStyle = .fullScreen
        delegate?.presentFoodThroughLunchView(nav)
    }
    
    
}
