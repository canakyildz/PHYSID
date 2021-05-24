//
//  DietsController.swift
//  PHYSID
//
//  Created by Apple on 8.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

private let secondIdentifier = "DietsCell"

class DietsController: UIViewController {
    
    var tableView: UITableView!
    private lazy var headerView = DietsHeaderView()
    var diets = [Diet]()
    private var filteredDiets = [Diet]() {
        didSet { tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return !headerView.searchGuy.text!.isEmpty
    }
    
    private lazy var addDietButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post-something"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.isHidden = false
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleAddDiet), for: .touchUpInside)
        return button
    }()
    
            
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDiets()
        configureUI()
        configureNav()
    }
    
    // MARK: - Selectors
    
    @objc func handleAddDiet() {
        let controller = DietAdderController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    

    // MARK: - API

    func fetchDiets() {
        Service.fetchDiets { (diets) in
            self.diets = diets
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {

        var headerHeight: CGFloat = 0
        
        if view.frame.height < 800 {
            headerHeight = 260
        } else {
            headerHeight = 280
        }
        print("tll me the height now \(self.view.frame.width)")
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.913642425, green: 0.9522723668, blue: 0.9234969119, alpha: 1)
        
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight )

        tableView.register(DietsCell.self, forCellReuseIdentifier: secondIdentifier)
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
        view.addSubview(addDietButton)
        addDietButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingBottom: 50, paddingRight: 50)
        
    }
    
    func configureNav() {
        
        
        navigationController?.isNavigationBarHidden = true
        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor: .clear, titleColor: nil, prefersLargeTitles: false)
    }

    
    
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension DietsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("filteredfood amount \(diets.count)")
        return diets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: secondIdentifier, for: indexPath) as! DietsCell
        let diet = diets[indexPath.row]
        cell.diet = diet
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodProfile = DietContentController()
        foodProfile.diet = diets[indexPath.row]
        let nav = UINavigationController(rootViewController: foodProfile)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
}


// MARK: - PeopleHeaderViewDelegate

extension DietsController: DietsHeaderViewDelegate {
    func presentProfileController(root: UINavigationController) {
        present(root, animated: true, completion: nil)
    }
    
    func updateSearchResults(searchContent: String) {
        
        filteredDiets = diets.filter({ $0.dietTitle.localizedCaseInsensitiveContains(searchContent) ||  (($0.dietType!.localizedCaseInsensitiveContains(searchContent))) })
        tableView.reloadData()
    }
}


